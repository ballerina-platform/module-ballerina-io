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
import ballerina/jballerina.java;
import ballerina/test;
import ballerina/lang.'string as langstring;

@test:BeforeSuite
isolated function beforeFunc() {
    createDirectoryExtern(TEMP_DIR);
}

@test:Config {}
isolated function testReadBytes() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/charfile.txt";
    string expectedString = "123";
    int numberOfBytes = 3;

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    byte[] result = check byteChannel.read(numberOfBytes);
    test:assertEquals(result, expectedString.toBytes());

    result = check byteChannel.read(numberOfBytes);
    expectedString = "456";
    test:assertEquals(result, expectedString.toBytes());

    result = check byteChannel.read(numberOfBytes);
    expectedString = "";
    test:assertEquals(result, expectedString.toBytes());

    _ = check byteChannel.close();
}

@test:Config {}
isolated function testWriteBytes() returns Error? {
    string filePath = TEMP_DIR + "bytesFile1.txt";
    byte[] content = [1, 46, 77, 90, 38];
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    _ = check byteChannel.write(content, 0);
    _ = check byteChannel.close();
}

@test:Config {}
isolated function testByteChannelInputParams() returns Error? {
    string filePath = TEST_RESOURCE_PATH + "empty.txt";
    ReadableByteChannel readableByteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel readableCharacterChannel = new (readableByteChannel, DEFAULT_ENCODING);
    WritableByteChannel writableByteChannel = check openWritableFile(filePath);
    WritableCharacterChannel writableCharacterChannel = new (writableByteChannel, DEFAULT_ENCODING);

    var e1 = channelReadBytes(readableCharacterChannel);
    test:assertTrue(e1 is Error);

    var e2 = channelReadBlocksAsStream(readableCharacterChannel);
    test:assertTrue(e2 is Error);

    var e3 = channelWriteBytes(writableCharacterChannel, []);
    test:assertTrue(e3 is Error);

    var e4 = channelWriteBlocksFromStream(writableCharacterChannel, [].toStream());
    test:assertTrue(e4 is Error);
}

@test:Config {}
isolated function testFileWriteBytes() returns Error? {
    string filePath = TEMP_DIR + "bytesFile2.txt";
    string content = "Sheldon Cooper";
    check fileWriteBytes(filePath, content.toBytes());
}

@test:Config {dependsOn: [testFileWriteBytes]}
isolated function testFileReadBytes() returns Error? {
    string filePath = TEMP_DIR + "bytesFile2.txt";
    readonly & byte[] result = check fileReadBytes(filePath);
    string expectedString = "Sheldon Cooper";
    test:assertEquals(result, expectedString.toBytes(), msg = "Found unexpected output");
}

@test:Config {}
isolated function testFileWriteBytesFromStreamUsingIntermediateFile() returns Error? {
    string filePath = TEMP_DIR + "bytesFile3_A.txt";
    string resourceFilePath = TEMP_DIR + "bytesResourceFile.txt";
    string content = "Sheldon Cooper";

    check fileWriteString(resourceFilePath, content);
    stream<Block, Error?> bytesStream = check fileReadBlocksAsStream(resourceFilePath, 2);
    check fileWriteBlocksFromStream(filePath, bytesStream);
}

@test:Config {dependsOn: [testFileWriteBytesFromStreamUsingIntermediateFile]}
function testFileReadBytesAsStreamUsingIntermediateFile() returns Error? {
    string filePath = TEMP_DIR + "bytesFile3_A.txt";
    stream<Block, Error?> result = check fileReadBlocksAsStream(filePath, 2);
    string expectedString = "Sheldon Cooper";
    byte[] byteArr = [];
    check result.forEach(function(Block val) {
        foreach byte b in val {
            byteArr.push(b);
        }
    });
    string|error returnedString = langstring:fromBytes(byteArr);
    if returnedString is string {
        test:assertEquals(returnedString, expectedString);
    } else {
        test:assertFail(msg = returnedString.message());
    }
    test:assertEquals(returnedString, expectedString);
}

@test:Config {}
function testFileWriteBytesFromStream() returns Error? {
    string filePath = TEMP_DIR + "bytesFile3_B.txt";
    string[] stringContent = ["Sheldon", " ", "Cooper"];
    byte[][] byteContent = [];
    int i = 0;
    foreach string s in stringContent {
        byteContent[i] = s.toBytes();
        i += 1;
    }
    check fileWriteBlocksFromStream(filePath, byteContent.toStream());
}

@test:Config {dependsOn: [testFileWriteBytesFromStream]}
function testFileReadBytesAsStream() returns Error? {
    string filePath = TEMP_DIR + "bytesFile3_B.txt";
    stream<Block, Error?> result = check fileReadBlocksAsStream(filePath, 2);
    string expectedString = "Sheldon Cooper";
    byte[] byteArr = [];
    check result.forEach(function(Block val) {
        foreach byte b in val {
            byteArr.push(b);
        }
    });

    string|error returnedString = langstring:fromBytes(byteArr);
    if returnedString is string {
        test:assertEquals(returnedString, expectedString);
    } else {
        test:assertFail(msg = returnedString.message());
    }
    test:assertEquals(returnedString, expectedString);
}

@test:Config {}
isolated function testFileChannelWriteBytes() returns Error? {
    string filePath = TEMP_DIR + "bytesFile4.txt";
    string content = "Sheldon Cooper";

    WritableByteChannel fileOpenResult = check openWritableFile(filePath);
    check channelWriteBytes(fileOpenResult, content.toBytes());
}

@test:Config {dependsOn: [testFileChannelWriteBytes]}
isolated function testFileChannelReadBytes() returns Error? {
    string filePath = TEMP_DIR + "bytesFile4.txt";
    string expectedString = "Sheldon Cooper";

    ReadableByteChannel fileOpenResult = check openReadableFile(filePath);
    byte[] result = check channelReadBytes(fileOpenResult);
    test:assertEquals(result, expectedString.toBytes());
}

@test:Config {}
isolated function testFileChannelWriteBytesFromStream() returns Error? {
    string filePath = TEMP_DIR + "bytesFile5.txt";
    string resourceFilePath = TEMP_DIR + "bytesResourceFile.txt";
    string content = "Sheldon Cooper";

    check fileWriteString(resourceFilePath, content);
    stream<Block, Error?> bytesStream = check fileReadBlocksAsStream(resourceFilePath, 2);
    WritableByteChannel fileOpenResult = check openWritableFile(filePath);
    check channelWriteBlocksFromStream(fileOpenResult, bytesStream);
}

@test:Config {dependsOn: [testFileChannelWriteBytesFromStream]}
function testFileChannelReadBytesAsStream() returns Error? {
    string filePath = TEMP_DIR + "bytesFile5.txt";
    string expectedString = "Sheldon Cooper";
    byte[] byteArr = [];

    ReadableByteChannel fileOpenResult = check openReadableFile(filePath);
    stream<Block, Error?> result = check channelReadBlocksAsStream(fileOpenResult, 2);
    check result.forEach(function(Block val) {
        foreach byte b in val {
            byteArr.push(b);
        }
    });
    string|error returnedString = langstring:fromBytes(byteArr);
    if returnedString is string {
        test:assertEquals(returnedString, expectedString);
    } else {
        test:assertFail(returnedString.message());
    }
}

@test:Config {}
isolated function testFileCopy() returns Error? {
    string readFilePath = RESOURCES_BASE_PATH + "datafiles/io/images/ballerina.png";
    string writeFilePath = TEMP_DIR + "ballerina.png";
    readonly & byte[] readResult = check fileReadBytes(readFilePath);
    check fileWriteBytes(writeFilePath, readResult);
}

@test:Config {}
isolated function testFileWriteBytesWithOverwrite() returns Error? {
    string filePath = TEMP_DIR + "bytesFile6.txt";
    string content1 =
    "Ballerina is an open source programming language and " + "platform for cloud-era application programmers to easily write software that just works.";
    string content2 = "Ann Johnson is a banker.";

    // Check content 01
    check fileWriteBytes(filePath, content1.toBytes());
    readonly & byte[] result1 = check fileReadBytes(filePath);
    test:assertEquals(result1, content1.toBytes());

    // Check content 02
    check fileWriteBytes(filePath, content2.toBytes());
    readonly & byte[] result2 = check fileReadBytes(filePath);
    test:assertEquals(result2, content2.toBytes());
}

@test:Config {}
isolated function testFileWriteBytesWithAppend() returns Error? {
    string filePath = TEMP_DIR + "bytesFile7.txt";
    string content1 =
    "Ballerina is an open source programming language and " + "platform for cloud-era application programmers to easily write software that just works. ";
    string content2 = "Ann Johnson is a banker.";

    // Check content 01
    check fileWriteBytes(filePath, content1.toBytes());
    readonly & byte[] result1 = check fileReadBytes(filePath);
    test:assertEquals(result1, content1.toBytes());

    // Check content 01 + 02
    check fileWriteBytes(filePath, content2.toBytes(), APPEND);
    readonly & byte[] result2 = check fileReadBytes(filePath);
    test:assertEquals(result2, (content1 + content2).toBytes());
}

@test:Config {}
function testFileWriteBytesFromStreamWithOverrideUsingIntermediateFile() returns Error? {
    string filePath = TEMP_DIR + "bytesFile8.txt";
    string resourceFilePath1 = TEMP_DIR + "bytesResourceFile1.txt";
    string resourceFilePath2 = TEMP_DIR + "bytesResourceFile2.txt";
    string content1 = "Ballerina is an ";
    string content2 = "open source programming language";
    check fileWriteString(resourceFilePath1, content1);
    check fileWriteString(resourceFilePath2, content2);
    stream<Block, Error?> bytesStream1 = check fileReadBlocksAsStream(resourceFilePath1, 2);
    stream<Block, Error?> bytesStream2 = check fileReadBlocksAsStream(resourceFilePath2, 2);

    // Check content 01
    check fileWriteBlocksFromStream(filePath, bytesStream1);

    stream<Block, Error?> result1 = check fileReadBlocksAsStream(filePath, 2);
    byte[] byteArr1 = [];
    check result1.forEach(function(Block val) {
        foreach byte b in val {
            byteArr1.push(b);
        }
    });
    string|error returnedString1 = langstring:fromBytes(byteArr1);
    if returnedString1 is string {
        test:assertEquals(returnedString1, content1);
    } else {
        test:assertFail(returnedString1.message());
    }

    // Check content 02
    check fileWriteBlocksFromStream(filePath, bytesStream2);
    stream<Block, Error?> result2 = check fileReadBlocksAsStream(filePath, 2);
    byte[] byteArr2 = [];
    check result2.forEach(function(Block val) {
        foreach byte b in val {
            byteArr2.push(b);
        }
    });
    string|error returnedString2 = langstring:fromBytes(byteArr2);
    if returnedString2 is string {
        test:assertEquals(returnedString2, content2);
    } else {
        test:assertFail(returnedString2.message());
    }
}

@test:Config {}
function testFileWriteBytesFromStreamWithAppendUsingIntermediateFile() returns Error? {
    string filePath = TEMP_DIR + "bytesFile8.txt";
    string resourceFilePath1 = TEMP_DIR + "bytesResourceFile3.txt";
    string resourceFilePath2 = TEMP_DIR + "bytesResourceFile4.txt";
    string content1 = "Ballerina is an ";
    string content2 = "open source programming language";
    check fileWriteString(resourceFilePath1, content1);
    check fileWriteString(resourceFilePath2, content2);
    stream<Block, Error?> bytesStream1 = check fileReadBlocksAsStream(resourceFilePath1, 2);
    stream<Block, Error?> bytesStream2 = check fileReadBlocksAsStream(resourceFilePath2, 2);

    // Check content 01
    check fileWriteBlocksFromStream(filePath, bytesStream1);
    stream<Block, Error?> result1 = check fileReadBlocksAsStream(filePath, 2);
    byte[] byteArr1 = [];
    check result1.forEach(function(Block val) {
        foreach byte b in val {
            byteArr1.push(b);
        }
    });
    string|error returnedString1 = langstring:fromBytes(byteArr1);
    if returnedString1 is string {
        test:assertEquals(returnedString1, content1);
    } else {
        test:assertFail(returnedString1.message());
    }

    // Check content 01 + 02
    check fileWriteBlocksFromStream(filePath, bytesStream2, APPEND);
    stream<Block, Error?> result2 = check fileReadBlocksAsStream(filePath, 2);
    byte[] byteArr2 = [];
    check result2.forEach(function(Block val) {
        foreach byte b in val {
            byteArr2.push(b);
        }
    });
    string|error returnedString2 = langstring:fromBytes(byteArr2);
    if returnedString2 is string {
        test:assertEquals(returnedString2, (content1 + content2));
    } else {
        test:assertFail(returnedString2.message());
    }
}

@test:Config {}
function testFileWriteBytesFromStreamWithOverride() returns Error? {
    string filePath = TEMP_DIR + "bytesFile9.txt";
    string[] content1 = ["Ballerina ", "is ", "an "];
    string[] content2 = ["open ", "source ", "programming ", "language"];
    string expectedContent1 = "Ballerina is an ";
    string expectedContent2 = "open source programming language";
    byte[][] byteContent1 = [];
    byte[][] byteContent2 = [];
    int i = 0;
    foreach string s in content1 {
        byteContent1[i] = s.toBytes();
        i += 1;
    }
    i = 0;
    foreach string s in content2 {
        byteContent2[i] = s.toBytes();
        i += 1;
    }
    // Check content 01
    check fileWriteBlocksFromStream(filePath, byteContent1.toStream());
    stream<Block, Error?> result1 = check fileReadBlocksAsStream(filePath, 2);
    byte[] byteArr1 = [];
    check result1.forEach(function(Block val) {
        foreach byte b in val {
            byteArr1.push(b);
        }
    });
    string|error returnedString1 = langstring:fromBytes(byteArr1);
    if returnedString1 is string {
        test:assertEquals(returnedString1, expectedContent1);
    } else {
        test:assertFail(returnedString1.message());
    }
    check result1.close();

    // Check content 02
    check fileWriteBlocksFromStream(filePath, byteContent2.toStream());
    stream<Block, Error?> result2 = check fileReadBlocksAsStream(filePath, 2);
    byte[] byteArr2 = [];
    check result2.forEach(function(Block val) {
        foreach byte b in val {
            byteArr2.push(b);
        }
    });
    string|error returnedString = langstring:fromBytes(byteArr2);
    if returnedString is string {
        test:assertEquals(returnedString, expectedContent2);
    } else {
        test:assertFail(msg = returnedString.message());
    }
    check result2.close();
}

@test:Config {}
function testFileWriteBytesFromStreamWithAppend() returns Error? {
    string filePath = TEMP_DIR + "bytesFile9.txt";
    string[] content1 = ["Ballerina ", "is ", "an "];
    string[] content2 = ["open ", "source ", "programming ", "language"];
    string expectedContent1 = "Ballerina is an ";
    string expectedContent2 = "Ballerina is an open source programming language";
    byte[][] byteContent1 = [];
    byte[][] byteContent2 = [];
    int i = 0;
    foreach string s in content1 {
        byteContent1[i] = s.toBytes();
        i += 1;
    }
    i = 0;
    foreach string s in content2 {
        byteContent2[i] = s.toBytes();
        i += 1;
    }
    // Check content 01
    check fileWriteBlocksFromStream(filePath, byteContent1.toStream());
    stream<Block, Error?> result1 = check fileReadBlocksAsStream(filePath, 2);
    byte[] byteArr1 = [];
    check result1.forEach(function(Block val) {
        foreach byte b in val {
            byteArr1.push(b);
        }
    });
    string|error returnedString1 = langstring:fromBytes(byteArr1);
    if returnedString1 is string {
        test:assertEquals(returnedString1, expectedContent1);
    } else {
        test:assertFail(msg = returnedString1.message());
    }

    // Check content 01 + 02
    check fileWriteBlocksFromStream(filePath, byteContent2.toStream(), APPEND);
    stream<Block, Error?> result2 = check fileReadBlocksAsStream(filePath, 2);
    byte[] byteArr2 = [];
    check result2.forEach(function(Block val) {
        foreach byte b in val {
            byteArr2.push(b);
        }
    });
    string|error returnedString = langstring:fromBytes(byteArr2);
    if returnedString is string {
        test:assertEquals(returnedString, expectedContent2);
    } else {
        test:assertFail(msg = returnedString.message());
    }
}

@test:Config {}
isolated function testBase64EncodeAndDecode() returns Error? {
    string filePath = TEMP_DIR + "bytesFile10.txt";
    string expectedString = "Ballerina is an open source programming language.";

    check fileWriteString(filePath, expectedString);
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableByteChannel encodedByteChannel = check byteChannel.base64Encode();
    ReadableByteChannel decodedByteChannel = check encodedByteChannel.base64Decode();
    test:assertEquals(langstring:fromBytes(check decodedByteChannel.readAll()), expectedString);
}

@test:Config {}
isolated function testByteChannelReadAfterClose() returns Error? {
    string filePath = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    ReadableByteChannel readableByteChannel = check openReadableFile(filePath);
    check readableByteChannel.close();
    var err = readableByteChannel.read(2);
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Byte channel is already closed.");
}

@test:Config {}
isolated function testByteChannelReadAllAfterClose() returns Error? {
    string filePath = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    ReadableByteChannel readableByteChannel = check openReadableFile(filePath);
    check readableByteChannel.close();
    var err = readableByteChannel.readAll();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Byte channel is already closed.");
}

@test:Config {}
isolated function testByteChannelBase64EncodeAfterClose() returns error? {
    string filePath = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    ReadableByteChannel readableByteChannel = check openReadableFile(filePath);
    check readableByteChannel.close();
    var err = readableByteChannel.base64Encode();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Channel is already closed.");
}

@test:Config {}
isolated function testByteChannelBase64DecodeAfterClose() returns error? {
    string filePath = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    ReadableByteChannel readableByteChannel = check openReadableFile(filePath);
    check readableByteChannel.close();
    var err = readableByteChannel.base64Decode();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Channel is already closed.");
}

@test:Config {}
isolated function testByteChannelWriteAfterClose() returns error? {
    string filePath = TEMP_DIR + "temp.txt";
    WritableByteChannel writableByteChannel = check openWritableFile(filePath);
    check writableByteChannel.close();
    var err = writableByteChannel.write([], 0);
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Byte channel is already closed.");
}

@test:Config {}
isolated function testReadableByteChannelCloseTwice() returns error? {
    string filePath = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    ReadableByteChannel readableByteChannel = check openReadableFile(filePath);
    check readableByteChannel.close();
    Error? err = readableByteChannel.close();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Byte channel is already closed.");
}

@test:Config {}
isolated function testWritableByteChannelCloseTwice() returns error? {
    string filePath = TEMP_DIR + "temp1.txt";
    WritableByteChannel writableByteChannel = check openWritableFile(filePath);
    check writableByteChannel.close();
    Error? err = writableByteChannel.close();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Byte channel is already closed.");
}

isolated function createDirectoryExtern(string path) = @java:Method {
    name: "createDirectory",
    'class: "io.ballerina.stdlib.io.testutils.FileTestUtils"
} external;
