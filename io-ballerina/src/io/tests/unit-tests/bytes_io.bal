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

import ballerina/java;
import ballerina/test;

ReadableByteChannel? bytesReadCh = ();
WritableByteChannel? bytesWriteCh = ();


@test:Config {}
function testReadBytes() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/6charfile.txt";
    Error? initResult = initReadableBytesChannel(filePath);
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    int numberOfBytesToRead = 3;
    var result = readBytes(numberOfBytesToRead);
    string expectedString = "123";
    if (result is byte[]) {
        test:assertEquals(result, expectedString.toBytes(), msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }

    result = readBytes(numberOfBytesToRead);
    expectedString = "456";
    if (result is byte[]) {
        test:assertEquals(result, expectedString.toBytes(), msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }

    result = readBytes(numberOfBytesToRead);
    expectedString = "";
    if (result is byte[]) {
        test:assertEquals(result, expectedString.toBytes(), msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }
    closeReadableBytesChannel();
}

@test:Config {}
function testWriteBytes() {
    string filePath = TEMP_DIR + "bytesFile1.txt";
    byte[] content = [ 1, 46, 77, 90, 38 ];
    Error? initResult = initWritableBytesChannel(filePath);
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    var result = writeBytes(content, 0);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
    closeWritableBytesChannel();
}

@test:Config {}
function testFileWriteBytes() {
    string filePath = TEMP_DIR + "bytesFile2.txt";
    createDirectoryExtern(TEMP_DIR);
    string content = "Sheldon Cooper";
    var result = fileWriteBytes(filePath, content.toBytes());
    
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {
    dependsOn: ["testFileWriteBytes"]
}
function testFileReadBytes() {
    string filePath = TEMP_DIR + "bytesFile2.txt";
    var result = fileReadBytes(filePath);
    string expectedString = "Sheldon Cooper";
    
    if (result is byte[]) {
        test:assertEquals(result, expectedString.toBytes(), msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }
}

function initReadableBytesChannel(string filePath) returns Error? {
    var result = openReadableFile(filePath);
    if (result is ReadableByteChannel) {
        bytesReadCh = result;
    } else {
        return result;
    }
}

function initWritableBytesChannel(string filePath) {
    bytesWriteCh = <WritableByteChannel> openWritableFile(filePath);
}

function readBytes(int numberOfBytes) returns @tainted byte[]|Error {
    ReadableByteChannel? rChannel = bytesReadCh;
    if (rChannel is ReadableByteChannel) {
        return rChannel.read(numberOfBytes);
    } else {
        GenericError e = GenericError("ReadableByteChannel not initialized");
        return e;
    }
}

function writeBytes(byte[] content, int startOffset) returns int|Error {
    int empty = -1;
    WritableByteChannel? wChannel = bytesWriteCh;
    if (wChannel is WritableByteChannel) {
        var result = wChannel.write(content, startOffset);
        return result;
    } else {
       GenericError e = GenericError("WritableByteChannel not initialized");
       return e;
    }
}

function closeReadableBytesChannel() {
    ReadableByteChannel? rChannel = bytesReadCh;
    if rChannel is ReadableByteChannel {
        var result = rChannel.close();
    }
}

function closeWritableBytesChannel() {
    WritableByteChannel? wChannel = bytesWriteCh;
    if wChannel is WritableByteChannel {
        var result = wChannel.close();
    }
}

function testBase64EncodeByteChannel(ReadableByteChannel contentToBeEncoded) returns ReadableByteChannel|Error {
    return contentToBeEncoded.base64Encode();
}

function testBase64DecodeByteChannel(ReadableByteChannel contentToBeDecoded) returns ReadableByteChannel|Error {
    return contentToBeDecoded.base64Decode();
}

function createDirectoryExtern(string path) = @java:Method {
    name: "createDirectory",
    'class: "org.ballerinalang.stdlib.io.testutils.FileTestUtils"
} external;
