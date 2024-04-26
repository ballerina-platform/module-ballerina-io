/*
 * Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.io.nativeimpl;

import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.StructureType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.io.channels.base.CharacterChannel;
import io.ballerina.stdlib.io.channels.base.DelimitedRecordChannel;
import io.ballerina.stdlib.io.csv.Format;
import io.ballerina.stdlib.io.readers.CharacterChannelReader;
import io.ballerina.stdlib.io.utils.BallerinaIOException;
import io.ballerina.stdlib.io.utils.IOConstants;
import io.ballerina.stdlib.io.utils.IOUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.channels.ClosedChannelException;
import java.util.ArrayList;
import java.util.Map;


import static io.ballerina.stdlib.io.utils.IOConstants.CSV_RETURN_TYPE;
import static io.ballerina.stdlib.io.utils.IOConstants.HEADER_NAMES;
import static io.ballerina.stdlib.io.utils.IOConstants.ITERATOR_NAME;
import static io.ballerina.stdlib.io.utils.IOConstants.TXT_RECORD_CHANNEL_NAME;

/**
 * This class hold Java inter-ops bridging functions for io# *CSVChannel/*RTextRecordChannel.
 *
 * @since 1.1.0
 */
public class RecordChannelUtils {

    private static final String DEFAULT = "default";
    private static final String BUFFERED_READER_ENTRY = "bufferedReader";
    private static final String IS_CLOSED = "isClosed";

    private RecordChannelUtils() {
    }

    public static void initRecordChannel(BObject textRecordChannel, BObject characterChannelInfo,
                                         BString fieldSeparator, BString recordSeparator, BString format) {
        try {
            //Will get the relevant byte channel and will create a character channel
            CharacterChannel characterChannel = (CharacterChannel) characterChannelInfo
                    .getNativeData(IOConstants.CHARACTER_CHANNEL_NAME);
            BufferedReader bufferedReader = new BufferedReader(new CharacterChannelReader(characterChannel));
            DelimitedRecordChannel delimitedRecordChannel;
            if (DEFAULT.equals(format.getValue())) {
                delimitedRecordChannel = new DelimitedRecordChannel(characterChannel, recordSeparator.getValue(),
                        fieldSeparator.getValue());
            } else {
                delimitedRecordChannel = new DelimitedRecordChannel(characterChannel,
                        Format.valueOf(format.getValue()));
            }
            textRecordChannel.addNativeData(TXT_RECORD_CHANNEL_NAME, delimitedRecordChannel);
            textRecordChannel.addNativeData(BUFFERED_READER_ENTRY, bufferedReader);
            textRecordChannel.addNativeData(IS_CLOSED, false);
        } catch (Exception e) {
            String message =
                    "error occurred while converting character channel to textRecord channel: " + e.getMessage();
            throw IOUtils.createError(message);
        }
    }

    public static boolean hasNext(BObject channel) {
        Object textChannel = channel.getNativeData(TXT_RECORD_CHANNEL_NAME);
        if (textChannel == null) {
            return false;
        }
        DelimitedRecordChannel textRecordChannel = (DelimitedRecordChannel) textChannel;
        if (!textRecordChannel.hasReachedEnd()) {
            try {
                return textRecordChannel.hasNext();
            } catch (BallerinaIOException e) {
                String msg = "error occurred while checking hasNext on ReadableTextRecordChannel: " + e.getMessage();
                throw IOUtils.createError(msg);
            }
        }
        return false;
    }

    public static Object getNext(BObject channel) {
        if (isChannelClosed(channel)) {
            return IOUtils.createError("Record channel is already closed.");
        }
        DelimitedRecordChannel textRecordChannel =
                (DelimitedRecordChannel) channel.getNativeData(TXT_RECORD_CHANNEL_NAME);
        if (textRecordChannel.hasReachedEnd()) {
            return IOUtils.createEoFError();
        } else {
            try {
                String[] records = textRecordChannel.read();
                return StringUtils.fromStringArray(records);
            } catch (BallerinaIOException e) {
                return IOUtils.createError(e);
            }
        }
    }

    public static Object getAllRecords(BObject channel, int skipHeaders, BTypedesc typeDesc) {
        Type describingType = TypeUtils.getReferredType(typeDesc.getDescribingType());
        if (isChannelClosed(channel)) {
            return IOUtils.createError("Record channel is already closed.");
        }
        DelimitedRecordChannel textRecordChannel =
                (DelimitedRecordChannel) channel.getNativeData(TXT_RECORD_CHANNEL_NAME);
        if (textRecordChannel.hasReachedEnd()) {
            return IOUtils.createEoFError();
        }
        try {
            if (describingType.getTag() == TypeTags.RECORD_TYPE_TAG) {
                StructureType structType = (StructureType) describingType;
                ArrayList<Object> outList = new ArrayList<>();
                ArrayList<String> headerNames = new ArrayList<>();
                String[] record;
                while (textRecordChannel.hasNext()) {
                    if (headerNames.size() == 0) {
                        record = textRecordChannel.read();
                        for (String header : record) {
                            headerNames.add(header.trim());
                        }
                        validateHeaders(headerNames, structType);
                        continue;
                    }
                    record = textRecordChannel.read();
                    if (skipHeaders > 1) {
                        skipHeaders -= 1;
                        continue;
                    }
                    Object returnStruct = CsvChannelUtils.getStruct(record, structType, headerNames);
                    if (returnStruct instanceof BError) {
                        return returnStruct;
                    }
                    Map<String, Object> struct = (Map<String, Object>) returnStruct;
                    if (record.length != structType.getFields().size()) {
                        return IOUtils.createError("Record type and CSV file does not match.");
                    }
                    outList.add(ValueCreator.createRecordValue(describingType.getPackage(),
                            describingType.getName(), struct));

                }
                Object[] out = outList.toArray();
                return ValueCreator.createArrayValue(out, TypeCreator.createArrayType(describingType));
            } else if (describingType.getTag() == TypeTags.ARRAY_TAG) {
                ArrayList<BArray> outList = new ArrayList<>();
                while (textRecordChannel.hasNext()) {
                    String[] record = textRecordChannel.read();
                    if (skipHeaders != 0) {
                        skipHeaders -= 1;
                        continue;
                    }
                    outList.add(StringUtils.fromStringArray(record));
                }
                Object[] out = outList.toArray();
                return ValueCreator.createArrayValue(out, TypeCreator.createArrayType(describingType));
            } else {
                return IOUtils.createError(String.format("Only 'string[]' and 'record{}' types are supported, " +
                        "but found '%s' ", describingType.getName()));
            }
        } catch (BallerinaIOException e) {
            return IOUtils.createError(e);
        } catch (BError e) {
            return e;
        } finally {
            close(channel);
        }
    }

    public static Object streamNext(BObject iterator) {
        BObject channel = (BObject) iterator.getNativeData(ITERATOR_NAME);
        BufferedReader bufferedReader = (BufferedReader) channel.getNativeData(BUFFERED_READER_ENTRY);
        BTypedesc typeDesc = (BTypedesc) iterator.getNativeData(CSV_RETURN_TYPE);
        Type describingType = TypeUtils.getReferredType(typeDesc.getDescribingType());
        try {
            String line = bufferedReader.readLine();
            if (line == null) {
                bufferedReader.close();
                return IOUtils.createEoFError();
            }
            DelimitedRecordChannel textRecordChannel =
                    (DelimitedRecordChannel) channel.getNativeData(TXT_RECORD_CHANNEL_NAME);
            if (describingType.getTag() == TypeTags.RECORD_TYPE_TAG) {
                StructureType structType = (StructureType) describingType;
                String[] record = textRecordChannel.getFields(line);
                if (!iterator.getNativeData().containsKey(HEADER_NAMES)) {
                    ArrayList<String> headers = new ArrayList<>();
                    for (String header : record) {
                        headers.add(header.trim());
                    }
                    validateHeaders(headers, structType);
                    iterator.addNativeData(HEADER_NAMES, headers);
                    line = bufferedReader.readLine();
                    record = textRecordChannel.getFields(line);
                }
                ArrayList<String> headerNames = (ArrayList<String>) iterator.getNativeData(HEADER_NAMES);
                Object returnStruct = CsvChannelUtils.getStruct(record, structType, headerNames);
                if (returnStruct instanceof BError) {
                    return returnStruct;
                }
                final Map<String, Object> struct = (Map<String, Object>) returnStruct;
                if (record.length != structType.getFields().size()) {
                    bufferedReader.close();
                    return IOUtils.createError("Record type and CSV file does not match.");
                }
                return ValueCreator.createRecordValue(describingType.getPackage(), describingType.getName(),
                        struct);
            }
            String[] records = textRecordChannel.getFields(line);
            return StringUtils.fromStringArray(records);
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
    }

    public static Object readRecord(BObject channel) {
        BufferedReader bufferedReader = (BufferedReader) channel.getNativeData(BUFFERED_READER_ENTRY);
        try {
            String line = bufferedReader.readLine();
            if (line == null) {
                bufferedReader.close();
                return IOUtils.createEoFError();
            }
            DelimitedRecordChannel textRecordChannel =
                    (DelimitedRecordChannel) channel.getNativeData(TXT_RECORD_CHANNEL_NAME);
            String[] record = textRecordChannel.getFields(line);
            return StringUtils.fromStringArray(record);
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
    }

    public static Object write(BObject channel, BArray content) {
        if (isChannelClosed(channel)) {
            return IOUtils.createError("Record channel is already closed.");
        }
        DelimitedRecordChannel delimitedRecordChannel = (DelimitedRecordChannel) channel
                .getNativeData(TXT_RECORD_CHANNEL_NAME);
        try {
            delimitedRecordChannel.write(content.getStringArray());
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
        return null;
    }

    public static Object close(BObject channel) {
        if (isChannelClosed(channel)) {
            return IOUtils.createError("Record channel is already closed.");
        }
        DelimitedRecordChannel recordChannel = (DelimitedRecordChannel) channel.getNativeData(TXT_RECORD_CHANNEL_NAME);
        try {
            BufferedReader bufferedReader = (BufferedReader)
                    channel.getNativeData(BUFFERED_READER_ENTRY);
            bufferedReader.close();
            recordChannel.close();
            channel.addNativeData(IS_CLOSED, true);
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
        return null;
    }

    private static boolean isChannelClosed(BObject channel) {
        if (channel.getNativeData(IS_CLOSED) != null) {
            return (boolean) channel.getNativeData(IS_CLOSED);
        }
        return false;
    }

    public static Object closeBufferedReader(BObject channel) {
        try {
            BufferedReader bufferedReader = (BufferedReader)
                    channel.getNativeData(BUFFERED_READER_ENTRY);
            bufferedReader.close();
        } catch (ClosedChannelException e) {
            return IOUtils.createError("Record channel is already closed.");
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
        return null;
    }

    public static Object closeStream(BObject iterator) {
        BObject channel = (BObject) iterator.getNativeData(ITERATOR_NAME);
        try {
            BufferedReader bufferedReader = (BufferedReader)
                    channel.getNativeData(BUFFERED_READER_ENTRY);
            bufferedReader.close();
        } catch (ClosedChannelException e) {
            return IOUtils.createError("Record channel is already closed.");
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
        return null;
    }

    private static void validateHeaders(ArrayList<String> headers, StructureType structType) {
        if (headers.size() != structType.getFields().size()) {
            throw IOUtils.createError(String.format("The CSV file content header count" +
                            "(%s) doesn't match with ballerina record field count(%s). ",
                    headers.size(), structType.getFields().size()));
        }
        for (String key : structType.getFields().keySet()) {
            if (!headers.contains(key.trim())) {
                throw IOUtils.createError(String.format("The Record does not contain the " +
                        "field - %s. ", key.trim()));
            }
        }
    }
}
