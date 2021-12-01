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
isolated function testReadRecordLengths() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";
    int expectedRecordLength = 3;

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        ReadableTextRecordChannel recordChannel = new ReadableTextRecordChannel(characterChannel, COMMA, NEW_LINE);

        test:assertTrue(recordChannel.hasNext());
        var recordResult = recordChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else {
            test:assertFail(msg = recordResult.message());
        }

        test:assertTrue(recordChannel.hasNext());
        recordResult = recordChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else {
            test:assertFail(msg = recordResult.message());
        }

        test:assertTrue(recordChannel.hasNext());
        recordResult = recordChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else {
            test:assertFail(msg = recordResult.message());
        }

        test:assertFalse(recordChannel.hasNext());
        var endResult = recordChannel.getNext();
        if (endResult is error) {
            test:assertEquals(endResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        var closeResult = recordChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
isolated function testWriteRecords() {
    string filePath = TEMP_DIR + "recordsFile.csv";
    string[] content = ["Name", "Email", "Telephone"];

    var byteChannel = openWritableFile(filePath);
    if (byteChannel is WritableByteChannel) {
        WritableCharacterChannel charChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        WritableTextRecordChannel recordChannel = new WritableTextRecordChannel(charChannel, NEW_LINE, COMMA);

        var result = recordChannel.write(content);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = recordChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testWriteRecords]}
isolated function testReadRecordContent() {
    string filePath = TEMP_DIR + "recordsFile.csv";
    string[] expectedContent = ["Name", "Email", "Telephone"];

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        ReadableTextRecordChannel recordChannel = new ReadableTextRecordChannel(characterChannel, NEW_LINE, COMMA);

        test:assertTrue(recordChannel.hasNext());
        var recordResult = recordChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult[0], expectedContent[0]);
            test:assertEquals(recordResult[1], expectedContent[1]);
            test:assertEquals(recordResult[2], expectedContent[2]);
        } else {
            test:assertFail(msg = recordResult.message());
        }

        test:assertFalse(recordChannel.hasNext());
        var endResult = recordChannel.getNext();
        if (endResult is error) {
            test:assertEquals(endResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        var closeResult = recordChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
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

    string[]|Error r2 = recordChannel.getNext();
    if r2 is Error {
        test:assertEquals(r2.message(), "Record channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }
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
    if r is Error {
        test:assertEquals(r.message(), "Record channel is already closed.");
    } else {
        test:assertFail(msg = "Expected io:Error not found");
    }
}
