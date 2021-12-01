// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/lang.'string as langstring;

@test:Config {}
isolated function testFileNotFound() {
    string filePath = TEMP_DIR + "unknown.txt";
    var err = openReadableFile(filePath);

    if err is Error {
        test:assertTrue(langstring:includes(err.message(), "no such file or directory:", 0));
        test:assertTrue(langstring:includes(err.message(), "unknown.txt", 0));
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }
}

@test:Config {}
isolated function testReadCharactersWithInvalidEncoding() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/charfile.txt";
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel|error result = trap new ReadableCharacterChannel(byteChannel, "abcd");

    if result is Error {
        test:assertEquals(result.message(), "Unsupported encoding type abcd");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }
}

@test:Config {}
isolated function testWriteCharactersWithInvalidEncoding() returns Error? {
    string filePath = TEMP_DIR + "unknown.txt";

    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel|error result = trap new WritableCharacterChannel(byteChannel, "abcd");

    if result is Error {
        test:assertEquals(result.message(), "Unsupported encoding type abcd");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }
}

@test:Config {}
function testFileReadBytesAsStreamAfterClosing() returns Error? {
    string filePath = TEMP_DIR + "bytesFile12.txt";
    string resourceFilePath = TEMP_DIR + "bytesResourceFile12.txt";
    string content = "Ballerina is an ";
    check fileWriteString(resourceFilePath, content);
    stream<Block, Error?> bytesStream = check fileReadBlocksAsStream(resourceFilePath, 2);

    _ = check fileWriteBlocksFromStream(filePath, bytesStream);
    stream<Block, Error?> resultByteStream = check fileReadBlocksAsStream(filePath, 2);
    _ = check resultByteStream.next();
    _ = check resultByteStream.close();
    var result = resultByteStream.next();
    if result is Error {
        test:assertEquals(result.message(), "Stream closed");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }
}

@test:Config {}
function testFileReadLinesAsStreamAfterClosing() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines3.txt";
    string[] content = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];

    _ = check fileWriteLinesFromStream(filePath, content.toStream());
    stream<string, Error?> resultStream = check fileReadLinesAsStream(filePath);
    _ = check resultStream.next();
    _ = check resultStream.close();
    var result = resultStream.next();
    if result is Error {
        test:assertEquals(result.message(), "Stream closed");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }
}

@test:Config {}
function testFileReadCsvAsStreamAfterClosing() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines3.txt";
    string[][] content = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], ["John Thomson",
    "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", "30 years",
    "Colombo"]];

    _ = check fileWriteCsvFromStream(filePath, content.toStream());
    stream<string[], Error?> resultStream = check fileReadCsvAsStream(filePath);
    _ = check resultStream.next();
    _ = check resultStream.close();
    var result = resultStream.next();
    if result is Error {
        test:assertEquals(result.message(), "Stream closed");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }
}
