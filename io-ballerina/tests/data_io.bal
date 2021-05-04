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
}
