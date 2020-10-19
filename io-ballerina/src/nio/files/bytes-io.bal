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

# Read the entire channel content as a byte array.
# ```ballerina
# byte[]|io:Error content = io:channelReadBytes(readableChannel);
# ```
# + channel - Readable channel
# + return - Either a byte array or `io:Error`
public function channelReadBytes(ReadableChannel channel) returns @tainted readonly & byte[]|Error {}

# Read the entire channel content as a stream of chunks.
# ```ballerina
# stream<byte[], io:Error>|io:Error content = io:channelReadBlocksAsStream(readableChannel, 1000);
# ```
# + channel - Readable channel
# + n - Chunk size
# + return - Either a byte chunk stream or `io:Error`
public function channelReadBlocksAsStream(ReadableChannel channel, 
                                       @untainted int n = 4096) returns @tainted readonly & stream<byte[], Error>|Error {}

# Write a set of bytes to a channel.
# ```ballerina
# byte[] content = [60, 78, 39, 28];
# io:Error? result = io:channelWriteBytes(writableChannel, content);
# ```
# + channel - Writable channel
# + content - Byte content to write
# + return - `io:Error` or else `()`
public function channelWriteBytes(WritableChannel channel, byte[] content) returns Error? {}

# Write a byte stream to a channel.
# ```ballerina
# byte[] content = [[60, 78, 39, 28]];
# stream<byte[], io:Error> byteStream = content.toStream();
# io:Error? result = io:channelWriteBlocksFromStream(writableChannel, byteStream);
# ```
# + channel - Writable channel
# + content - Byte content to write
# + return - `io:Error` or else `()`
public function channelWriteBlocksFromStream(WritableChannel channel, 
                                          stream<byte[], Error>) returns Error? {}

