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

@test:Config {}
isolated function testReadRecordLengths() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";
    int expectedRecordLength = 3;

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    ReadableTextRecordChannel recordChannel = new ReadableTextRecordChannel(characterChannel, COMMA, NEW_LINE);

    test:assertTrue(recordChannel.hasNext());
    string[] recordResult = check recordChannel.getNext();
    
    test:assertEquals(recordResult.length(), expectedRecordLength);

    test:assertTrue(recordChannel.hasNext());
    recordResult = check recordChannel.getNext();
    test:assertEquals(recordResult.length(), expectedRecordLength);

    test:assertTrue(recordChannel.hasNext());
    recordResult = check recordChannel.getNext();
    test:assertEquals(recordResult.length(), expectedRecordLength);

    test:assertFalse(recordChannel.hasNext());
    var endResult = recordChannel.getNext();
    test:assertTrue(endResult is Error);
    test:assertEquals((<Error>endResult).message(), "EoF when reading from the channel");

    check recordChannel.close();
}

@test:Config {}
isolated function testWriteRecords() returns Error? {
    string filePath = TEMP_DIR + "recordsFile.csv";
    string[] content = ["Name", "Email", "Telephone"];

    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel charChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    WritableTextRecordChannel recordChannel = new WritableTextRecordChannel(charChannel, NEW_LINE, COMMA);

    check recordChannel.write(content);
    check recordChannel.close();
}

@test:Config {dependsOn: [testWriteRecords]}
isolated function testReadRecordContent() returns Error? {
    string filePath = TEMP_DIR + "recordsFile.csv";
    string[] expectedContent = ["Name", "Email", "Telephone"];

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    ReadableTextRecordChannel recordChannel = new ReadableTextRecordChannel(characterChannel, NEW_LINE, COMMA);

    test:assertTrue(recordChannel.hasNext());
    string[] recordResult = check recordChannel.getNext();
    test:assertEquals(recordResult[0], expectedContent[0]);
    test:assertEquals(recordResult[1], expectedContent[1]);
    test:assertEquals(recordResult[2], expectedContent[2]);

    test:assertFalse(recordChannel.hasNext());
    var endResult = recordChannel.getNext();
    test:assertTrue(endResult is Error);
    test:assertEquals((<Error>endResult).message(), "EoF when reading from the channel");
    check recordChannel.close();
}

@test:Config {}
isolated function testReadRecordAfterClosing() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    ReadableTextRecordChannel recordChannel = new ReadableTextRecordChannel(characterChannel, COMMA, NEW_LINE);
    test:assertTrue(recordChannel.hasNext());
    _ = check recordChannel.getNext();

    check recordChannel.close();

    string[]|Error r = recordChannel.getNext();
    test:assertTrue(r is Error);
    test:assertEquals((<Error>r).message(), "Record channel is already closed.");
}

@test:Config {}
isolated function testWriteRecordsAfterClosing() returns Error? {
    string filePath = TEMP_DIR + "recordsFile1.csv";
    string[] content = ["Name", "Email", "Telephone"];

    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel charChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    WritableTextRecordChannel recordChannel = new WritableTextRecordChannel(charChannel, NEW_LINE, COMMA);
    check recordChannel.write(content);

    check recordChannel.close();

    Error? r = recordChannel.write(content);
    test:assertTrue(r is Error);
    test:assertEquals((<Error>r).message(), "Record channel is already closed.");
}

@test:Config {}
isolated function testReadableRecordCloseTwice() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    ReadableTextRecordChannel recordChannel = new ReadableTextRecordChannel(characterChannel, COMMA, NEW_LINE);

    check recordChannel.close();
    Error? r = recordChannel.close();
    test:assertTrue(r is Error);
    test:assertEquals((<Error>r).message(), "Record channel is already closed.");
}

@test:Config {}
isolated function testWritableRecordChannelCloseTwice() returns Error? {
    string filePath = TEMP_DIR + "recordsFile2.csv";
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel charChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    WritableTextRecordChannel recordChannel = new WritableTextRecordChannel(charChannel, NEW_LINE, COMMA);

    check recordChannel.close();
    Error? r = recordChannel.close();
    test:assertTrue(r is Error);
    test:assertEquals((<Error>r).message(), "Record channel is already closed.");
}
