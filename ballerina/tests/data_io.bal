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
import ballerina/lang.'float as langfloat;
import ballerina/test;

@test:Config {}
isolated function testReadWriteInt16() returns error? {
    int value = 32767;
    string path = TEMP_DIR + "integer16.bin";
    WritableByteChannel writableByteChannel = check openWritableFile(path);
    WritableDataChannel writableDataChannel = new (writableByteChannel, BIG_ENDIAN);
    check writableDataChannel.writeInt16(value);
    check writableDataChannel.close();

    ReadableByteChannel readableByteChannel = check openReadableFile(path);
    ReadableDataChannel readableDataChannel = new (readableByteChannel, BIG_ENDIAN);
    test:assertEquals(readableDataChannel.readInt16(), value);
    check readableDataChannel.close();
    return;
}

@test:Config {}
isolated function testReadWriteInt32() returns error? {
    int value = 2147483647;
    string path = TEMP_DIR + "integer32.bin";
    WritableByteChannel writableByteChannel = check openWritableFile(path);
    WritableDataChannel writableDataChannel = new (writableByteChannel, BIG_ENDIAN);
    check writableDataChannel.writeInt32(value);
    check writableDataChannel.close();

    ReadableByteChannel readableByteChannel = check openReadableFile(path);
    ReadableDataChannel readableDataChannel = new (readableByteChannel, BIG_ENDIAN);
    test:assertEquals(readableDataChannel.readInt32(), value);
    check readableDataChannel.close();
    return;
}

@test:Config {}
isolated function testReadWriteInt64() returns error? {
    int value = 342147483647;
    string path = TEMP_DIR + "integer64.bin";
    WritableByteChannel writableByteChannel = check openWritableFile(path);
    WritableDataChannel writableDataChannel = new (writableByteChannel, BIG_ENDIAN);
    check writableDataChannel.writeInt64(value);
    check writableDataChannel.close();

    ReadableByteChannel readableByteChannel = check openReadableFile(path);
    ReadableDataChannel readableDataChannel = new (readableByteChannel, BIG_ENDIAN);
    test:assertEquals(readableDataChannel.readInt64(), value);
    check readableDataChannel.close();
    return;
}

@test:Config {}
isolated function testReadWriteVarInt() returns error? {
    var value = 342147483647;
    string path = TEMP_DIR + "varint64.bin";
    WritableByteChannel writableByteChannel = check openWritableFile(path);
    WritableDataChannel writableDataChannel = new (writableByteChannel, BIG_ENDIAN);
    check writableDataChannel.writeVarInt(value);
    check writableDataChannel.close();

    ReadableByteChannel readableByteChannel = check openReadableFile(path);
    ReadableDataChannel readableDataChannel = new (readableByteChannel, BIG_ENDIAN);
    test:assertEquals(readableDataChannel.readVarInt(), value);
    check readableDataChannel.close();
    return;
}

@test:Config {}
isolated function testReadWriteFixedFloat32() returns error? {
    float value = 14.69;
    string path = TEMP_DIR + "float.bin";
    WritableByteChannel writableByteChannel = check openWritableFile(path);
    WritableDataChannel writableDataChannel = new (writableByteChannel, BIG_ENDIAN);
    check writableDataChannel.writeFloat32(value);
    check writableDataChannel.close();

    ReadableByteChannel readableByteChannel = check openReadableFile(path);
    ReadableDataChannel readableDataChannel = new (readableByteChannel, BIG_ENDIAN);
    float f = check readableDataChannel.readFloat32();
    test:assertEquals((langfloat:round(f * 100.0) / 100.0), value);
    check readableDataChannel.close();
    return;
}

@test:Config {}
isolated function testReadWriteFixedFloat64() returns error? {
    float value = 1359494.69;
    string path = TEMP_DIR + "float.bin";
    WritableByteChannel writableByteChannel = check openWritableFile(path);
    WritableDataChannel writableDataChannel = new (writableByteChannel, BIG_ENDIAN);
    check writableDataChannel.writeFloat64(value);
    check writableDataChannel.close();

    ReadableByteChannel readableByteChannel = check openReadableFile(path);
    ReadableDataChannel readableDataChannel = new (readableByteChannel, BIG_ENDIAN);
    test:assertEquals(readableDataChannel.readFloat64(), value);
    check readableDataChannel.close();
    return;
}

@test:Config {}
isolated function testReadWriteBool() returns error? {
    boolean value = true;
    string path = TEMP_DIR + "boolean.bin";
    WritableByteChannel writableByteChannel = check openWritableFile(path);
    WritableDataChannel writableDataChannel = new (writableByteChannel, BIG_ENDIAN);
    check writableDataChannel.writeBool(value);
    check writableDataChannel.close();

    ReadableByteChannel readableByteChannel = check openReadableFile(path);
    ReadableDataChannel readableDataChannel = new (readableByteChannel, BIG_ENDIAN);
    test:assertEquals(readableDataChannel.readBool(), value);
    check readableDataChannel.close();
    return;
}

@test:Config {}
isolated function testReadWriteString() returns error? {
    string value = "Ballerina";
    string path = TEMP_DIR + "string.bin";
    int nBytes = value.toBytes().length();
    WritableByteChannel writableByteChannel = check openWritableFile(path);
    WritableDataChannel writableDataChannel = new (writableByteChannel, BIG_ENDIAN);
    check writableDataChannel.writeString(value, DEFAULT_ENCODING);
    check writableDataChannel.close();

    ReadableByteChannel readableByteChannel = check openReadableFile(path);
    ReadableDataChannel readableDataChannel = new (readableByteChannel, BIG_ENDIAN);
    test:assertEquals(readableDataChannel.readString(nBytes, DEFAULT_ENCODING), value);
    check readableDataChannel.close();
    return;
}

@test:Config {}
isolated function testReadDataAfterClosing() returns Error? {
    int value = 32767;
    string path = TEMP_DIR + "integer16.bin";
    WritableByteChannel writableByteChannel = check openWritableFile(path);
    WritableDataChannel writableDataChannel = new (writableByteChannel, BIG_ENDIAN);
    check writableDataChannel.writeInt16(value);
    check writableDataChannel.close();

    Error? wr1 = writableDataChannel.writeInt16(value);
    if wr1 is Error {
        test:assertEquals(wr1.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    Error? wr2 = writableDataChannel.writeInt32(value);
    if wr2 is Error {
        test:assertEquals(wr2.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    Error? wr3 = writableDataChannel.writeInt64(value);
    if wr3 is Error {
        test:assertEquals(wr3.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    Error? wr4 = writableDataChannel.writeFloat32(2.3);
    if wr4 is Error {
        test:assertEquals(wr4.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    Error? wr5 = writableDataChannel.writeFloat64(2.3);
    if wr5 is Error {
        test:assertEquals(wr5.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    Error? wr6 = writableDataChannel.writeBool(false);
    if wr6 is Error {
        test:assertEquals(wr6.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    Error? wr7 = writableDataChannel.writeString("value", DEFAULT_ENCODING);
    if wr7 is Error {
        test:assertEquals(wr7.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    Error? wr8 = writableDataChannel.writeVarInt(3);
    if wr8 is Error {
        test:assertEquals(wr8.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    ReadableByteChannel readableByteChannel = check openReadableFile(path);
    ReadableDataChannel readableDataChannel = new (readableByteChannel, BIG_ENDIAN);
    test:assertEquals(readableDataChannel.readInt16(), value);
    check readableDataChannel.close();

    int|Error rr1 = readableDataChannel.readInt16();
    if rr1 is Error {
        test:assertEquals(rr1.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    int|Error rr2 = readableDataChannel.readInt32();
    if rr2 is Error {
        test:assertEquals(rr2.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    int|Error rr3 = readableDataChannel.readInt64();
    if rr3 is Error {
        test:assertEquals(rr3.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    float|Error rr4 = readableDataChannel.readFloat32();
    if rr4 is Error {
        test:assertEquals(rr4.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    float|Error rr5 = readableDataChannel.readFloat64();
    if rr5 is Error {
        test:assertEquals(rr5.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    boolean|Error rr6 = readableDataChannel.readBool();
    if rr6 is Error {
        test:assertEquals(rr6.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    string|Error rr7 = readableDataChannel.readString(3, DEFAULT_ENCODING);
    if rr7 is Error {
        test:assertEquals(rr7.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }

    int|Error rr8 = readableDataChannel.readVarInt();
    if rr8 is Error {
        test:assertEquals(rr8.message(), "Data channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }
}


