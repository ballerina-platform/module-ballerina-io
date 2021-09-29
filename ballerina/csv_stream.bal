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

# The `io:CSVStream` is used to initialize a stream of type CSV records. This `io:CSVStream` refers to the stream
# that is embedded to the I/O record channels.
public class CSVStream {
    private ReadableTextRecordChannel readableTextRecordChannel;
    private boolean isClosed = false;

    # Initialize a `CSVStream` using an `io:ReadableTextRecordChannel`.
    #
    # + readableTextRecordChannel - The `io:ReadableTextRecordChannel` that this CSV stream is referred to
    public isolated function init(ReadableTextRecordChannel readableTextRecordChannel) {
        self.readableTextRecordChannel = readableTextRecordChannel;
    }

    # The next function reads and returns the next CSV record of the related stream.
    #
    # + return - A CSV record as a string array when a record is avaliable in the stream or
    # `()` when the stream reaches the end
    public isolated function next() returns record {| string[] value; |}|Error? {
        var recordValue = getNext(self.readableTextRecordChannel);
        if (recordValue is string[]) {
            record {| string[] value; |} value = {value: <string[]>recordValue.cloneReadOnly()};
            return value;
        } else if (recordValue is EofError) {
            Error? closeResult = self.close();
            return ();
        } else {
            return recordValue;
        }
    }

    # Close the stream. The primary usage of this function is to close the stream without reaching the end.
    # If the stream reaches the end, the `csvStream.next()` will automatically close the stream.
    #
    # + return - `()` when the closing was successful or an `io:Error`
    public isolated function close() returns Error? {
        if (!self.isClosed) {
            var closeResult = closeExtern(self.readableTextRecordChannel);
            if (closeResult is ()) {
                self.isClosed = true;
            }
            return closeResult;
        }
        return ();
    }
}

isolated function getNext(ReadableTextRecordChannel readableTextRecordChannel) returns string[]|
Error = @java:Method {
    name: "getNext",
    'class: "io.ballerina.stdlib.io.nativeimpl.RecordChannelUtils"
} external;

isolated function closeExtern(ReadableTextRecordChannel readableTextRecordChannel) returns Error? = @java:Method {
    name: "close",
    'class: "io.ballerina.stdlib.io.nativeimpl.RecordChannelUtils"
} external;
