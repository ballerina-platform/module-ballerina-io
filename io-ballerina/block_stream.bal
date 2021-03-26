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

import ballerina/jballerina.java;

public type Block readonly & byte[];

# `BlockStream` used to initialize a stream of type `Block`. This `BlockStream` refers to the stream that embedded to
# the I/O byte channels.
public class BlockStream {
    private ReadableByteChannel readableByteChannel;
    private int blockSize;
    private boolean isClosed = false;

    # Initialize a `BlockStream` using a `io:ReadableByteChannel`.
    #
    # + readableByteChannel - The `io:ReadableByteChannel` that this block stream is referred to
    # + blockSize - The size of a block as an integer
    public isolated function init(ReadableByteChannel readableByteChannel, int blockSize) {
        self.readableByteChannel = readableByteChannel;
        self.blockSize = blockSize;
    }

    # The next function reads and return the next block of the related stream.
    #
    # + return - Returns a `io:Block` when a block is avaliable in the stream or return null when the stream reaches the end
    public isolated function next() returns record {| Block value; |}|Error? {
        byte[]|Error block = readBlock(self.readableByteChannel, self.blockSize);
        if (block is byte[]) {
            record {| Block value; |} value = {value: <Block>block.cloneReadOnly()};
            return value;
        } else if (block is EofError){
            Error? closeResult = closeInputStream(self.readableByteChannel);
            return ();
        } else {
            return block;
        }
    }

    # Close the stream. The primary usage of this function is to close the stream without reaching the end.
    # If the stream reaches the end, the `blockStream.next()` will automatically close the stream.
    #
    # + return - Returns null when the closing was successful or an `io:Error`
    public isolated function close() returns Error? {
        if (!self.isClosed) {
            var closeResult = closeInputStream(self.readableByteChannel);
            if (closeResult is ()) {
                self.isClosed = true;
            }
            return closeResult;
        }
        return ();
    }
}

isolated function readBlock(ReadableByteChannel readableByteChannel, int blockSize) returns byte[]|Error = @java:Method {
    name: "readBlock",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteChannelUtils"
} external;

isolated function closeInputStream(ReadableByteChannel readableByteChannel) returns Error? = @java:Method {
    name: "closeInputStream",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteChannelUtils"
} external;
