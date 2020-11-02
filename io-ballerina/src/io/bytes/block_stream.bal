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

type Block readonly & byte[];

# BlockStream used to initialize a byte stream.
public class BlockStream {
    private ReadableByteChannel readableByteChannel;
    private int blockSize;
    private boolean isClosed = false;

    public function init(ReadableByteChannel readableByteChannel, int blockSize) {
        self.readableByteChannel = readableByteChannel;
        self.blockSize = blockSize;
    }

    public isolated function next() returns record {| Block value; |}? {
        var block = readBlock(self.readableByteChannel, self.blockSize);
        if (block is byte[]) {
            record {| Block value; |} value = {value: <Block>block.cloneReadOnly()};
            return value;
        } else {
            var closeResult = closeInputStream(self.readableByteChannel);
            return ();
        }
    }

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
