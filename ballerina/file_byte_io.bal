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

# Reads the entire file content as a byte array.
# ```ballerina
# byte[]|io:Error content = io:fileReadBytes("./resources/myfile.txt");
# ```
# + path - The file path
# + return - A read-only byte array or an `io:Error`
public isolated function fileReadBytes(string path) returns readonly & byte[]|Error {
    return channelReadBytes(check openReadableFile(path));
}

# Reads the entire file content as a stream of blocks.
# ```ballerina
# stream<io:Block, io:Error?>|io:Error content = io:fileReadBlocksAsStream("./resources/myfile.txt", 1000);
# ```
# + path - The file path
# + blockSize - An optional size of the byte block. The default size is 4KB
# + return - A byte block stream or an `io:Error`
public isolated function fileReadBlocksAsStream(string path, int blockSize = 4096) returns stream<Block, Error?>|
Error {
    return channelReadBlocksAsStream(check openReadableFile(path), blockSize);
}

# Writes a set of bytes to a file.
# ```ballerina
# byte[] content = [60, 78, 39, 28];
# io:Error? result = io:fileWriteBytes("./resources/myfile.txt", content);
# ```
# + path - The file path
# + content - Byte content to write
# + option - Indicate whether to overwrite or append the given content
# + return - An `io:Error` if the write operation fails, or ()
public isolated function fileWriteBytes(string path, byte[] content, FileWriteOption option = OVERWRITE) returns
Error? {
    return channelWriteBytes(check openWritableFile(path, option), content);
}

# Writes a byte stream to a file.
# ```ballerina
# byte[] content = [[60, 78, 39, 28]];
# stream<byte[], io:Error?> byteStream = content.toStream();
# io:Error? result = io:fileWriteBlocksFromStream("./resources/myfile.txt", byteStream);
# ```
# + path - The file path
# + byteStream - Byte stream to write
# + option - Indicate whether to overwrite or append the given content
# + return - An `io:Error` if the write operation fails, or ()
public isolated function fileWriteBlocksFromStream(string path, stream<byte[], Error?> byteStream,
                                                    FileWriteOption option = OVERWRITE) returns Error? {
    return channelWriteBlocksFromStream(check openWritableFile(path, option), byteStream);
}
