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

# Read the entire file content as a byte array.
# ```ballerina
# byte[]|io:Error content = io:fileReadBytes("./resources/myfile.txt");
# ```
# + path - File path
# + return - Either a read only byte array or `io:Error`
public function fileReadBytes(@untainted string path) returns @tainted readonly & byte[]|Error {
    var byteChannel = openReadableFile(path);
    if (byteChannel is ReadableByteChannel) {
        return channelReadBytes(byteChannel);
    } else {
        return byteChannel;
    }
}

# Read the entire file content as a stream of blocks.
# ```ballerina
# stream<io:Block>|io:Error content = io:fileReadBlocksAsStream("./resources/myfile.txt", 1000);
# ```
# + path - File path
# + blockSize - Block size
# + return - Either a byte block stream or `io:Error`
public function fileReadBlocksAsStream(string path, int blockSize) returns stream<byte[]>|Error? {
    var byteChannel = openReadableFile(path);
    if (byteChannel is ReadableByteChannel) {
        return channelReadBlocksAsStream(byteChannel, blockSize);
    } else {
        return byteChannel;
    }
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
    var byteChannel = openWritableFile(path);
    if (byteChannel is WritableByteChannel) {
        return channelWriteBytes(byteChannel, content);
    } else {
        return byteChannel;
    }
}

# Write a byte stream to a file.
# ```ballerina
# byte[] content = [[60, 78, 39, 28]];
# stream<byte[], io:Error> byteStream = content.toStream();
# io:Error? result = io:fileWriteBlocksFromStream("./resources/myfile.txt", byteStream);
# ```
# + path - File path
# + byteStream - Byte stream to write
# + return - `io:Error` or else `()`
public function fileWriteBlocksFromStream(@untainted string path, stream<byte[]> byteStream) returns Error? {

    var byteChannel = openWritableFile(path);
    if (byteChannel is WritableByteChannel) {
        return channelWriteBlocksFromStream(byteChannel, byteStream);
    } else {
        return byteChannel;
    }
}
