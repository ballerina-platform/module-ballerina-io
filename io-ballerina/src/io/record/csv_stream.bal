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

import ballerina/java;

# CSVStream used to initialize the string stream of CSV records.
public class CSVStream {
    private ReadableTextRecordChannel readableTextRecordChannel;

    public function init(ReadableTextRecordChannel readableTextRecordChannel) {
        self.readableTextRecordChannel = readableTextRecordChannel;
    }

    public isolated function next() returns record {| string[] value; |}? {
        var recordValue = readRecord(self.readableTextRecordChannel, COMMA);
        if (recordValue is string[]) {
            record {| string[] value; |} value = {value: <string[]>recordValue.cloneReadOnly()};
            return value;
        } else {
            var closeResult = closeRecordReader(self.readableTextRecordChannel);
            return ();
        }
    }

    public isolated function close() returns Error? {
        return closeRecordReader(self.readableTextRecordChannel);
    }
}

isolated function readRecord(ReadableTextRecordChannel readableTextRecordChannel, string seperator) returns string[]|
Error = @java:Method {
    name: "readRecord",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.RecordChannelUtils"
} external;

isolated function closeRecordReader(ReadableTextRecordChannel readableTextRecordChannel) returns Error? = @java:Method {
    name: "closeBufferedReader",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.RecordChannelUtils"
} external;
