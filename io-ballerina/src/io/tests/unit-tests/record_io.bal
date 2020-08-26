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

ReadableTextRecordChannel? recordReadCh = ();
WritableTextRecordChannel? recordWriteCh = ();

@test:Config {}
function testReadRecords() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";
    error? initResult = initReadableRecordChannel(filePath, "UTF-8", "\n", ",");
    if (initResult is error) {
        test:assertFail(msg = initResult.message());
    }

    int expectedRecordLength = 3;
    var result = hasNextTextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextTextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextTextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextTextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextTextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextTextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    var endResult = nextTextRecord();
    if (endResult is error) {
        test:assertEquals(endResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
        var hasResult = hasNextTextRecord();
        if (hasResult is boolean) {
            test:assertFalse(hasResult, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    closeReadableRecordChannel();
}

@test:Config {
    dependsOn: ["testReadRecords"]
}
function testWriteRecords() {
    string filePath = TEMP_DIR + "recordsFile.csv";
    string[] content = [ "Name", "Email", "Telephone"];
    Error? initWritableResult = initWritableRecordChannel(filePath, "UTF-8", "\n", ",");
    if (initWritableResult is Error) {
        test:assertFail(msg = initWritableResult.message());
    }
    writeTextRecord(content);

    error? initReadableResult = initReadableRecordChannel(filePath, "UTF-8", "\n", ",");
    if (initReadableResult is error) {
        test:assertFail(msg = initReadableResult.message());
    }

    var result = hasNextTextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextTextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult[0], content[0], msg = "Found unexpected output");
            test:assertEquals(recordResult[1], content[1], msg = "Found unexpected output");
            test:assertEquals(recordResult[2], content[2], msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }


    var hasResult = hasNextTextRecord();
    if (hasResult is boolean) {
        test:assertFalse(hasResult, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }
    closeWritableBytesChannel();
}

function initReadableRecordChannel(string filePath, string encoding, string recordSeparator,
                                    string fieldSeparator) returns error? {
    var byteChannel = openReadableFile(filePath);
    if (byteChannel is error) {
        return byteChannel;
    } else {
        ReadableCharacterChannel charChannel = new ReadableCharacterChannel(byteChannel, encoding);
        recordReadCh = <ReadableTextRecordChannel> new ReadableTextRecordChannel(charChannel, fieldSeparator, recordSeparator);
    }
}

function initWritableRecordChannel(string filePath, string encoding, string recordSeparator,
                             string fieldSeparator) returns Error? {
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel charChannel = new WritableCharacterChannel(byteChannel, encoding);
    recordWriteCh = <WritableTextRecordChannel> new WritableTextRecordChannel(charChannel, fieldSeparator, recordSeparator);
}


function nextTextRecord() returns @tainted string[]|error {
    var cha = recordReadCh;
    if(cha is ReadableTextRecordChannel) {
        var result = cha.getNext();
        return result;
    }
    return GenericError("Record channel not initialized properly");
}

function writeTextRecord(string[] fields) {
    var cha = recordWriteCh;
    if(cha is WritableTextRecordChannel){
        var result = cha.write(fields);
    }
}

function closeReadableRecordChannel() {
    var cha = recordReadCh;
    if(cha is ReadableTextRecordChannel) {
        var err = cha.close();
    }
}

function closeWritableRecordChannel() {
    var cha = recordWriteCh;
    if(cha is WritableTextRecordChannel) {
        var err = cha.close();
    }
}


function hasNextTextRecord() returns boolean? {
    var cha = recordReadCh;
    if(cha is ReadableTextRecordChannel) {
        return cha.hasNext();
    }
}
