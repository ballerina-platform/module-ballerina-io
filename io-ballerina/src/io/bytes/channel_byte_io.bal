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

import ballerina/lang.'value;

# Read the entire channel content as a byte array.
# ```ballerina
# byte[]|io:Error content = io:channelReadBytes(readableChannel);
# ```
# + readableChannel - A readable channel
# + return - Either a readonly byte array or `io:Error`
public function channelReadBytes(ReadableChannel readableChannel) returns @tainted readonly & byte[]|Error {
    if (readableChannel is ReadableByteChannel) {
        var result = readableChannel.readAll();
        var closeResult = readableChannel.close();
        return result;
    } else {
        TypeMismatchError e = TypeMismatchError("Expected ReadableByteChannel but found a " +
        'value:toString(typeof readableChannel));
        return e;
    }
}

# Read the entire channel content as a stream of blocks.
# ```ballerina
# stream<io:Block>|io:Error content = io:channelReadBlocksAsStream(readableChannel, 1000);
# ```
# + readableChannel - A readable channel
# + blockSize - An optional size of the byte block. Default size is 4KB.
# + return - Either a byte block stream or `io:Error`
public function channelReadBlocksAsStream(ReadableChannel readableChannel, int blockSize=4096) returns stream<byte[]>|Error? {
    if (readableChannel is ReadableByteChannel) {
        return readableChannel.blockStream(blockSize);
    } else {
        TypeMismatchError e = TypeMismatchError("Expected ReadableByteChannel but found a " +
        'value:toString(typeof readableChannel));
        return e;
    }
}

# Write a set of bytes to a channel.
# ```ballerina
# byte[] content = [60, 78, 39, 28];
# io:Error? result = io:channelWriteBytes(writableChannel, content);
# ```
# + writableChannel - A writable channel
# + content - Byte content to write
# + return - `io:Error` or else `()`
public function channelWriteBytes(WritableChannel writableChannel, byte[] content) returns Error? {
    if (writableChannel is WritableByteChannel) {
        var r = writableChannel.write(content, 0);
        var closeResult = writableChannel.close();
        if (closeResult is Error) {
            return closeResult;
        }
    } else {
        TypeMismatchError e = TypeMismatchError("Expected WritableByteChannel but found a " +
        'value:toString(typeof writableChannel));
        return e;
    }
}

# Write a byte stream to a channel.
# ```ballerina
# byte[] content = [[60, 78, 39, 28]];
# stream<byte[], io:Error> byteStream = content.toStream();
# io:Error? result = io:channelWriteBlocksFromStream(writableChannel, byteStream);
# ```
# + writableChannel - A writable channel
# + byteStream - Byte stream to write
# + return - `io:Error` or else `()`
public function channelWriteBlocksFromStream(WritableChannel writableChannel, stream<byte[]> byteStream) returns Error? {
    if (writableChannel is WritableByteChannel) {
        error? e = byteStream.forEach(function(byte[] byteContent) {
                                          if (writableChannel is WritableByteChannel) {
                                              var r = writableChannel.write(byteContent, 0);
                                          }
                                      });
        var closeResult = writableChannel.close();
        if (e is Error) {
            return e;
        }
        if (closeResult is Error) {
            return closeResult;
        }
    } else {
        TypeMismatchError e = TypeMismatchError("Expected WritableByteChannel but found a " + 'value:toString(typeof
        writableChannel));
        return e;
    }
}
