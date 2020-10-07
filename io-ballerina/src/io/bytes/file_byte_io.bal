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

# Read the entire file content as a byte array.
# ```ballerina
# byte[]|io:Error content = io:fileReadBytes("./resources/myfile.txt");
# ```
# + path - File path
# + return - Either a byte array or `io:Error`
public function fileReadBytes(@untainted string path) returns @tainted byte[]|Error {
    return fileReadBytesExtern(path);
}

# Write a set of bytes to a file.
# ```ballerina
# byte[] content = [60, 78, 39, 28];
# io:Error? result = io:fileWriteBytes("./resources/myfile.txt", content);
# ```
# + path - File path
# + content - Byte content to write
# + return - `io:Error` or else `()`
public function fileWriteBytes(@untainted string path, byte[] content) returns Error? {
	return fileWriteBytesExtern(path, content);
}

function fileReadBytesExtern(string path) returns @tainted byte[]|Error = @java:Method {
    name: "readBytes",
    'class: "org.ballerinalang.stdlib.io.file.FileIO"
} external;

function fileWriteBytesExtern(string path, byte[] content) returns Error? = @java:Method {
    name: "writeBytes",
    'class: "org.ballerinalang.stdlib.io.file.FileIO"
} external;
