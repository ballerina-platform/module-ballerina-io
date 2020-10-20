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

# ReadableCharacterStream creates and return a readable character stream..
public class ReadableCharacterStream {

    # Return a readable string stream of line.
    public function lineStream() returns stream<string>|Error? {
        LineStream lineStream = new(self);
        return new stream<string>(lineStream);
    }
}

# LineStream used to initialize the string stream of lines.
public class LineStream {
    private ReadableCharacterStream readableCharacterStream;

    public function init(ReadableCharacterStream readableCharacterStream) {
        self.readableCharacterStream = readableCharacterStream;
    }

    public isolated function next() returns record {|string value;|}? {
        var line = readLine(self.readableCharacterStream);
        if (line is string) {
            record {|string value;|} value = {value: <string> line.cloneReadOnly()};
            return value;
        } else {
            return ();
        }
    }
}

public function openReadableCharacterStreamFromFile(string path) returns ReadableCharacterStream|Error {
    return openBufferedReaderFromFileExtern(path);
}

function openBufferedReaderFromFileExtern(string path) returns ReadableCharacterStream|Error = @java:Method {
    name: "openBufferedReaderFromFile",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterStreamUtils"
} external;

isolated function readLine(ReadableCharacterStream readableCharacterStream) returns string|Error = @java:Method {
    name: "readLine",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterStreamUtils"
} external;

