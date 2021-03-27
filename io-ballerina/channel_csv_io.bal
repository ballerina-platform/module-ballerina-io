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
import ballerina/lang.'value;

isolated function channelReadCsv(ReadableChannel readableChannel, int skipHeaders = 0) returns @tainted string[][]|
Error {
    ReadableCSVChannel csvChannel = check getReadableCSVChannel(readableChannel, skipHeaders);
    string[][] results = [];
    int i = 0;

    while (csvChannel.hasNext()) {
        var records = csvChannel.getNext();
        if (records is string[]) {
            results[i] = records;
            i += 1;
        } else if (records is Error) {
            Error? closeResult = csvChannel.close();
            return records;
        }
    }
    Error? closeResult = csvChannel.close();
    return results;
}

isolated function channelReadCsvAsStream(ReadableChannel readableChannel) returns @tainted stream<string[], Error?>|
Error {
    return (check getReadableCSVChannel(readableChannel, 0)).csvStream();
}

isolated function channelWriteCsv(WritableChannel writableChannel, string[][] content) returns Error? {
    WritableCSVChannel csvChannel = check getWritableCSVChannel(writableChannel);
    foreach string[] r in content {
        var writeResult = csvChannel.write(r);
        if (writeResult is Error) {
            Error? closeResult = csvChannel.close();
            return writeResult;
        }
    }
    check csvChannel.close();
}

isolated function channelWriteCsvFromStream(WritableChannel writableChannel, stream<string[], Error?> csvStream) returns
Error? {
    WritableCSVChannel csvChannel = check getWritableCSVChannel(writableChannel);
    record {| string[] value; |}|Error? csvRecord = csvStream.next();
    while (csvRecord is record {| string[] value; |}) {
        Error? writeResult = csvChannel.write(csvRecord.value);
        csvRecord = csvStream.next();
    }
    var closeResult = csvChannel.close();
    if (csvRecord is Error) {
        return csvRecord;
    }
    if (closeResult is Error) {
        return closeResult;
    }
}

isolated function getReadableCSVChannel(ReadableChannel readableChannel, int skipHeaders) returns ReadableCSVChannel|
Error {
    ReadableCSVChannel readableCSVChannel;

    if (readableChannel is ReadableByteChannel) {
        ReadableCharacterChannel readableCharacterChannel = new (readableChannel, DEFAULT_ENCODING);
        readableCSVChannel = new ReadableCSVChannel(readableCharacterChannel, COMMA, skipHeaders);
    } else if (readableChannel is ReadableCharacterChannel) {
        readableCSVChannel = new ReadableCSVChannel(readableChannel, COMMA, skipHeaders);
    } else if (readableChannel is ReadableCSVChannel) {
        readableCSVChannel = readableChannel;
    } else {
        TypeMismatchError e = error TypeMismatchError("Expected ReadableByteChannel/ReadableCharacterChannel/ReadableCSVChannel but found a " + 
        'value:toString(typeof readableChannel));
        return e;
    }
    return readableCSVChannel;
}

isolated function getWritableCSVChannel(WritableChannel writableChannel) returns WritableCSVChannel|Error {
    WritableCSVChannel writableCSVChannel;

    if (writableChannel is WritableByteChannel) {
        WritableCharacterChannel writableCharacterChannel = new (writableChannel, DEFAULT_ENCODING);
        writableCSVChannel = new WritableCSVChannel(writableCharacterChannel);
    } else if (writableChannel is WritableCharacterChannel) {
        writableCSVChannel = new WritableCSVChannel(writableChannel);
    } else if (writableChannel is WritableCSVChannel) {
        writableCSVChannel = writableChannel;
    } else {
        TypeMismatchError e = error TypeMismatchError("Expected WritableByteChannel/WritableCharacterChannel/WritableCSVChannel but found a " + 
        'value:toString(typeof writableChannel));
        return e;
    }
    return writableCSVChannel;
}
