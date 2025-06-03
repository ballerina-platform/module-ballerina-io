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

@test:Config {}
isolated function testReadCharacters() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/utf8file.txt";
    string expectedCharacters = "aaa";
    int numberOfCharacters = 3;

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    string result = check characterChannel.read(numberOfCharacters);
    test:assertEquals(result, expectedCharacters);

    expectedCharacters = "bbǊ";
    result = check characterChannel.read(numberOfCharacters);
    test:assertEquals(result, expectedCharacters);

    expectedCharacters = "";
    result = check characterChannel.read(numberOfCharacters);
    test:assertEquals(result, expectedCharacters);

    check characterChannel.close();
}

@test:Config {}
isolated function testReadAllCharacters() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/fileThatExceeds2MB.txt";
    string result = "";
    int expectedNumberOfChars = 2265223;
    int fixedSize = 500;
    boolean isDone = false;

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);

    while !isDone {
        var readResult = characterChannel.read(fixedSize);
        if readResult is string {
            result = result + readResult;
        } else {
            if readResult is EofError {
                isDone = true;
            } else {
                test:assertFail(readResult.message());
            }
        }
    }
    test:assertEquals(result.length(), expectedNumberOfChars);
    check characterChannel.close();
}

@test:Config {}
isolated function testReadAllCharactersFromEmptyFile() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/emptyFile.txt";
    string result = "";
    int expectedNumberOfCharacters = 0;
    int fixedSize = 500;
    boolean isDone = false;

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);

    while !isDone {
        var readResult = characterChannel.read(fixedSize);
        if readResult is string {
            result = result + readResult;
        } else {
            if readResult is EofError {
                isDone = true;
            } else {
                test:assertFail(readResult.message());
            }
        }
    }
    test:assertEquals(result.length(), expectedNumberOfCharacters);
    check characterChannel.close();
}

@test:Config {}
isolated function testWriteCharacters() returns Error? {
    string filePath = TEMP_DIR + "characterFile.txt";
    string content = "The quick brown fox jumps over the lazy dog";

    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    _ = check characterChannel.write(content, 0);
    check characterChannel.close();
}

@test:Config {dependsOn: [testWriteCharacters]}
isolated function testAppendCharacters() returns Error? {
    string filePath = TEMP_DIR + "appendCharacterFile.txt";
    string initialContent = "Hi, I'm the initial content. ";

    WritableByteChannel byteChannel = check openWritableFile(filePath, APPEND);
    WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    _ = check characterChannel.write(initialContent, 0);
    check characterChannel.close();

    WritableByteChannel byteChannelToAppend = check openWritableFile(filePath, APPEND);
    WritableCharacterChannel characterChannelToAppend = new WritableCharacterChannel(byteChannelToAppend,
    DEFAULT_ENCODING);
    _ = check characterChannelToAppend.write(initialContent, 0);
    _ = check characterChannelToAppend.write(initialContent, 0);
    check characterChannelToAppend.close();
}

@test:Config {}
isolated function testReadAvailableProperty() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";
    string expectedProperty = "John Smith";
    string key = "name";

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    string result = check characterChannel.readProperty(key);
    test:assertEquals(result, expectedProperty);
    check characterChannel.close();
}

@test:Config {}
isolated function testAllProperties() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    _ = check characterChannel.readAllProperties();
    check characterChannel.close();
}

@test:Config {}
isolated function testReadUnavailableProperty() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";
    string defaultValue = "Default";

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    string result = check characterChannel.readProperty("key", defaultValue);
    test:assertEquals(result, defaultValue);
    check characterChannel.close();
}

@test:Config {}
isolated function testWriteProperties() returns Error? {
    string filePath = TEMP_DIR + "/tmp_person.properties";
    map<string> properties = {
        name: "Anna Johnson",
        age: "25",
        occupation: "Banker"
    };
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    check characterChannel.writeProperties(properties, "");
    check characterChannel.close();
}

@test:Config {}
isolated function testFileWriteString() returns Error? {
    string filePath = TEMP_DIR + "stringContent1.txt";
    string content = "The Big Bang Theory";
    check fileWriteString(filePath, content);
}

@test:Config {dependsOn: [testFileWriteString]}
isolated function testFileReadString() returns Error? {
    string filePath = TEMP_DIR + "stringContent1.txt";
    string expectedString = "The Big Bang Theory";
    string result = check fileReadString(filePath);
    test:assertEquals(result, expectedString);
}

@test:Config {}
isolated function testFileWriteStringWithOverwrite() returns Error? {
    string filePath = TEMP_DIR + "stringContent2.txt";
    string content1 =
    "Ballerina is an open source programming language and " + "platform for cloud-era application programmers to easily write software that just works.";
    string content2 = "Ann Johnson is a banker.";

    // Check content 01
    check fileWriteString(filePath, content1);
    string result1 = check fileReadString(filePath);
    test:assertEquals(result1, content1);

    // Check overridden content 02
    check fileWriteString(filePath, content2);

    string result2 = check fileReadString(filePath);
    test:assertEquals(result2, content2);
}

@test:Config {}
isolated function testFileWriteStringWithAppend() returns Error? {
    string filePath = TEMP_DIR + "stringContent3.txt";
    string content1 =
    "Ballerina is an open source programming language and " + "platform for cloud-era application programmers to easily write software that just works.";
    string content2 = "Ann Johnson is a banker.";

    // Check content 01
    check fileWriteString(filePath, content1);

    string result1 = check fileReadString(filePath);
    test:assertEquals(result1, content1);

    // Check content 01 + 02
    check fileWriteString(filePath, content2, APPEND);
    string result2 = check fileReadString(filePath);
    test:assertEquals(result2, (content1 + content2));
}

@test:Config {}
isolated function testFileWriteLines() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines1.txt";
    string[] content = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    check fileWriteLines(filePath, content);
}

@test:Config {dependsOn: [testFileWriteLines]}
isolated function testFileReadLines() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines1.txt";
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] result = check fileReadLines(filePath);
    int i = 0;
    foreach string line in result {
        test:assertEquals(line, expectedLines[i]);
        i += 1;
    }
}

@test:Config {}
isolated function testFileWriteLinesWithOverwrite() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2.txt";
    string[] content1 = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] content2 = ["WSO2", "Google", "Microsoft", "Facebook", "Apple"];

    // Check content 01
    check fileWriteLines(filePath, content1);
    string[] result1 = check fileReadLines(filePath);
    int i = 0;
    foreach string line in result1 {
        test:assertEquals(line, content1[i]);
        i += 1;
    }

    // Check content 02
    check fileWriteLines(filePath, content2);
    string[] result2 = check fileReadLines(filePath);
    i = 0;
    foreach string line in result2 {
        test:assertEquals(line, content2[i]);
        i += 1;
    }
}

@test:Config {}
isolated function testFileWriteLinesWithAppend() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2.txt";
    string[] content1 = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] content2 = ["WSO2", "Google", "Microsoft", "Facebook", "Apple"];
    string[] expectedLines =
    ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST", "WSO2", "Google", "Microsoft", "Facebook", "Apple"];
    // Check content 01
    check fileWriteLines(filePath, content1);
    string[] result1 = check fileReadLines(filePath);
    int i = 0;
    foreach string line in result1 {
        test:assertEquals(line, content1[i]);
        i += 1;
    }

    // Check content 01 + 02
    check fileWriteLines(filePath, content2, APPEND);
    string[] result2 = check fileReadLines(filePath);
    i = 0;
    foreach string line in result2 {
        test:assertEquals(line, expectedLines[i]);
        i += 1;
    }
}

@test:Config {}
isolated function testFileWriteLinesFromStreamUsingIntermediateFile() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_A.txt";
    string resourceFilePath = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    stream<string, Error?> lineStream = check fileReadLinesAsStream(resourceFilePath);
    check fileWriteLinesFromStream(filePath, lineStream);
}

@test:Config {dependsOn: [testFileWriteLinesFromStreamUsingIntermediateFile]}
function testFileReadLinesAsStreamUsingIntermediateFile() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_A.txt";
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    stream<string, Error?> result = check fileReadLinesAsStream(filePath);
    int i = 0;
    check result.forEach(function(string val) {
        test:assertEquals(val, expectedLines[i]);
        i += 1;
    });

    test:assertEquals(i, 4);
}

@test:Config {}
function testFileWriteLinesFromStream() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_B.txt";
    string[] content = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    check fileWriteLinesFromStream(filePath, content.toStream());
}

@test:Config {dependsOn: [testFileWriteLinesFromStream]}
function testFileReadLinesAsStream() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_B.txt";
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    stream<string, Error?> result = check fileReadLinesAsStream(filePath);
    int i = 0;
    check result.forEach(function(string val) {
        test:assertEquals(val, expectedLines[i]);
        i += 1;
    });

    test:assertEquals(i, 4);
}

@test:Config {}
function testFileWriteLinesFromStreamWithOverwriteUsingIntermediateFile() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_A.txt";
    string resourceFilePath1 = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    string resourceFilePath2 = TEST_RESOURCE_PATH + "stringResourceFile2.txt";
    stream<string, Error?> lineStream1 = check fileReadLinesAsStream(resourceFilePath1);
    stream<string, Error?> lineStream2 = check fileReadLinesAsStream(resourceFilePath2);
    string[] content1 = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] content2 = ["WSO2", "Google", "Microsoft", "Facebook", "Apple"];

    // Check content 01
    check fileWriteLinesFromStream(filePath, lineStream1);

    stream<string, Error?> result1 = check fileReadLinesAsStream(filePath);
    int i = 0;
    check result1.forEach(function(string val) {
        test:assertEquals(val, content1[i]);
        i += 1;
    });
    test:assertEquals(i, 4);

    // Check content 02
    check fileWriteLinesFromStream(filePath, lineStream2);

    stream<string, Error?> result2 = check fileReadLinesAsStream(filePath);
    i = 0;
    check result2.forEach(function(string val) {
        test:assertEquals(val, content2[i]);
        i += 1;
    });
    test:assertEquals(i, 5);
}

@test:Config {}
function testFileWriteLinesFromStreamWithAppendUsingIntermediateFile() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_A.txt";
    string resourceFilePath1 = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    string resourceFilePath2 = TEST_RESOURCE_PATH + "stringResourceFile2.txt";
    stream<string, Error?> lineStream1 = check fileReadLinesAsStream(resourceFilePath1);
    stream<string, Error?> lineStream2 = check fileReadLinesAsStream(resourceFilePath2);
    string[] initialContent = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] expectedLines =
    ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST", "WSO2", "Google", "Microsoft", "Facebook", "Apple"];
    // Check content 01
    check fileWriteLinesFromStream(filePath, lineStream1);

    stream<string, Error?> result1 = check fileReadLinesAsStream(filePath);
    int i = 0;
    check result1.forEach(function(string val) {
        test:assertEquals(val, initialContent[i]);
        i += 1;
    });
    test:assertEquals(i, 4);

    // Check content 01 + 02
    check fileWriteLinesFromStream(filePath, lineStream2, APPEND);
    stream<string, Error?> result2 = check fileReadLinesAsStream(filePath);
    i = 0;
    check result2.forEach(function(string val) {
        test:assertEquals(val, expectedLines[i]);
        i += 1;
    });
    test:assertEquals(i, 9);
}

@test:Config {}
function testFileWriteLinesFromStreamWithOverwrite() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_B.txt";
    string[] content1 = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] content2 = ["WSO2", "Google", "Microsoft", "Facebook", "Apple"];

    // Check content 01
    check fileWriteLinesFromStream(filePath, content1.toStream());

    stream<string, Error?> result1 = check fileReadLinesAsStream(filePath);
    int i = 0;
    check result1.forEach(function(string val) {
        test:assertEquals(val, content1[i]);
        i += 1;
    });
    test:assertEquals(i, 4);
    check result1.close();

    // Check content 02
    check fileWriteLinesFromStream(filePath, content2.toStream());
    stream<string, Error?> result2 = check fileReadLinesAsStream(filePath);
    i = 0;
    check result2.forEach(function(string val) {
        test:assertEquals(val, content2[i]);
        i += 1;
    });
    test:assertEquals(i, 5);
    check result2.close();
}

@test:Config {}
function testFileWriteLinesFromStreamWithAppend() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_B.txt";
    string[] content1 = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] content2 = ["WSO2", "Google", "Microsoft", "Facebook", "Apple"];
    string[] expectedLines =
    ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST", "WSO2", "Google", "Microsoft", "Facebook", "Apple"];
    // Check content 01
    check fileWriteLinesFromStream(filePath, content1.toStream());
    stream<string, Error?> result1 = check fileReadLinesAsStream(filePath);
    int i = 0;
    check result1.forEach(function(string val) {
        test:assertEquals(val, content1[i]);
        i += 1;
    });
    test:assertEquals(i, 4);

    // Check content 01 + 02
    check fileWriteLinesFromStream(filePath, content2.toStream(), APPEND);
    stream<string, Error?> result2 = check fileReadLinesAsStream(filePath);
    i = 0;
    check result2.forEach(function(string val) {
        test:assertEquals(val, expectedLines[i]);
        i += 1;
    });
    test:assertEquals(i, 9);
}

@test:Config {dependsOn: [testFileWriteStringWithAppend]}
isolated function testFileChannelWriteStringWithByteChannel() returns Error? {
    string filePath = TEMP_DIR + "stringContent3.txt";
    string content = "The Big Bang Theory";

    WritableByteChannel fileOpenResult = check openWritableFile(filePath);
    check channelWriteString(fileOpenResult, content);
}

@test:Config {dependsOn: [testFileChannelWriteStringWithByteChannel]}
isolated function testFileChannelReadStringWithByteChannel() returns Error? {
    string filePath = TEMP_DIR + "stringContent3.txt";
    string expectedString = "The Big Bang Theory";

    ReadableByteChannel fileOpenResult = check openReadableFile(filePath);
    string result = check channelReadString(fileOpenResult);
    test:assertEquals(result, expectedString);
}

@test:Config {dependsOn: [testFileChannelReadStringWithByteChannel]}
isolated function testFileChannelWriteLinesWithByteChannel() returns Error? {
    string filePath = TEMP_DIR + "stringContent3.txt";
    string content = "The Big Bang Theory";

    WritableByteChannel fileOpenResult = check openWritableFile(filePath);
    check channelWriteString(fileOpenResult, content);
}

@test:Config {dependsOn: [testFileChannelWriteLinesWithByteChannel]}
isolated function testFileChannelReadLinesWithByteChannel() returns Error? {
    string filePath = TEMP_DIR + "stringContent3.txt";
    string expectedString = "The Big Bang Theory";

    ReadableByteChannel fileOpenResult = check openReadableFile(filePath);
    string result = check channelReadString(fileOpenResult);
    test:assertEquals(result, expectedString);
}

@test:Config {}
isolated function testGetReadableCharacterChannel() returns error? {
    string filePath = TEST_RESOURCE_PATH + "empty.txt";
    ReadableByteChannel readableByteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel readableCharacterChannel = new (readableByteChannel, DEFAULT_ENCODING);
    ReadableCSVChannel readableCsvChannel = new (readableCharacterChannel);

    var readableCsvChannel1 = getReadableCharacterChannel(readableByteChannel);
    test:assertTrue(readableCsvChannel1 is ReadableCharacterChannel);

    var readableCsvChannel2 = getReadableCharacterChannel(readableCharacterChannel);
    test:assertTrue(readableCsvChannel2 is ReadableCharacterChannel);

    var err = getReadableCharacterChannel(readableCsvChannel);
    test:assertTrue(err is TypeMismatchError);
}

@test:Config {}
isolated function testGetWritableCharacterChannel() returns error? {
    string filePath = TEST_RESOURCE_PATH + "empty.txt";
    WritableByteChannel writableByteChannel = check openWritableFile(filePath);
    WritableCharacterChannel writableCharacterChannel = new (writableByteChannel, DEFAULT_ENCODING);
    WritableCSVChannel writableCsvChannel = new (writableCharacterChannel);

    var writableCsvChannel1 = getWritableCharacterChannel(writableByteChannel);
    test:assertTrue(writableCsvChannel1 is WritableCharacterChannel);

    var writableCsvChannel2 = getWritableCharacterChannel(writableCharacterChannel);
    test:assertTrue(writableCsvChannel2 is WritableCharacterChannel);

    var err = getWritableCharacterChannel(writableCsvChannel);
    test:assertTrue(err is TypeMismatchError);
}

@test:Config {}
isolated function testReadChar() returns error? {
    StringReader reader = new ("Sheldon Cooper");
    string|Error? content1 = reader.readChar(7);
    string|Error? content2 = reader.readChar(1);
    string|Error? content3 = reader.readChar(6);
    string|Error? content4 = reader.readChar(3);

    test:assertEquals(content1, "Sheldon");
    test:assertEquals(content2, " ");
    test:assertEquals(content3, "Cooper");
    test:assertEquals(content4, "");
}

@test:Config {}
isolated function testCharacterChannelReadAfterClose() returns error? {
    string filePath = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.read(2);
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelReadStringAfterClose() returns error? {
    string filePath = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.readString();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelReadAllLinesAfterClose() returns error? {
    string filePath = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.readAllLines();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelReadJsonAfterClose() returns error? {
    string filePath = TEST_RESOURCE_PATH + "empty.txt";
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.readJson();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelReadXmlAfterClose() returns error? {
    string filePath = TEST_RESOURCE_PATH + "empty.txt";
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.readXml();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelReadPropertyAfterClose() returns error? {
    string filePath = TEST_RESOURCE_PATH + "empty.txt";
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.readProperty("xxx");
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelReadAllPropertiesAfterClose() returns error? {
    string filePath = TEST_RESOURCE_PATH + "empty.txt";
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.readAllProperties();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelWriteAfterClose() returns error? {
    string filePath = TEMP_DIR + "tmpFile.txt";
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.write("", 0);
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelWriteLineAfterClose() returns error? {
    string filePath = TEMP_DIR + "tmpFile.txt";
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.writeLine("");
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelWriteJsonAfterClose() returns error? {
    string filePath = TEMP_DIR + "tmpFile.txt";
    json j = {};
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.writeJson(j);
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelWriteXmlAfterClose() returns error? {
    string filePath = TEMP_DIR + "tmpFile.txt";
    xml x = xml `<book>The Lost World</book>`;
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.writeXml(x);
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelWritePropertiesAfterClose() returns error? {
    string filePath = TEMP_DIR + "tmpFile.txt";
    map<string> properties = {};
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    var err = characterChannel.writeProperties(properties, "");
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testCharacterChannelCloseTwice() returns error? {
    string filePath = TEMP_DIR + "tmpFile.txt";
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    Error? err = characterChannel.close();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

@test:Config {}
isolated function testWritableCharacterChannelCloseTwice() returns error? {
    string filePath = TEMP_DIR + "tmpFile1.txt";
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new (byteChannel, DEFAULT_ENCODING);
    check characterChannel.close();
    Error? err = characterChannel.close();
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "Character channel is already closed.");
}

isolated function isWindowsEnvironment() returns boolean = @java:Method {
    name: "isWindowsEnvironment",
    'class: "io.ballerina.stdlib.io.testutils.EnvironmentTestUtils"
} external;
