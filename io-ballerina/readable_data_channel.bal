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

# Represents a data channel for reading data.
public class ReadableDataChannel {

    # Initializes the data channel.
    # 
    # + byteChannel - The channel, which would represent the source to read/write data
    # + bOrder - network byte order
    public isolated function init(ReadableByteChannel byteChannel, ByteOrder bOrder = "BE") {
        // Remove temp once this got fixed #19842
        string temp = bOrder;
        initReadableDataChannel(self, byteChannel, temp);
    }

    # Reads a 16 bit integer.
    # ```ballerina
    # int|io:Error result = dataChannel.readInt16();
    # ```
    #
    # + return - The value of the integer, which is read or else an `io:Error` if any error occurred
    public isolated function readInt16() returns int|Error {
        return readInt16Extern(self);
    }

    # Reads a 32 bit integer.
    # ```ballerina
    # int|io:Error result = dataChannel.readInt32();
    # ```
    #
    # + return - The value of the integer, which is read or else an `io:Error` if any error occurred
    public isolated function readInt32() returns int|Error {
        return readInt32Extern(self);
    }

    # Reads a 64 bit integer.
    # ```ballerina
    # int|io:Error result = dataChannel.readInt64();
    # ```
    #
    # + return - The value of the integer, which is read or else an `io:Error` if any error occurred
    public isolated function readInt64() returns int|Error {
        return readInt64Extern(self);
    }

    # Reads a 32 bit float.
    # ```ballerina
    # float|io:Error result = dataChannel.readFloat32();
    # ```
    #
    # + return - The value of the float which is read or else `io:Error` if any error occurred
    public isolated function readFloat32() returns float|Error {
        return readFloat32Extern(self);
    }

    # Reads a 64 bit float.
    # ```ballerina
    # float|io:Error result = dataChannel.readFloat64();
    # ```
    #
    # + return - The value of the float which is read or else `io:Error` if any error occurred
    public isolated function readFloat64() returns float|Error {
        return readFloat64Extern(self);
    }

    # Reads a byte and convert its value to boolean.
    # ```ballerina
    # boolean|io:Error result = dataChannel.readBool();
    # ```
    #
    # + return - boolean value which is read or else `io:Error` if any error occurred
    public isolated function readBool() returns boolean|Error {
        return readBoolExtern(self);
    }

    # Reads the string value represented through the provided number of bytes.
    # ```ballerina
    # string|io:Error string = dataChannel.readString(10, "UTF-8");
    # ```
    #
    # + nBytes - Specifies the number of bytes, which represents the string
    # + encoding - Specifies the char-set encoding of the string
    # + return - The value of the string or else `io:Error` if any error occurred
    public isolated function readString(int nBytes, string encoding) returns string|Error {
        return readStringExtern(self, nBytes, encoding);
    }

    # Reads a variable length integer.
    # ```ballerina
    # int|io:Error result = dataChannel.readVarInt();
    # ```
    #
    # + return - The value of the integer which is read or else `io:Error` if any error occurred
    public isolated function readVarInt() returns int|Error {
        return readVarIntExtern(self);
    }

    # Closes the data channel.
    # After a channel is closed, any further reading operations will cause an error.
    # ```ballerina
    # io:Error? err = dataChannel.close();
    # ```
    # + return - `()` if the channel is closed successfully or else an `io:Error` if any error occurred
    public isolated function close() returns Error? {
        return closeReadableDataChannelExtern(self);
    }
}

isolated function initReadableDataChannel(ReadableDataChannel dataChannel, ReadableByteChannel byteChannel, 
                                          string bOrder) = @java:Method {
    name: "initReadableDataChannel",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.DataChannelUtils"
} external;

isolated function readInt16Extern(ReadableDataChannel dataChannel) returns int|Error = @java:Method {
    name: "readInt16",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.DataChannelUtils"
} external;

isolated function readInt32Extern(ReadableDataChannel dataChannel) returns int|Error = @java:Method {
    name: "readInt32",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.DataChannelUtils"
} external;

isolated function readInt64Extern(ReadableDataChannel dataChannel) returns int|Error = @java:Method {
    name: "readInt64",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.DataChannelUtils"
} external;

isolated function readFloat32Extern(ReadableDataChannel dataChannel) returns float|Error = @java:Method {
    name: "readFloat32",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.DataChannelUtils"
} external;

isolated function readFloat64Extern(ReadableDataChannel dataChannel) returns float|Error = @java:Method {
    name: "readFloat64",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.DataChannelUtils"
} external;

isolated function readBoolExtern(ReadableDataChannel dataChannel) returns boolean|Error = @java:Method {
    name: "readBool",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.DataChannelUtils"
} external;

isolated function readStringExtern(ReadableDataChannel dataChannel, int nBytes, string encoding) returns string|Error = @java:Method {
    name: "readString",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.DataChannelUtils"
} external;

isolated function readVarIntExtern(ReadableDataChannel dataChannel) returns int|Error = @java:Method {
    name: "readVarInt",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.DataChannelUtils"
} external;

isolated function closeReadableDataChannelExtern(ReadableDataChannel dataChannel) returns Error? = @java:Method {
    name: "closeDataChannel",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.DataChannelUtils"
} external;
