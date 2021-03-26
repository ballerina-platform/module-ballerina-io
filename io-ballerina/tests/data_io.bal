// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/test;

@test:Config {dependsOn: [testTableWithHeader]}
function testWriteFixedSignedInt() {
    int value = 123;
    ByteOrder byteOrder = BIG_ENDIAN;
    string path = TEMP_DIR + "integer.bin";
    var ch = openWritableFile(path);

    if (ch is WritableByteChannel) {
        WritableDataChannel dataChannel = new (ch, byteOrder);
        Error? result = dataChannel.writeInt64(value);
        Error? closeResult = dataChannel.close();
    } else {
        test:assertFail(msg = ch.message());
    }
}

@test:Config {dependsOn: [testWriteFixedSignedInt]}
function testReadFixedSignedInt() {
    int value = 123;
    ByteOrder byteOrder = BIG_ENDIAN;
    string path = TEMP_DIR + "integer.bin";

    var ch = openReadableFile(path);
    if (ch is ReadableByteChannel) {
        ReadableDataChannel dataChannel = new (ch, byteOrder);
        var result = dataChannel.readInt64();
        if (result is int) {
            test:assertEquals(result, value);
        } else {
            test:assertFail(msg = result.message());
        }
        Error? closeResult = dataChannel.close();
    } else {
        test:assertFail(msg = ch.message());
    }
}

@test:Config {dependsOn: [testReadFixedSignedInt]}
function testWriteVarInt() {
    var value = 456;
    ByteOrder byteOrder = BIG_ENDIAN;
    string path = TEMP_DIR + "varint.bin";
    var ch = openWritableFile(path);

    if (ch is WritableByteChannel) {
        WritableDataChannel dataChannel = new (ch, byteOrder);
        Error? result = dataChannel.writeInt64(value);
        Error? closeResult = dataChannel.close();
    } else {
        test:assertFail(msg = ch.message());
    }
}

@test:Config {dependsOn: [testWriteVarInt]}
function testReadVarInt() {
    int value = 456;
    ByteOrder byteOrder = BIG_ENDIAN;
    string path = TEMP_DIR + "varint.bin";

    var ch = openReadableFile(path);
    if (ch is ReadableByteChannel) {
        ReadableDataChannel dataChannel = new (ch, byteOrder);
        var result = dataChannel.readInt64();
        if (result is int) {
            test:assertEquals(result, value);
        } else {
            test:assertFail(msg = result.message());
        }
        Error? closeResult = dataChannel.close();
    } else {
        test:assertFail(msg = ch.message());
    }
}

@test:Config {dependsOn: [testWriteVarInt]}
function testWriteFixedFloat() {
    float value = 1359494.69;
    ByteOrder byteOrder = BIG_ENDIAN;
    string path = TEMP_DIR + "float.bin";
    var ch = openWritableFile(path);

    if (ch is WritableByteChannel) {
        WritableDataChannel dataChannel = new (ch, byteOrder);
        Error? result = dataChannel.writeFloat64(value);
        Error? closeResult = dataChannel.close();
    } else {
        test:assertFail(msg = ch.message());
    }
}

@test:Config {dependsOn: [testWriteFixedFloat]}
function testReadFixedFloat() {
    float value = 1359494.69;
    ByteOrder byteOrder = BIG_ENDIAN;
    string path = TEMP_DIR + "float.bin";
    var ch = openReadableFile(path);

    if (ch is ReadableByteChannel) {
        ReadableDataChannel dataChannel = new (ch, byteOrder);
        var result = dataChannel.readFloat64();
        if (result is float) {
            test:assertEquals(result, value);
        } else {
            test:assertFail(msg = result.message());
        }
        Error? closeResult = dataChannel.close();
    } else {
        test:assertFail(msg = ch.message());
    }
}

@test:Config {dependsOn: [testReadFixedFloat]}
function testWriteBool() {
    boolean value = true;
    ByteOrder byteOrder = BIG_ENDIAN;
    string path = TEMP_DIR + "boolean.bin";
    var ch = openWritableFile(path);

    if (ch is WritableByteChannel) {
        WritableDataChannel dataChannel = new (ch, byteOrder);
        Error? result = dataChannel.writeBool(value);
        Error? closeResult = dataChannel.close();
    } else {
        test:assertFail(msg = ch.message());
    }
}

@test:Config {dependsOn: [testWriteBool]}
function testReadBool() {
    boolean value = true;
    ByteOrder byteOrder = BIG_ENDIAN;
    string path = TEMP_DIR + "boolean.bin";
    var ch = openReadableFile(path);

    if (ch is ReadableByteChannel) {
        ReadableDataChannel dataChannel = new (ch, byteOrder);
        var result = dataChannel.readBool();
        if (result is boolean) {
            test:assertTrue(result);
        } else {
            test:assertFail(msg = result.message());
        }
        Error? closeResult = dataChannel.close();
    } else {
        test:assertFail(msg = ch.message());
    }
}

@test:Config {dependsOn: [testReadBool]}
function testWriteString() {
    string value = "Ballerina";
    ByteOrder byteOrder = BIG_ENDIAN;
    string path = TEMP_DIR + "string.bin";
    string encoding = "UTF-8";
    var ch = openWritableFile(path);

    if (ch is WritableByteChannel) {
        WritableDataChannel dataChannel = new (ch, byteOrder);
        Error? result = dataChannel.writeString(value, encoding);
        Error? closeResult = dataChannel.close();
    } else {
        test:assertFail(msg = ch.message());
    }
}

@test:Config {dependsOn: [testWriteString]}
function testReadString() {
    string value = "Ballerina";
    ByteOrder byteOrder = BIG_ENDIAN;
    string encoding = "UTF-8";
    string path = TEMP_DIR + "string.bin";
    int nBytes = value.toBytes().length();

    var ch = openReadableFile(path);
    if (ch is ReadableByteChannel) {
        ReadableDataChannel dataChannel = new (ch, byteOrder);
        var result = dataChannel.readString(nBytes, encoding);
        if (result is string) {
            test:assertEquals(result, value);
        } else {
            test:assertFail(msg = result.message());
        }
        Error? closeResult = dataChannel.close();
    } else {
        test:assertFail(msg = ch.message());
    }
}
