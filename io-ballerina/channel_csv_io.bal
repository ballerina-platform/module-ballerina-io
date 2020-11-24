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

# Read channel content as a CSV.
# ```ballerina
# string[][]|io:Error content = io:channelReadCsv(readableChannel);
# ```
# + readableChannel - A readable channel.
# The possible inputs are `io:ReadableByteChannel`, `io:ReadableCharacterChannel` or `io:ReadableCSVChannel`.
# + skipHeaders - Number of headers, which should be skipped prior to reading records
# + return - The entire CSV content in the channel as an array of string arrays or an `io:Error`
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

# Read channel content as a CSV.
# ```ballerina
# stream<string[]>|io:Error content = io:channelReadCsvAsStream(readableChannel);
# ```
# + readableChannel - A readable channel.
# The possible inputs are `io:ReadableByteChannel`, `io:ReadableCharacterChannel` or `io:ReadableCSVChannel`.
# + return - The entire CSV content in the channel a stream of string arrays or an `io:Error`
function channelReadCsvAsStream(ReadableChannel readableChannel) returns @tainted stream<string[]>|Error {
    var csvChannel = getReadableCSVChannel(readableChannel, 0);
    if (csvChannel is ReadableCSVChannel) {
        return csvChannel.csvStream();
    } else {
        return csvChannel;
    }
}

# Write CSV content to a channel.
# ```ballerina
# string[][] content = [["Anne", "Johnson", "SE"], ["John", "Cameron", "QA"]];
# io:Error? result = io:channelWriteCsv(writableChannel, content);
# ```
# + writableChannel - A writable channel.
# The possible inputs are `io:WritableByteChannel`, `io:WritableCharacterChannel`, or `io:WritableCSVChannel`.
# + content - CSV content as an array of string arrays
# + return - Either an `io:Error` or the null `()` value when the writing was successful
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

# Write CSV record stream to a channel.
# ```ballerina
# string[][] content = [["Anne", "Johnson", "SE"], ["John", "Cameron", "QA"]];
# stream<string[]> recordStream = content.toStream();
# io:Error? result = io:channelWriteCsv(writableChannel, recordStream);
# ```
# + writableChannel - A writable channel.
# # The possible inputs are `io:WritableByteChannel`, `io:WritableCharacterChannel`, or `io:WritableCSVChannel`.
# + content - A CSV record stream to be written
# + return - Either an `io:Error` or the null `()` value when the writing was successful
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
