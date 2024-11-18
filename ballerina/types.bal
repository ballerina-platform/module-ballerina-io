// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# The iterator for the stream returned in `readFileCsvAsStream` function.
public class CsvIterator {
    private boolean isClosed = false;
    public isolated function next() returns record {|anydata value;|}|error? {
        if self.isClosed {
            return closedStreamInvocationError();
        } else {
            record{}|string[]|Error? result = nextResult(self);
            if result is record{} || result is string[] {
                return {value: result};
            } else if result is EofError {
                self.isClosed = true;
                check closeResult(self);
                return;
            } else {
                return result;
            }
        }
    }

    public isolated function close() returns Error? {
        if !self.isClosed {
            var closeResult = closeResult(self);
            if closeResult is () {
                self.isClosed = true;
            }
            return closeResult;
        }
        return;
    }
}

isolated function nextResult(CsvIterator iterator) returns record{}|string[]|Error? = @java:Method {
    name: "streamNext",
    'class: "io.ballerina.stdlib.io.nativeimpl.RecordChannelUtils"
} external;

isolated function closeResult(CsvIterator iterator) returns Error? = @java:Method {
    name: "closeStream",
    'class: "io.ballerina.stdlib.io.nativeimpl.RecordChannelUtils"
} external;

isolated function closedStreamInvocationError() returns Error {
    return error GenericError("Stream closed");
}
