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

@test:Config {}
isolated function testFileNotFound() {
    string filePath = TEMP_DIR + "unknown.txt";
    var err = openReadableFile(filePath);
    test:assertTrue(err is Error);
    test:assertTrue((<Error>err).message().includes("no such file or directory:"));
    test:assertTrue((<Error>err).message().includes("unknown.txt"));
}

@test:Config {}
isolated function testReadCharactersWithInvalidEncoding() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/charfile.txt";
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel|error result = trap new ReadableCharacterChannel(byteChannel, "abcd");
    test:assertTrue(result is error);
    test:assertEquals((<error>result).message(), "Unsupported encoding type abcd");
}

@test:Config {}
isolated function testWriteCharactersWithInvalidEncoding() returns Error? {
    string filePath = TEMP_DIR + "unknown.txt";

    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel|error result = trap new WritableCharacterChannel(byteChannel, "abcd");
    test:assertTrue(result is error);
    test:assertEquals((<error>result).message(), "Unsupported encoding type abcd");
}

@test:Config {}
function testFileReadBytesAsStreamAfterClosing() returns Error? {
    string filePath = TEMP_DIR + "bytesFile12.txt";
    string resourceFilePath = TEMP_DIR + "bytesResourceFile12.txt";
    string content = "Ballerina is an ";
    check fileWriteString(resourceFilePath, content);
    stream<Block, Error?> bytesStream = check fileReadBlocksAsStream(resourceFilePath, 2);

    check fileWriteBlocksFromStream(filePath, bytesStream);
    stream<Block, Error?> resultByteStream = check fileReadBlocksAsStream(filePath, 2);
    _ = check resultByteStream.next();
    _ = check resultByteStream.close();
    var result = resultByteStream.next();
    test:assertTrue(result is Error);
    test:assertEquals((<Error>result).message(), "Stream closed");
}

@test:Config {}
function testFileReadLinesAsStreamAfterClosing() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines3.txt";
    string[] content = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];

    check fileWriteLinesFromStream(filePath, content.toStream());
    stream<string, Error?> resultStream = check fileReadLinesAsStream(filePath);
    _ = check resultStream.next();
    check resultStream.close();
    var result = resultStream.next();
    test:assertTrue(result is Error);
    test:assertEquals((<Error>result).message(), "Stream closed");
}

@test:Config {}
function testFileReadCsvAsStreamAfterClosing() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines3.txt";
    string[][] content = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        [
            "John Thomson",
            "Software Architect",
            "WSO2",
            "38 years",
            "Colombo"
        ],
        [
            "Mary Thompson",
            "Banker",
            "Sampath Bank",
            "30 years",
            "Colombo"
        ]
    ];

    check fileWriteCsvFromStream(filePath, content.toStream());
    stream<string[], Error?> resultStream = check fileReadCsvAsStream(filePath);
    _ = check resultStream.next();
    check resultStream.close();
    var result = resultStream.next();
    test:assertTrue(result is Error);
    test:assertEquals((<Error>result).message(), "Stream closed");
}

@test:Config {}
function testchannelReadCsvAsStreamAfterClosing() returns Error? {
    string filePath = TEMP_DIR + "stringContentAsLines3.txt";
    string[][] content = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        [
            "John Thomson",
            "Software Architect",
            "WSO2",
            "38 years",
            "Colombo"
        ],
        [
            "Mary Thompson",
            "Banker",
            "Sampath Bank",
            "30 years",
            "Colombo"
        ]
    ];

    check fileWriteCsvFromStream(filePath, content.toStream());
    stream<string[], Error?> resultStream = check channelReadCsvAsStream(check openReadableCsvFile(filePath));
    check resultStream.close();
    var csvContent = resultStream.next();
    test:assertTrue(csvContent is Error);
    test:assertEquals((<Error>csvContent).message(), "Stream closed");
}

@test:Config {dependsOn: [testFileCsvWriteWithSkipHeaders]}
isolated function testFileCsvReadWithDefectiveRecords() returns Error? {

    string filePath = TEMP_DIR + "workers2.csv";
    Employee6[]|Error csvContent = fileReadCsv(filePath);
    test:assertTrue(csvContent is Error);
    test:assertEquals((<Error>csvContent).message(), "The CSV file content header count(5) doesn't match with ballerina record field count(4). ");
}

@test:Config {}
function testReadFileCsvUsingResourceFileWithError() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample5d2.csv";
    Employee4[]|Error csvContent = fileReadCsv(filePath);
    test:assertEquals((<Error>csvContent).message(), "Invalid value: 10000s for the field: 'salary'");
}

@test:Config {}
function testReadFileCsvAsStreamUsingResourceFileWithError() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample5d2.csv";
    stream<Employee4, Error?> csvContent = check fileReadCsvAsStream(filePath);
    Error? out = csvContent.forEach(function(Employee4|Error value) {
    });
    test:assertEquals((<Error>out).message(), "Invalid value: 10000s for the field: 'salary'");
}

@test:Config {}
function testReadFileCsvWithReferenceTypeAndError() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleRefE.csv";
    stream<EmployeeRef, Error?> csvContent = check fileReadCsvAsStream(filePath);
    Error? out = csvContent.forEach(function(EmployeeRef value) {
    });
    test:assertEquals((<Error>out).message(), "Invalid value: 10000s for the field: 'salary'");
}

@test:Config {dependsOn: [testWriteDefaultCsv]}
function testAppendDifferentCsvFile() {
    string filePath = TEMP_DIR + "recordsDefault.csv";
    B d1 = {A1: 1, A2: 2, B1: 3, B2: 4};
    B d2 = {B1: 3, B2: 4, A1: 1, A2: 2};
    B[] content = [d1, d2];
    Error? out = fileWriteCsv(filePath, content, APPEND);
    test:assertEquals((<Error>out).message(), "The CSV file content header count(3) doesn't match with ballerina record field count(4). ");
}

@test:Config {dependsOn: [testCsvWriteWithUnorderedRecords]}
function testAppendDifferentCsvFile2() {
    string filePath = TEMP_DIR + "records_unordered_records.csv";
    D d1 = {A1: 1, A2: 2, D1: 3, D2: 4};
    D d2 = {D1: 3, D2: 4, A1: 1, A2: 2};
    D[] content = [d1, d2];
    Error? out = fileWriteCsv(filePath, content, APPEND);
    test:assertEquals((<Error>out).message(), "The CSV file does not contain the header - D1. ");
}

@test:Config {}
function testAppendFalseCsv() {
    string filePath = TEMP_DIR + "records_false_records.csv";
    string[][] false_content = [["B1", "B1", "D1", "D2"], ["1", "2", "3", "4"]];
    Error? out = fileWriteCsv(filePath, false_content);
    D d1 = {A1: 1, A2: 2, D1: 3, D2: 4};
    D d2 = {D1: 3, D2: 4, A1: 1, A2: 2};
    D[] content = [d1, d2];
    out = fileWriteCsv(filePath, content, APPEND);
    test:assertEquals((<Error>out).message(), "The CSV file does not contain the header - A1. ");
}

@test:Config {}
function readNonExistantCsvFile() {
    string filePath = TEMP_DIR + "non_existant_csv.csv";
    string[][]|Error out = fileReadCsv(filePath);
    test:assertTrue((<Error>out).message().includes("no such file or directory", 0));
}

@test:Config {}
function readNonExistantCsvFileAsStream() {
    string filePath = TEMP_DIR + "non_existant_csv.csv";
    stream<string[], Error?>|Error out = fileReadCsvAsStream(filePath);
    test:assertTrue((<Error>out).message().includes("no such file or directory", 0));
}

@test:Config {}
function writeEmptyStreamtoCsv() returns error? {
    string filePath = TEMP_DIR + "empty.csv";
    test:assertEquals(check fileWriteCsvFromStream(filePath, content = new ()), ());
}

@test:Config {}
function writeEmptyArraytoCsv() returns error? {
    string filePath = TEMP_DIR + "empty2.csv";
    D[] content = [];
    test:assertEquals(check fileWriteCsv(filePath, content), ());
}

@test:Config {}
function writeEmptyStringArraytoCsv() returns error? {
    string filePath = TEMP_DIR + "empty3.csv";
    string[][] content = [[], []];
    test:assertEquals(check fileWriteCsv(filePath, content), ());
}

@test:Config {dependsOn: [testFileCsvWriteWithSkipHeaders]}
isolated function testFileCsvReadWithSkipHeadersRecords() returns Error? {
    string filePath = TEMP_DIR + "workers2.csv";
    Employee5[]|Error out = fileReadCsv(filePath, 1);
    test:assertEquals((<Error>out).message(), "Parameter `skipHeaders` cannot be used with record data mapping. ");
}
