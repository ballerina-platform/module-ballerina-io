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

# The read-only byte array that is used to read the byte content from the streams.
public type Block readonly & byte[];

# A stream of `Block` objects that is used to read the byte content from the streams.
public class BlockStream {
    private ReadableByteChannel readableByteChannel;
    private int blockSize;
    private boolean isClosed = false;

    # Initializes a stream of `Block` objects.
    #
    # + readableByteChannel - The `io:ReadableByteChannel` that this block stream is referred to
    # + blockSize - The size of a block as an integer
    public isolated function init(ReadableByteChannel readableByteChannel, int blockSize) {
        self.readableByteChannel = readableByteChannel;
        self.blockSize = blockSize;
    }

    # Reads the next block of the stream.
    #
    # + return - An `io:Block` when a block is available in the stream or returns `()` when the stream reaches the end
    public isolated function next() returns record {|Block value;|}|Error? {
        byte[]|Error block = readBlock(self.readableByteChannel, self.blockSize);
        if block is byte[] {
            record {|Block value;|} value = {value: <Block>block.cloneReadOnly()};
            return value;
        } else if block is EofError {
            return closeInputStream(self.readableByteChannel);
        } else {
            return block;
        }
    }

    # Closes the stream manually.
    # If not invoked, the stream closes automatically upon reaching end-of-stream.
    #
    # + return - `()` when the closing was successful or an `io:Error`
    public isolated function close() returns Error? {
        if !self.isClosed {
            var closeResult = closeInputStream(self.readableByteChannel);
            if closeResult is () {
                self.isClosed = true;
            }
            return closeResult;
        }
        return;
    }
}

isolated function readBlock(ReadableByteChannel readableByteChannel, int blockSize) returns byte[]|Error = @java:Method {
    name: "readBlock",
    'class: "io.ballerina.stdlib.io.nativeimpl.ByteChannelUtils"
} external;

isolated function closeInputStream(ReadableByteChannel readableByteChannel) returns Error? = @java:Method {
    name: "closeInputStream",
    'class: "io.ballerina.stdlib.io.nativeimpl.ByteChannelUtils"
} external;
