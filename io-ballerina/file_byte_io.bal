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
# + path - The path of the file
# + return - Either a read only byte array or `io:Error`
public isolated function fileReadBytes(@untainted string path) returns @tainted readonly & byte[]|Error {
    return channelReadBytes(check openReadableFile(path));
}

# Read the entire file content as a stream of blocks.
# ```ballerina
# stream<io:Block, io:Error?>|io:Error content = io:fileReadBlocksAsStream("./resources/myfile.txt", 1000);
# ```
# + path - The path of the file
# + blockSize - An optional size of the byte block. Default size is 4KB
# + return - Either a byte block stream or `io:Error`
public isolated function fileReadBlocksAsStream(string path, int blockSize = 4096) returns @tainted stream<Block, Error?>|
Error {
    return channelReadBlocksAsStream(check openReadableFile(path), blockSize);
}

# Write a set of bytes to a file.
# ```ballerina
# byte[] content = [60, 78, 39, 28];
# io:Error? result = io:fileWriteBytes("./resources/myfile.txt", content);
# ```
# + path - The path of the file
# + content - Byte content to write
# + option - To indicate whether to overwrite or append the given content
# + return - `io:Error` or else `()`
public isolated function fileWriteBytes(@untainted string path, byte[] content, FileWriteOption option = OVERWRITE) returns 
Error? {
    return channelWriteBytes(check openWritableFile(path, option), content);
}

# Write a byte stream to a file.
# ```ballerina
# byte[] content = [[60, 78, 39, 28]];
# stream<byte[], io:Error?> byteStream = content.toStream();
# io:Error? result = io:fileWriteBlocksFromStream("./resources/myfile.txt", byteStream);
# ```
# + path - The path of the file
# + byteStream - Byte stream to write
# + option - To indicate whether to overwrite or append the given content
# + return - `io:Error` or else `()`
public isolated function fileWriteBlocksFromStream(@untainted string path, stream<byte[], Error?> byteStream,
                                                   FileWriteOption option = OVERWRITE) returns Error? {
    return channelWriteBlocksFromStream(check openWritableFile(path, option), byteStream);
}
