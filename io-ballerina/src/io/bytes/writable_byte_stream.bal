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

# ReadableByteStream creates and return a readable byte stream..
public class WritableByteStream {

    # Return a readable byte stream.
    public function write(byte[] content) returns Error? {
        return writeBlockExtern(self, content);
    }

    public function close() returns Error? {
        return closeWritableByteStreamExtern(self);
    }
}

public function openWritableByteStreamFromFile(string path) returns WritableByteStream|Error {
    return openBufferedOutputStreamFromFileExtern(path);
}

function openBufferedOutputStreamFromFileExtern(string path) returns WritableByteStream|Error = @java:Method {
    name: "openBufferedOutputStreamFromFile",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteStreamUtils"
} external;

isolated function writeBlockExtern(WritableByteStream writableByteStream, byte[] content) returns Error? = @java:Method {
    name: "writeBlock",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteStreamUtils"
} external;

isolated function closeWritableByteStreamExtern(WritableByteStream writableByteStream) returns Error? = @java:Method {
    name: "closeBufferedOutputStream",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteStreamUtils"
} external;

