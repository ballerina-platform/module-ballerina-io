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
isolated function testReadCharacters() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/utf8file.txt";
    string expectedCharacters = "aaa";
    int numberOfCharacters = 3;

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.read(numberOfCharacters);
        if (result is string) {
            test:assertEquals(result, expectedCharacters, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        expectedCharacters = "bbǊ";
        result = characterChannel.read(numberOfCharacters);
        if (result is string) {
            test:assertEquals(result, expectedCharacters, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        expectedCharacters = "";
        result = characterChannel.read(numberOfCharacters);
        if (result is string) {
            test:assertEquals(result, expectedCharacters, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
isolated function testReadAllCharacters() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/fileThatExceeds2MB.txt";
    string result = "";
    int expectedNumberOfCharsInWindows = 2297329;
    int expectedNumberOfCharsInLinux = 2265223;
    int fixedSize = 500;
    boolean isDone = false;

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);

        while (!isDone) {
            var readResult = characterChannel.read(fixedSize);
            if (readResult is string) {
                result = result + readResult;
            } else {
                error e = readResult;
                if (e is EofError) {
                    isDone = true;
                } else {
                    test:assertFail(msg = e.message());
                }
            }
        }
        if (isWindowsEnvironment()) {
            test:assertEquals(result.length(), expectedNumberOfCharsInWindows);
        } else {
            test:assertEquals(result.length(), expectedNumberOfCharsInLinux);
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
isolated function testReadAllCharactersFromEmptyFile() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/emptyFile.txt";
    string result = "";
    int expectedNumberOfCharacters = 0;
    int fixedSize = 500;
    boolean isDone = false;

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);

        while (!isDone) {
            var readResult = characterChannel.read(fixedSize);
            if (readResult is string) {
                result = result + readResult;
            } else {
                error e = readResult;
                if (e is EofError) {
                    isDone = true;
                } else {
                    test:assertFail(msg = e.message());
                }
            }
        }
        test:assertEquals(result.length(), expectedNumberOfCharacters);

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
isolated function testWriteCharacters() {
    string filePath = TEMP_DIR + "characterFile.txt";
    string content = "The quick brown fox jumps over the lazy dog";

    var byteChannel = openWritableFile(filePath);
    if (byteChannel is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.write(content, 0);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testWriteCharacters]}
isolated function testAppendCharacters() {
    string filePath = TEMP_DIR + "appendCharacterFile.txt";
    string initialContent = "Hi, I'm the initial content. ";
    string appendingContent = "Hi, I was appended later. ";

    var byteChannel = openWritableFile(filePath, APPEND);
    if (byteChannel is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.write(initialContent, 0);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }

    var byteChannelToAppend = openWritableFile(filePath, APPEND);
    if (byteChannelToAppend is WritableByteChannel) {
        WritableCharacterChannel characterChannelToAppend = new WritableCharacterChannel(byteChannelToAppend, 
        DEFAULT_ENCODING);
        var result = characterChannelToAppend.write(initialContent, 0);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        result = characterChannelToAppend.write(initialContent, 0);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannelToAppend.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannelToAppend.message());
    }
}

@test:Config {}
isolated function testReadAvailableProperty() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";
    string expectedProperty = "John Smith";
    string key = "name";

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.readProperty(key);
        if (result is json) {
            test:assertEquals(result, expectedProperty, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
isolated function testAllProperties() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.readAllProperties();
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
isolated function testReadUnavailableProperty() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";
    string defaultValue = "Default";

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.readProperty("key", defaultValue);
        if (result is json) {
            test:assertEquals(result, defaultValue, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
isolated function testWriteProperties() {
    string filePath = TEMP_DIR + "/tmp_person.properties";
    map<string> properties = {
        name: "Anna Johnson",
        age: "25",
        occupation: "Banker"
    };
    var byteChannel = openWritableFile(filePath);
    if (byteChannel is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.writeProperties(properties, "");
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
isolated function testFileWriteString() {
    string filePath = TEMP_DIR + "stringContent1.txt";
    string content = "The Big Bang Theory";
    var result = fileWriteString(filePath, content);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileWriteString]}
isolated function testFileReadString() {
    string filePath = TEMP_DIR + "stringContent1.txt";
    string expectedString = "The Big Bang Theory";
    var result = fileReadString(filePath);
    if (result is string) {
        test:assertEquals(result, expectedString);
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
isolated function testFileWriteStringWithOverwrite() {
    string filePath = TEMP_DIR + "stringContent2.txt";
    string content1 = "Ballerina is an open source programming language and " +
    "platform for cloud-era application programmers to easily write software that just works.";
    string content2 = "Ann Johnson is a banker.";

    // Check content 01
    var result1 = fileWriteString(filePath, content1);
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadString(filePath);
    if (result2 is string) {
        test:assertEquals(result2, content1);
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check overridden content 02
    var result3 = fileWriteString(filePath, content2);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadString(filePath);
    if (result4 is string) {
        test:assertEquals(result4, content2);
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
isolated function testFileWriteStringWithAppend() {
    string filePath = TEMP_DIR + "stringContent3.txt";
    string content1 = "Ballerina is an open source programming language and " +
    "platform for cloud-era application programmers to easily write software that just works.";
    string content2 = "Ann Johnson is a banker.";

    // Check content 01
    var result1 = fileWriteString(filePath, content1);
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadString(filePath);
    if (result2 is string) {
        test:assertEquals(result2, content1);
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 01 + 02
    var result3 = fileWriteString(filePath, content2, APPEND);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadString(filePath);
    if (result4 is string) {
        test:assertEquals(result4, (content1+content2));
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
isolated function testFileWriteLines() {
    string filePath = TEMP_DIR + "stringContentAsLines1.txt";
    string[] content = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    var result = fileWriteLines(filePath, content);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileWriteLines]}
isolated function testFileReadLines() {
    string filePath = TEMP_DIR + "stringContentAsLines1.txt";
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    var result = fileReadLines(filePath);
    if (result is string[]) {
        int i = 0;
        foreach string line in result {
            test:assertEquals(line, expectedLines[i]);
            i += 1;
        }
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
isolated function testFileWriteLinesWithOverwrite() {
    string filePath = TEMP_DIR + "stringContentAsLines2.txt";
    string[] content1 = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] content2 = ["WSO2", "Google", "Microsoft", "Facebook", "Apple"];

    // Check content 01
    var result1 = fileWriteLines(filePath, content1);
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadLines(filePath);
    if (result2 is string[]) {
        int i = 0;
        foreach string line in result2 {
            test:assertEquals(line, content1[i]);
            i += 1;
        }
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 02
    var result3 = fileWriteLines(filePath, content2);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadLines(filePath);
    if (result4 is string[]) {
        int i = 0;
        foreach string line in result4 {
            test:assertEquals(line, content2[i]);
            i += 1;
        }
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
isolated function testFileWriteLinesWithAppend() {
    string filePath = TEMP_DIR + "stringContentAsLines2.txt";
    string[] content1 = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] content2 = ["WSO2", "Google", "Microsoft", "Facebook", "Apple"];
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST",
                                "WSO2", "Google", "Microsoft", "Facebook", "Apple"];
    // Check content 01
    var result1 = fileWriteLines(filePath, content1);
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadLines(filePath);
    if (result2 is string[]) {
        int i = 0;
        foreach string line in result2 {
            test:assertEquals(line, content1[i]);
            i += 1;
        }
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 01 + 02
    var result3 = fileWriteLines(filePath, content2, APPEND);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadLines(filePath);
    if (result4 is string[]) {
        int i = 0;
        foreach string line in result4 {
            test:assertEquals(line, expectedLines[i]);
            i += 1;
        }
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
isolated function testFileWriteLinesFromStreamUsingIntermediateFile() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_A.txt";
    string resourceFilePath = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    stream<string, Error?> lineStream = check fileReadLinesAsStream(resourceFilePath);

    var result = fileWriteLinesFromStream(filePath, lineStream);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileWriteLinesFromStreamUsingIntermediateFile]}
function testFileReadLinesAsStreamUsingIntermediateFile() {
    string filePath = TEMP_DIR + "stringContentAsLines2_A.txt";
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    var result = fileReadLinesAsStream(filePath);
    if (result is stream<string, error?>) {
        int i = 0;
        error? e = result.forEach(function(string val) {
                               test:assertEquals(val, expectedLines[i]);
                               i += 1;
                           });

        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 4);
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
function testFileWriteLinesFromStream() {
    string filePath = TEMP_DIR + "stringContentAsLines2_B.txt";
    string[] content = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    var result = fileWriteLinesFromStream(filePath, content.toStream());
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileWriteLinesFromStream]}
function testFileReadLinesAsStream() {
    string filePath = TEMP_DIR + "stringContentAsLines2_B.txt";
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    var result = fileReadLinesAsStream(filePath);
    if (result is stream<string, Error?>) {
        int i = 0;
        error? e = result.forEach(function(string val) {
                               test:assertEquals(val, expectedLines[i]);
                               i += 1;
                           });

        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 4);
    } else {
        test:assertFail(msg = result.message());
    }
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
    var result1 = fileWriteLinesFromStream(filePath, lineStream1);
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadLinesAsStream(filePath);
    if (result2 is stream<string, Error?>) {
        int i = 0;
        error? e = result2.forEach(function(string val) {
                               test:assertEquals(val, content1[i]);
                               i += 1;
                           });

        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 4);
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 02
    var result3 = fileWriteLinesFromStream(filePath, lineStream2);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadLinesAsStream(filePath);
    if (result4 is stream<string, Error?>) {
        int i = 0;
        error? e = result4.forEach(function(string val) {
                               test:assertEquals(val, content2[i]);
                               i += 1;
                           });

        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 5);
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
function testFileWriteLinesFromStreamWithAppendUsingIntermediateFile() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_A.txt";
    string resourceFilePath1 = TEST_RESOURCE_PATH + "stringResourceFile1.txt";
    string resourceFilePath2 = TEST_RESOURCE_PATH + "stringResourceFile2.txt";
    stream<string, Error?> lineStream1 = check fileReadLinesAsStream(resourceFilePath1);
    stream<string, Error?> lineStream2 = check fileReadLinesAsStream(resourceFilePath2);
    string[] initialContent = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST",
                                "WSO2", "Google", "Microsoft", "Facebook", "Apple"];
    // Check content 01
    var result1 = fileWriteLinesFromStream(filePath, lineStream1);
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadLinesAsStream(filePath);
    if (result2 is stream<string, Error?>) {
        int i = 0;
        error? e = result2.forEach(function(string val) {
                               test:assertEquals(val, initialContent[i]);
                               i += 1;
                           });

        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 4);
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 01 + 02
    var result3 = fileWriteLinesFromStream(filePath, lineStream2, APPEND);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadLinesAsStream(filePath);
    if (result4 is stream<string, Error?>) {
        int i = 0;
        error? e = result4.forEach(function(string val) {
                               test:assertEquals(val, expectedLines[i]);
                               i += 1;
                           });

        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 9);
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
function testFileWriteLinesFromStreamWithOverwrite() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines2_B.txt";
    string[] content1 = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] content2 = ["WSO2", "Google", "Microsoft", "Facebook", "Apple"];

    // Check content 01
    var result1 = fileWriteLinesFromStream(filePath, content1.toStream());
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadLinesAsStream(filePath);
    if (result2 is stream<string, error?>) {
        int i = 0;
        error? e = result2.forEach(function(string val) {
                               test:assertEquals(val, content1[i]);
                               i += 1;
                           });

        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 4);
        check result2.close();
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 02
    var result3 = fileWriteLinesFromStream(filePath, content2.toStream());
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadLinesAsStream(filePath);
    if (result4 is stream<string, error?>) {
        int i = 0;
        error? e = result4.forEach(function(string val) {
                               test:assertEquals(val, content2[i]);
                               i += 1;
                           });

        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 5);
        check result4.close();
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
function testFileWriteLinesFromStreamWithAppend() {
    string filePath = TEMP_DIR + "stringContentAsLines2_B.txt";
    string[] content1 = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    string[] content2 = ["WSO2", "Google", "Microsoft", "Facebook", "Apple"];
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST",
                                "WSO2", "Google", "Microsoft", "Facebook", "Apple"];
    // Check content 01
    var result1 = fileWriteLinesFromStream(filePath, content1.toStream());
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadLinesAsStream(filePath);
    if (result2 is stream<string, error?>) {
        int i = 0;
        error? e = result2.forEach(function(string val) {
                               test:assertEquals(val, content1[i]);
                               i += 1;
                           });

        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 4);
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 01 + 02
    var result3 = fileWriteLinesFromStream(filePath, content2.toStream(), APPEND);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadLinesAsStream(filePath);
    if (result4 is stream<string, error?>) {
        int i = 0;
        error? e = result4.forEach(function(string val) {
                               test:assertEquals(val, expectedLines[i]);
                               i += 1;
                           });

        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 9);
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
isolated function testFileChannelWriteStringWithByteChannel() {
    string filePath = TEMP_DIR + "stringContent3.txt";
    string content = "The Big Bang Theory";

    var fileOpenResult = openWritableFile(filePath);
    if (fileOpenResult is WritableByteChannel) {
        var result = channelWriteString(fileOpenResult, content);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }
    } else {
        test:assertFail(msg = fileOpenResult.message());
    }
}

@test:Config {dependsOn: [testFileChannelWriteStringWithByteChannel]}
isolated function testFileChannelReadStringWithByteChannel() {
    string filePath = TEMP_DIR + "stringContent3.txt";
    string expectedString = "The Big Bang Theory";

    var fileOpenResult = openReadableFile(filePath);
    if (fileOpenResult is ReadableByteChannel) {
        var result = channelReadString(fileOpenResult);
        if (result is string) {
            test:assertEquals(result, expectedString, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }
    } else {
        test:assertFail(msg = fileOpenResult.message());
    }
}

@test:Config {}
isolated function testFileChannelWriteLinesWithByteChannel() {
    string filePath = TEMP_DIR + "stringContent3.txt";
    string content = "The Big Bang Theory";

    var fileOpenResult = openWritableFile(filePath);
    if (fileOpenResult is WritableByteChannel) {
        var result = channelWriteString(fileOpenResult, content);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }
    } else {
        test:assertFail(msg = fileOpenResult.message());
    }
}

@test:Config {dependsOn: [testFileChannelWriteLinesWithByteChannel]}
isolated function testFileChannelReadLinesWithByteChannel() {
    string filePath = TEMP_DIR + "stringContent3.txt";
    string expectedString = "The Big Bang Theory";

    var fileOpenResult = openReadableFile(filePath);
    if (fileOpenResult is ReadableByteChannel) {
        var result = channelReadString(fileOpenResult);
        if (result is string) {
            test:assertEquals(result, expectedString, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }
    } else {
        test:assertFail(msg = fileOpenResult.message());
    }
}

@test:Config {}
isolated function testGetReadableCharacterChannel() returns error? {
    string filePath = TEST_RESOURCE_PATH + "empty.txt";
    ReadableByteChannel readableByteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel readableCharacterChannel = new(readableByteChannel, DEFAULT_ENCODING);
    ReadableCSVChannel readableCsvChannel = new(readableCharacterChannel);

    var readableCsvChannel1 = getReadableCharacterChannel(readableByteChannel);
    if !(readableCsvChannel1 is ReadableCharacterChannel) {
        test:assertFail(msg = "Expected ReadableCharacterChannel not found");
    }
    var readableCsvChannel2 = getReadableCharacterChannel(readableCharacterChannel);
    if !(readableCsvChannel2 is ReadableCharacterChannel) {
        test:assertFail(msg = "Expected ReadableCharacterChannel not found");
    }
    var err = getReadableCharacterChannel(readableCsvChannel);
    if !(err is TypeMismatchError) {
        test:assertFail(msg = "Expected TypeMismatchError not found");
    }
}

@test:Config {}
isolated function testGetWritableCharacterChannel() returns error? {
    string filePath = TEST_RESOURCE_PATH + "empty.txt";
    WritableByteChannel writableByteChannel = check openWritableFile(filePath);
    WritableCharacterChannel writableCharacterChannel = new(writableByteChannel, DEFAULT_ENCODING);
    WritableCSVChannel writableCsvChannel = new(writableCharacterChannel);

    var writableCsvChannel1 = getWritableCharacterChannel(writableByteChannel);
    if !(writableCsvChannel1 is WritableCharacterChannel) {
        test:assertFail(msg = "Expected WritableCharacterChannel not found");
    }
    var writableCsvChannel2 = getWritableCharacterChannel(writableCharacterChannel);
    if !(writableCsvChannel2 is WritableCharacterChannel) {
        test:assertFail(msg = "Expected WritableCharacterChannel not found");
    }
    var err = getWritableCharacterChannel(writableCsvChannel);
    if !(err is TypeMismatchError) {
        test:assertFail(msg = "Expected TypeMismatchError not found");
    }
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

isolated function isWindowsEnvironment() returns boolean = @java:Method {
    name: "isWindowsEnvironment",
    'class: "org.ballerinalang.stdlib.io.testutils.EnvironmentTestUtils"
} external;
