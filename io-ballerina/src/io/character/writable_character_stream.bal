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

# WritableCharacterStream creates and return a writable byte stream.
public class WritableCharacterStream {

    # Writes a line.
    public function writeLine(string content) returns Error? {
        return writeLine(self, content);
    }

    # Writes a string record.
    public function writeRecord(string[] content, string seperator) returns Error? {
        return writeRecordToStream(self, content, seperator);
    }

    public function close() returns Error? {
        return closeWritableCharacterStreamExtern(self);
    }
}

public function openWritableCharacterStreamFromFile(string path) returns WritableCharacterStream|Error {
    return openBufferedWriterFromFileExtern(path);
}

function openBufferedWriterFromFileExtern(string path) returns WritableCharacterStream|Error = @java:Method {
    name: "openBufferedWriterFromFile",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterStreamUtils"
} external;

isolated function writeLine(WritableCharacterStream writableCharacterStream, string line) returns Error? = @java:Method {
    name: "writeLine",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterStreamUtils"
} external;

isolated function writeRecordToStream(WritableCharacterStream writableCharacterStream,
                                      string[] recordValue, string separator) returns Error? = @java:Method {
    name: "writeRecord",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterStreamUtils"
} external;

isolated function closeWritableCharacterStreamExtern(WritableCharacterStream writableCharacterStream) returns Error? = @java:Method {
    name: "closeBufferedWriter",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterStreamUtils"
} external;

