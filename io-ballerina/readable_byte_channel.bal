// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# ReadableByteChannel represents an input resource (i.e file). which could be used to source bytes.
# A file path or an in-memory `byte` array can be used to obtain a `io:ReadableByteChannel`.
# A `io:ReadableByteChannel` do not support initilization, and it should be obtained using the following methods or implement natively.
# `io:openReadableFile("./files/sample.txt")` - used to obtain a `io:ReadableByteChannel` from a given file path
# `io:createReadableChannel(byteArray)` - used to obtain a `io:ReadableByteChannel` from a given `byte` array
public class ReadableByteChannel {

    # Adding default init function to prevent object getting initialized from the user code.
    isolated function init() {
    }

    # Source bytes from a given input resource.
    # This operation will be asynchronous in which the total number of required bytes might not be returned at a given
    # time. An `io:EofError` will return once the channel reaches the end.
    # ```ballerina
    # byte[]|io:Error result = readableByteChannel.read(1000);
    # ```
    #
    # + nBytes - A positive integer. Represents the number of bytes, which should be read
    # + return - Content (the number of bytes) read, an `EofError` once the channel reaches the end or else an `io:Error`
    public isolated function read(@untainted int nBytes) returns @tainted byte[]|Error {
        return byteReadExtern(self, nBytes);
    }

    # Read all content of the channel as a `byte` array and return a read only `byte` array.
    # ```ballerina
    # byte[]|io:Error result = readableByteChannel.readAll();
    # ```
    #
    # + return - Either a read only `byte` array or else an `io:Error`
    public isolated function readAll() returns @tainted readonly & byte[]|Error {
        byte[] readResult = check readAllBytes(self);
        return <readonly & byte[]>readResult.cloneReadOnly();
    }

    # Return a block stream that can be used to read all `byte` blocks as a stream.
    # ```ballerina
    # stream<io:Block, io:Error>|io:Error result = readableByteChannel.blockStream();
    # ```
    # + blockSize - A positive integer. Size of the block.
    # + return - Either a block stream or else an `io:Error`
    public isolated function blockStream(int blockSize) returns @tainted stream<Block, Error?>|Error {
        BlockStream blockStream = new (self, blockSize);
        return new stream<Block, Error?>(blockStream);
    }

    # Encodes a given `ReadableByteChannel` using the Base64 encoding scheme.
    # ```ballerina
    # io:ReadableByteChannel|Error encodedChannel = readableByteChannel.base64Encode();
    # ```
    #
    # + return - An encoded `ReadableByteChannel` or else an `io:Error`
    public isolated function base64Encode() returns ReadableByteChannel|Error {
        return base64EncodeExtern(self);
    }

    # Decodes a given Base64 encoded `io:ReadableByteChannel`.
    # ```ballerina
    # io:ReadableByteChannel|Error encodedChannel = readableByteChannel.base64Decode();
    # ```
    #
    # + return - A decoded `ReadableByteChannel` or else an `io:Error`
    public isolated function base64Decode() returns ReadableByteChannel|Error {
        return base64DecodeExtern(self);
    }

    # Closes a given `ReadableByteChannel`.
    # After a channel is closed, any further reading operations will cause an error.
    # ```ballerina
    # io:Error? err = readableByteChannel.close();
    # ```
    #
    # + return - Will return `()` if there is no error
    public isolated function close() returns Error? {
        return closeReadableByteChannelExtern(self);
    }
}

isolated function byteReadExtern(ReadableByteChannel byteChannel, @untainted int nBytes) returns @tainted byte[]|Error = @java:Method {
    name: "read",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteChannelUtils"
} external;

isolated function readAllBytes(ReadableByteChannel byteChannel) returns @tainted byte[]|Error = @java:Method {
    name: "readAll",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteChannelUtils"
} external;

isolated function base64EncodeExtern(ReadableByteChannel byteChannel) returns ReadableByteChannel|Error = @java:Method {
    name: "base64Encode",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteChannelUtils"
} external;

isolated function base64DecodeExtern(ReadableByteChannel byteChannel) returns ReadableByteChannel|Error = @java:Method {
    name: "base64Decode",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteChannelUtils"
} external;

isolated function closeReadableByteChannelExtern(ReadableByteChannel byteChannel) returns Error? = @java:Method {
    name: "closeByteChannel",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteChannelUtils"
} external;
