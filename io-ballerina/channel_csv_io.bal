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

function channelReadCsv(ReadableChannel readableChannel, int skipHeaders = 0) returns @tainted string[][]|Error {
    var csvChannel = getReadableCSVChannel(readableChannel, skipHeaders);
    if (csvChannel is ReadableCSVChannel) {
        string[][] results = [];
        int i = 0;

        while (csvChannel.hasNext()) {
            var records = csvChannel.getNext();
            if (records is string[]) {
                results[i] = records;
                i += 1;
            } else if (records is Error) {
                var closeResult = csvChannel.close();
                return records;
            }
        }
        var closeResult = csvChannel.close();
        return results;
    } else {
        return csvChannel;
    }
}

function channelReadCsvAsStream(ReadableChannel readableChannel) returns @tainted stream<string[]>|Error {
    var csvChannel = getReadableCSVChannel(readableChannel, 0);
    if (csvChannel is ReadableCSVChannel) {
        return csvChannel.csvStream();
    } else {
        return csvChannel;
    }
}

function channelWriteCsv(WritableChannel writableChannel, string[][] content) returns Error? {
    var csvChannel = getWritableCSVChannel(writableChannel);
    if (csvChannel is WritableCSVChannel) {
        foreach string[] r in content {
            var writeResult = csvChannel.write(r);
            if (writeResult is Error) {
                var closeResult = csvChannel.close();
                return writeResult;
            }
        }
        var closeResult = csvChannel.close();
        if (closeResult is Error) {
            return closeResult;
        }
    } else {
        return csvChannel;
    }
}

function channelWriteCsvFromStream(WritableChannel writableChannel, stream<string[]> content) returns Error? {
    var csvChannel = getWritableCSVChannel(writableChannel);
    if (csvChannel is WritableCSVChannel) {
        error? e = content.forEach(function(string[] stringContent) {
                                       if (csvChannel is WritableCSVChannel) {
                                           var r = csvChannel.write(stringContent);
                                       }
                                   });
        if (e is Error) {
            return e;
        }
        var closeResult = csvChannel.close();
        if (closeResult is Error) {
            return closeResult;
        }
    } else {
        return csvChannel;
    }
}

function getReadableCSVChannel(ReadableChannel readableChannel, int skipHeaders) returns ReadableCSVChannel|Error {
    ReadableCSVChannel readableCSVChannel;

    if (readableChannel is ReadableByteChannel) {
        ReadableCharacterChannel readableCharacterChannel = new (readableChannel, DEFAULT_ENCODING);
        readableCSVChannel = new ReadableCSVChannel(readableCharacterChannel, COMMA, skipHeaders);
    } else if (readableChannel is ReadableCharacterChannel) {
        readableCSVChannel = new ReadableCSVChannel(readableChannel, COMMA, skipHeaders);
    } else if (readableChannel is ReadableCSVChannel) {
        readableCSVChannel = readableChannel;
    } else {
        TypeMismatchError e = TypeMismatchError(
        "Expected ReadableByteChannel/ReadableCharacterChannel/ReadableCSVChannel but found a " + 'value:toString(typeof 
        readableChannel));
        return e;
    }
    return readableCSVChannel;
}

function getWritableCSVChannel(WritableChannel writableChannel) returns WritableCSVChannel|Error {
    WritableCSVChannel writableCSVChannel;

    if (writableChannel is WritableByteChannel) {
        WritableCharacterChannel writableCharacterChannel = new (writableChannel, DEFAULT_ENCODING);
        writableCSVChannel = new WritableCSVChannel(writableCharacterChannel);
    } else if (writableChannel is WritableCharacterChannel) {
        writableCSVChannel = new WritableCSVChannel(writableChannel);
    } else if (writableChannel is WritableCSVChannel) {
        writableCSVChannel = writableChannel;
    } else {
        TypeMismatchError e = TypeMismatchError(
        "Expected WritableByteChannel/WritableCharacterChannel/WritableCSVChannel but found a " + 'value:toString(typeof 
        writableChannel));
        return e;
    }
    return writableCSVChannel;
}
