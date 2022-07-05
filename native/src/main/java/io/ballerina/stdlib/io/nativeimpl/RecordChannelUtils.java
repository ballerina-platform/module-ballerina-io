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
import io.ballerina.runtime.api.values.BArray;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.channels.ClosedChannelException;
import java.util.ArrayList;
import java.util.Map;


import static io.ballerina.stdlib.io.utils.IOConstants.CSV_RETURN_TYPE;
import static io.ballerina.stdlib.io.utils.IOConstants.ITERATOR_NAME;
import static io.ballerina.stdlib.io.utils.IOConstants.TXT_RECORD_CHANNEL_NAME;

/**
 * This class hold Java inter-ops bridging functions for io# *CSVChannel/*RTextRecordChannel.
 *
 * @since 1.1.0
 */
public class RecordChannelUtils {

    private static final Logger log = LoggerFactory.getLogger(RecordChannelUtils.class);
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
            log.error(message, e);
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
                log.error(msg, e);
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
                log.error("error occurred while reading next text record from ReadableTextRecordChannel", e);
                return IOUtils.createError(e);
            }
        }
    }

    public static Object getAllRecords(BObject channel, int skipHeaders, BTypedesc typeDesc) {
        int headersSkipped = 1 - skipHeaders;
        Type describingType = typeDesc.getDescribingType();
        if (isChannelClosed(channel)) {
            return IOUtils.createError("Record channel is already closed.");
        }
        DelimitedRecordChannel textRecordChannel =
                (DelimitedRecordChannel) channel.getNativeData(TXT_RECORD_CHANNEL_NAME);
        if (textRecordChannel.hasReachedEnd()) {
            return IOUtils.createEoFError();
        } else {
            try {
                if (describingType.getTag() == TypeTags.RECORD_TYPE_TAG) {
                    StructureType structType = (StructureType) describingType;
                    ArrayList<Object> outList = new ArrayList<Object>();
                    while (textRecordChannel.hasNext()) {
                        String[] record = textRecordChannel.read();
                        if (headersSkipped == 0) {
                            headersSkipped = 1;
                            continue;
                        }
                        final Map<String, Object> struct = CsvChannelUtils.getStruct(record, structType);
                        if (struct != null) {
                            outList.add(ValueCreator.createRecordValue(describingType.getPackage(),
                                    describingType.getName(), struct));
                        } else {
                            return IOUtils.createError("Record type and CSV file does not match.");
                        }
                    }
                    Object[] out = outList.toArray();
                    return ValueCreator.createArrayValue(out, TypeCreator.createArrayType(describingType));
                } else {
                    ArrayList<BArray> outList = new ArrayList<BArray>();
                    while (textRecordChannel.hasNext()) {
                        String[] record = textRecordChannel.read();
                        if (skipHeaders == 1) {
                            skipHeaders = 0;
                        } else {
                            outList.add(StringUtils.fromStringArray(record));
                        }
                    }
                    Object[] out = outList.toArray();
                    return ValueCreator.createArrayValue(out, TypeCreator.createArrayType(describingType));
                }
            } catch (BallerinaIOException e) {
                log.error("error occurred while reading next text record from ReadableTextRecordChannel", e);
                return IOUtils.createError(e);
            }
        }
    }

    public static Object streamNext(BObject iterator) {
        BObject channel = (BObject) iterator.getNativeData(ITERATOR_NAME);
        BufferedReader bufferedReader = (BufferedReader) channel.getNativeData(BUFFERED_READER_ENTRY);

        BTypedesc typeDesc = (BTypedesc) iterator.getNativeData(CSV_RETURN_TYPE);
        Type describingType = typeDesc.getDescribingType();

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
                final Map<String, Object> struct = CsvChannelUtils.getStruct(record, structType);
                if (struct != null) {
                    return ValueCreator.createRecordValue(describingType.getPackage(), describingType.getName(),
                                struct);
                } else {
                    return IOUtils.createError("Record type and CSV file does not match."); /// change to nill
                }
            } else {
                String[] records = textRecordChannel.getFields(line);
                return StringUtils.fromStringArray(records);
            }
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
}
