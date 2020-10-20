// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

package org.ballerinalang.stdlib.io.nativeimpl;

import io.ballerina.runtime.api.StringUtils;
import io.ballerina.runtime.api.ValueCreator;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.values.ArrayValue;
import org.ballerinalang.stdlib.io.utils.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.IOException;
import java.util.StringJoiner;

import static org.ballerinalang.stdlib.io.utils.IOConstants.IO_PACKAGE_ID;

public class CharacterStreamUtils {
    private static final String READ_CHARACTER_STREAM_CLASS = "ReadableCharacterStream";
    private static final String WRITE_CHARACTER_STREAM_CLASS = "WritableCharacterStream";
    private static final String BUFFERED_READER_ENTRY = "bufferedReader";
    private static final String BUFFERED_WRITER_ENTRY = "bufferedWriter";
    private static final Logger log = LoggerFactory.getLogger(CharacterStreamUtils.class);

    public static Object openBufferedReaderFromFile(BString filePath) {
        BObject characterStreamObj = ValueCreator.createObjectValue(IO_PACKAGE_ID, READ_CHARACTER_STREAM_CLASS);
        try {
            FileReader fileReader = new FileReader(filePath.getValue());
            BufferedReader bufferedReader = new BufferedReader(fileReader);
            characterStreamObj.addNativeData(BUFFERED_READER_ENTRY, bufferedReader);
            return characterStreamObj;
        } catch (FileNotFoundException e) {
            log.error(e.toString());
            return IOUtils.createError(e);
        }
    }

    public static Object openBufferedWriterFromFile(BString filePath) {
        BObject characterStreamObj = ValueCreator.createObjectValue(IO_PACKAGE_ID, WRITE_CHARACTER_STREAM_CLASS);
        try {
            FileWriter fileWriter = new FileWriter(filePath.getValue());
            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
            characterStreamObj.addNativeData(BUFFERED_WRITER_ENTRY, bufferedWriter);
            return characterStreamObj;
        } catch (FileNotFoundException e) {
            log.error(e.toString());
            return IOUtils.createError(e);
        } catch (IOException e) {
            log.error(e.toString());
            return IOUtils.createError(e.toString());
        }
    }

    public static Object readLine(BObject readableCharacterStreamObj) {
        BufferedReader bufferedReader = (BufferedReader)
                readableCharacterStreamObj.getNativeData(BUFFERED_READER_ENTRY);
        try {
            String line = bufferedReader.readLine();
            if (line == null) {
                bufferedReader.close();
                return IOUtils.createEoFError();
            }
            return StringUtils.fromString(line);
        } catch (IOException e) {
            log.error(e.toString());
            return IOUtils.createError(e.toString());
        }
    }

    public static Object readRecord(BObject readableCharacterStreamObj, BString separator) {
        BufferedReader bufferedReader = (BufferedReader)
                readableCharacterStreamObj.getNativeData(BUFFERED_READER_ENTRY);
        try {
            String line = bufferedReader.readLine();
            if (line == null) {
                bufferedReader.close();
                return IOUtils.createEoFError();
            }
            String[] record = line.strip().split(separator.getValue());
            return ValueCreator.createArrayValue(StringUtils.fromStringArray(record));
        } catch (IOException e) {
            log.error(e.toString());
            return IOUtils.createError(e.toString());
        }
    }

    public static Object writeLine(BObject readableCharacterStreamObj, BString bLine) {
        BufferedWriter bufferedWriter = (BufferedWriter)
                readableCharacterStreamObj.getNativeData(BUFFERED_WRITER_ENTRY);
        try {
            String line = bLine.getValue();
            bufferedWriter.write(line, 0, line.length());
            bufferedWriter.newLine();
            return null;
        } catch (IOException e) {
            log.error(e.toString());
            return IOUtils.createError(e.toString());
        }
    }

    public static Object writeRecord(BObject readableCharacterStreamObj, ArrayValue record, BString separator) {
        BufferedWriter bufferedWriter = (BufferedWriter)
                readableCharacterStreamObj.getNativeData(BUFFERED_WRITER_ENTRY);
        try {
            String[] recordStringArray = record.getStringArray();
            StringJoiner stringJoiner = new StringJoiner(separator.getValue());
            for(int i = 0; i < recordStringArray.length; i++) {
                stringJoiner.add(recordStringArray[i]);
            }
            String line = stringJoiner.toString();
            bufferedWriter.write(line, 0, line.length());
            bufferedWriter.newLine();
            return null;
        } catch (IOException e) {
            log.error(e.toString());
            return IOUtils.createError(e.toString());
        }
    }

    public static Object closeBufferedWriter(BObject readableCharacterStreamObj) {
        BufferedWriter bufferedWriter = (BufferedWriter)
                readableCharacterStreamObj.getNativeData(BUFFERED_WRITER_ENTRY);
        try {
            bufferedWriter.close();
            return null;
        } catch (IOException e) {
            log.error(e.toString());
            return IOUtils.createError(e.toString());
        }
    }
}
