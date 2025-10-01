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
import ballerina/jballerina.java;

# A stream of CSV records that is used to read the CSV content from the streams.
public class CSVStream {
    private ReadableTextRecordChannel readableTextRecordChannel;
    private boolean isClosed = false;

    # Initializes a stream of CSV records.
    #
    # + readableTextRecordChannel - The `io:ReadableTextRecordChannel` that this CSV stream is referred to
    public isolated function init(ReadableTextRecordChannel readableTextRecordChannel) {
        self.readableTextRecordChannel = readableTextRecordChannel;
    }

    # Reads the next CSV record of the stream.
    #
    # + return - A CSV record as a string array when a record is available in the stream or
    # `()` when the stream reaches the end
    public isolated function next() returns record {|string[] value;|}|Error? {
        var recordValue = readRecord(self.readableTextRecordChannel);
        if recordValue is string[] {
            record {|string[] value;|} value = {value: <string[]>recordValue.cloneReadOnly()};
            return value;
        } else if recordValue is EofError {
            check closeRecordReader(self.readableTextRecordChannel);
            return;
        } else {
            return recordValue;
        }
    }

    # Closes the stream manually.
    # If not invoked, the stream closes automatically upon reaching end-of-stream.
    #
    # + return - `()` when the closing was successful or an `io:Error`
    public isolated function close() returns Error? {
        if !self.isClosed {
            var closeResult = closeRecordReader(self.readableTextRecordChannel);
            if closeResult is () {
                self.isClosed = true;
            }
            return closeResult;
        }
        return;
    }
}

isolated function readRecord(ReadableTextRecordChannel readableTextRecordChannel) returns string[]|
Error = @java:Method {
    name: "readRecord",
    'class: "io.ballerina.stdlib.io.nativeimpl.RecordChannelUtils"
} external;

isolated function closeRecordReader(ReadableTextRecordChannel readableTextRecordChannel) returns Error? = @java:Method {
    name: "closeBufferedReader",
    'class: "io.ballerina.stdlib.io.nativeimpl.RecordChannelUtils"
} external;
