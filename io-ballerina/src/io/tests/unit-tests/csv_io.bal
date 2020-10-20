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

type Employee record {
    string id;
    string name;
    float salary;
};

type PerDiem record {
    int id;
    string name;
    int age;
    int? beverageAllowance;
    float? total;
    string? department;
};

type CommonApp record {
    string appId;
    string createdDt;
    string exportDt;
    string firstName;
    string middleName;
    string lastName;
    string gender;
    string birthDate;
    string address1;
    string address2;
    string city;
    string state;
    string zip;
    string country;
    string email;
    string phoneNumber;
    string hispLatino;
    string citizenship;
    string schoolLookup;
};

ReadableCSVChannel? csvReadCh = ();
WritableCSVChannel? csvWriteCh = ();

@test:Config {
    dependsOn: ["testWriteProperties"]
}
function testReadCsvTest() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";
    error? initResult = initReadableCsvChannel(filePath, "UTF-8", ",");
    if (initResult is error) {
        test:assertFail(msg = initResult.message());
    }

    int expectedRecordLength = 3;
    var result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    var endResult = nextRecord();
    if (endResult is error) {
        test:assertEquals(endResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
        var hasResult = hasNextRecord();
        if (hasResult is boolean) {
            test:assertFalse(hasResult, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    close();
}

@test:Config {
    dependsOn: ["testReadCsvTest"]
}
function testOpenAndReadCsvTest() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";
    error? initResult = initOpenCsvChannel(filePath, "UTF-8", ",");
    if (initResult is error) {
        test:assertFail(msg = initResult.message());
    }

    int expectedRecordLength = 3;
    var result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    var endResult = nextRecord();
    if (endResult is error) {
        test:assertEquals(endResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
        var hasResult = hasNextRecord();
        if (hasResult is boolean) {
            test:assertFalse(hasResult, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    close();
}

@test:Config {
    dependsOn: ["testOpenAndReadCsvTest"]
}
function testOpenAndReadColonDelimitedFileTest() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleWithColon.txt";
    error? initResult = initOpenCsvChannel(filePath, "UTF-8", ":");
    if (initResult is error) {
        test:assertFail(msg = initResult.message());
    }

    int expectedRecordLength = 3;
    var result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        var recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertFalse(result, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    close();
}

@test:Config {
    dependsOn: ["testOpenAndReadColonDelimitedFileTest"]
}
function testOpenAndReadCsvWithHeadersTest() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleWithHeader.csv";
    error? initResult = initOpenCsvChannel(filePath, "UTF-8", ",", 1);
    if (initResult is error) {
        test:assertFail(msg = initResult.message());
    }

    int expectedRecordLength = 3;
    var recordResult = nextRecord();
    if (recordResult is string[]) {
        test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }


    var result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertFalse(result, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    close();
}

@test:Config {
    dependsOn: ["testOpenAndReadCsvWithHeadersTest"]
}
function testReadRfcTest() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleRfc.csv";
    error? initResult = initOpenCsvChannel(filePath, "UTF-8", ",");
    if (initResult is error) {
        test:assertFail(msg = initResult.message());
    }

    int expectedRecordLength = 3;
    var recordResult = nextRecord();
    if (recordResult is string[]) {
        test:assertEquals(recordResult[0], "User1,12", msg = "Found unexpected output");
        test:assertEquals(recordResult[1], "WSO2", msg = "Found unexpected output");
        test:assertEquals(recordResult[2], "07xxxxxx", msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    var result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult[0], "User4", msg = "Found unexpected output");
            test:assertEquals(recordResult[1], "", msg = "Found unexpected output");
            test:assertEquals(recordResult[2], "123xxxxx", msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    recordResult = nextRecord();
    if (recordResult is error) {
        test:assertEquals(recordResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertFalse(result, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    close();
}

@test:Config {
    dependsOn: ["testReadRfcTest"]
}
function testReadTdfTest() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleTdf.tsv";
    error? initResult = initOpenCsvChannel(filePath, "UTF-8", "\t");
    if (initResult is error) {
        test:assertFail(msg = initResult.message());
    }

    int expectedRecordLength = 3;
    var recordResult = nextRecord();
    if (recordResult is string[]) {
        test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    var result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    recordResult = nextRecord();
    if (recordResult is error) {
        test:assertEquals(recordResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertFalse(result, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    close();
}

@test:Config {
    dependsOn: ["testReadTdfTest"]
}
function testWriteDefaultCsv() {
    string filePath = TEMP_DIR + "recordsDefault.csv";
    string[] content1 = [ "Name", "Email", "Telephone" ];
    string[] content2 = [ "Foo,12", "foo@ballerina/io", "332424242" ];
    error? initWriteResult = initWritableCsvChannel(filePath, "UTF-8", ",");
    if (initWriteResult is error) {
        test:assertFail(msg = initWriteResult.message());
    }
    writeRecord(content1);
    writeRecord(content2);

    error? initReadResult = initReadableCsvChannel(filePath, "UTF-8", ",");
    if (initReadResult is error) {
        test:assertFail(msg = initReadResult.message());
    }

    int expectedRecordLength = 3;
    var recordResult = nextRecord();
    if (recordResult is string[]) {
        test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        test:assertEquals(recordResult[0], content1[0], msg = "Found unexpected output");
        test:assertEquals(recordResult[1], content1[1], msg = "Found unexpected output");
        test:assertEquals(recordResult[2], content1[2], msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    var result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
            test:assertEquals(recordResult[0], content2[0], msg = "Found unexpected output");
            test:assertEquals(recordResult[1], content2[1], msg = "Found unexpected output");
            test:assertEquals(recordResult[2], content2[2], msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertFalse(result, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    close();
}

@test:Config {
    dependsOn: ["testWriteDefaultCsv"]
}
function testReadWriteCustomSeparator() {
    string filePath = TEMP_DIR + "recordsUserDefine.csv";
    string[][] data = [
            [ "1", "James", "10000" ], [ "2", "Nathan", "150000" ], [ "3", "Ronald", "120000" ],
            [ "4", "Roy", "6000" ], [ "5", "Oliver", "1100000" ]
    ];
    error? initWriteResult = initWritableCsvChannel(filePath, "UTF-8", ",");
    if (initWriteResult is error) {
        test:assertFail(msg = initWriteResult.message());
    }
    foreach string[] entry in data {
        writeRecord(entry);
    }

    error? initReadResult = initReadableCsvChannel(filePath, "UTF-8", ",");
    if (initReadResult is error) {
        test:assertFail(msg = initReadResult.message());
    }

    int expectedRecordLength = 3;
    var recordResult = nextRecord();
    if (recordResult is string[]) {
        test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
        test:assertEquals(recordResult[0], data[0][0], msg = "Found unexpected output");
        test:assertEquals(recordResult[1], data[0][1], msg = "Found unexpected output");
        test:assertEquals(recordResult[2], data[0][2], msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    var result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
            test:assertEquals(recordResult[0], data[1][0], msg = "Found unexpected output");
            test:assertEquals(recordResult[1], data[1][1], msg = "Found unexpected output");
            test:assertEquals(recordResult[2], data[1][2], msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
            test:assertEquals(recordResult[0], data[2][0], msg = "Found unexpected output");
            test:assertEquals(recordResult[1], data[2][1], msg = "Found unexpected output");
            test:assertEquals(recordResult[2], data[2][2], msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
            test:assertEquals(recordResult[0], data[3][0], msg = "Found unexpected output");
            test:assertEquals(recordResult[1], data[3][1], msg = "Found unexpected output");
            test:assertEquals(recordResult[2], data[3][2], msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertTrue(result, msg = "Found unexpected output");
        recordResult = nextRecord();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength, msg = "Found unexpected output");
            test:assertEquals(recordResult[0], data[4][0], msg = "Found unexpected output");
            test:assertEquals(recordResult[1], data[4][1], msg = "Found unexpected output");
            test:assertEquals(recordResult[2], data[4][2], msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    result = hasNextRecord();
    if (result is boolean) {
        test:assertFalse(result, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }

    close();
}

@test:Config {
    dependsOn: ["testReadWriteCustomSeparator"]
}
function testWriteTdf() {
    string filePath = TEMP_DIR + "recordsTdf.csv";
    string[] content = [ "Name", "Email", "Telephone" ];
    error? initWriteResult = initWritableCsvChannel(filePath, "UTF-8", "\t");
    if (initWriteResult is error) {
        test:assertFail(msg = initWriteResult.message());
    }
    writeRecord(content);
    close();
}

@test:Config {
    dependsOn: ["testWriteTdf"]
}
function testTableContent() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample5.csv";
    var result = getTable(filePath, "UTF-8", ",");
    float expectedValue = 60001.00;
    if (result is float) {
        test:assertEquals(result, expectedValue, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {
    dependsOn: ["testTableContent"]
}
function testTableWithNull() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample6.csv";
    var result = getTableWithNill(filePath);
    if (result is [string, string]) {
        test:assertEquals(result[0], "Person1Person2Person3", msg = "Found unexpected output");
        test:assertEquals(result[1], "EngMrk-1", msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {
    dependsOn: ["testTableWithNull"]
}
function testTableWithHeader() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample7.csv";
    var result = getTableWithHeader(filePath);
    string[] expectedOutput = [
            "Common App ID", "11111111", "22222222", "33333333", "44444444", "55555555", "55555556"
    ];
    if (result is string[]) {
        int i = 0;
        foreach string s in expectedOutput {
            test:assertEquals(result[i], s, msg = "Found unexpected output");
            i += 1;
        }
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config{}
function testFileCsvWrite() {
    string[][] content = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
        ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"]
    ];
    string filePath = TEMP_DIR + "workers1.csv";
    var result = fileWriteCsv(filePath, content);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config{
    dependsOn: ["testFileCsvWrite"]
}
function testFileCsvRead() {
    string[][] expectedContent = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
        ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"]
    ];
    string filePath = TEMP_DIR + "workers1.csv";
    var result = fileReadCsv(filePath);
    if (result is string[][]) {
        int i = 0;
        foreach string[] r in expectedContent {
            int j = 0;
            foreach string s in r {
                test:assertEquals(s, expectedContent[i][j]);
                j += 1;
            }
            i += 1;
        }
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config{}
function testFileCsvWriteWithSkipHeaders() {
    string[][] content = [
        ["Name", "Occupation", "Company", "Age", "Hometown"],
        ["Ross Meton", "Civil Engineer", "ABC Construction", "26 years", "Sydney"],
        ["Matt Jason", "Architect", "Typer", "38 years", "Colombo"]
    ];
    string filePath = TEMP_DIR + "workers2.csv";
    var result = fileWriteCsv(filePath, content, COMMA, 1);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config{
    dependsOn: ["testFileCsvWriteWithSkipHeaders"]
}
function testFileCsvReadWithSkipHeaders() {
    string[][] expectedContent = [
        ["Name", "Occupation", "Company", "Age", "Hometown"],
        ["Ross Meton", "Civil Engineer", "ABC Construction", "26 years", "Sydney"],
        ["Matt Jason", "Architect", "Typer", "38 years", "Colombo"]
    ];
    string filePath = TEMP_DIR + "workers2.csv";
    var result = fileReadCsv(filePath, COMMA, 1);
    if (result is string[][]) {
        int i = 0;
        foreach string[] r in expectedContent {
            int j = 0;
            foreach string s in r {
                test:assertEquals(s, expectedContent[i][j]);
                j += 1;
            }
            i += 1;
        }
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config{}
function testFileCsvWriteWithColon() {
    string[][] content = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
        ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"]
    ];
    string filePath = TEMP_DIR + "workers3.csv";
    var result = fileWriteCsv(filePath, content, COLON);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config{
    dependsOn: ["testFileCsvWriteWithColon"]
}
function testFileCsvReadWithColon() {
    string[][] expectedContent = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
        ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"]
    ];
    string filePath = TEMP_DIR + "workers3.csv";
    var result = fileReadCsv(filePath, COLON);
    if (result is string[][]) {
        int i = 0;
        foreach string[] r in expectedContent {
            int j = 0;
            foreach string s in r {
                test:assertEquals(s, expectedContent[i][j]);
                j += 1;
            }
            i += 1;
        }
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
function testFileWriteCsvFromStream() {
    string filePath = TEMP_DIR + "workers4.csv";
    string[][] content = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
        ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"]
    ];
    var result = fileWriteCsvFromStream(filePath, content.toStream());
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {
    dependsOn: ["testFileWriteCsvFromStream"]
}
function testFileReadCsvAsStream() {
    string filePath = TEMP_DIR + "workers4.csv";
    string[][] expectedContent = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
        ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"]
    ];
    var result = fileReadCsvAsStream(filePath);
    if (result is stream<string[]>) {
        int i = 0;
        _ = result.forEach(function(string[] val) {
            int j = 0;
            foreach string s in val {
                test:assertEquals(s, expectedContent[i][j]);
                j += 1;
            }
            i += 1;
        });
    } else if (result is Error) {
        test:assertFail(msg = result.message());
    } else {
        test:assertFail("Unknown error occured");
    }
}

function initReadableCsvChannel(string filePath, string encoding, Separator fieldSeparator) returns error? {
    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel charChannel = new ReadableCharacterChannel(byteChannel, encoding);
        csvReadCh = new ReadableCSVChannel(charChannel, fieldSeparator);
    } else {
        return byteChannel;
    }
}

function initWritableCsvChannel(string filePath, string encoding, Separator fieldSeparator) returns error? {
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel charChannel = new WritableCharacterChannel(byteChannel, encoding);
    csvWriteCh = new WritableCSVChannel(charChannel, fieldSeparator);
}

function initOpenCsvChannel(string filePath, string encoding, Separator fieldSeparator, int nHeaders = 0) returns error? {
    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel charChannel = new ReadableCharacterChannel(byteChannel, encoding);
        csvReadCh = new ReadableCSVChannel(charChannel, fieldSeparator, nHeaders);
    } else {
        return byteChannel;
    }
}

function nextRecord() returns @tainted string[]|error {
    var cha = csvReadCh;
    if (cha is ReadableCSVChannel) {
        var result = cha.getNext();
        if (result is string[]) {
            return result;
        } else if (result is error) {
            return result;
        }
    }
    return GenericError("Record channel not initialized properly");
}

function writeRecord(string[] fields) {
    var cha = csvWriteCh;
    if (cha is WritableCSVChannel) {
        var result = cha.write(fields);
    }
}

function close() {
    var rcha = csvReadCh;
    var wcha = csvWriteCh;
    if (rcha is ReadableCSVChannel) {
        checkpanic rcha.close();
    }
    if (wcha is WritableCSVChannel) {
        checkpanic wcha.close();
    }
}

function hasNextRecord() returns boolean? {
    var rcha = csvReadCh;
    if (rcha is ReadableCSVChannel) {
        return rcha.hasNext();
    }
}

function getTable(string filePath, string encoding, Separator fieldSeparator) returns @tainted float|error {
    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel charChannel = new ReadableCharacterChannel(byteChannel, encoding);
        ReadableCSVChannel csv = new ReadableCSVChannel(charChannel, fieldSeparator);
        float total = 0.0;
        var tableResult = csv.getTable(Employee);
        if (tableResult is table<record {}>) {
            table<Employee> tb = <table<Employee>> tableResult;
            foreach var x in tb {
                total = total + x.salary;
            }
            error? closeResult = byteChannel.close();
            return total;
        } else {
            return tableResult;
        }
    } else {
        return byteChannel;
    }
}

function getTableWithNill(string filePath) returns @tainted [string, string]|error {
    string name = "";
    string dep = "";
    var rCsvChannel = openReadableCsvFile(filePath, skipHeaders = 1);
    if (rCsvChannel is ReadableCSVChannel) {
        var tblResult = rCsvChannel.getTable(PerDiem);
        if (tblResult is table<record {}>) {
            table<PerDiem> tb = <table<PerDiem>> tblResult;
            foreach var rec in tb {
                name = name + rec.name;
                dep = dep + (rec.department ?: "-1");
            }
            error? closeResult = rCsvChannel.close();
        } else {
            return tblResult;
        }
    }
    return [name, dep];
}

function getTableWithHeader(string filePath) returns @tainted string[]|error {
    var rCsvChannel = openReadableCsvFile(filePath, skipHeaders = 0);
    string[] keys = [];
    if (rCsvChannel is ReadableCSVChannel) {
        var tblResult = rCsvChannel.getTable(CommonApp);
        if (tblResult is table<record {}>) {
            table<CommonApp> tb = <table<CommonApp>> tblResult;
            foreach var rec in tb {
                keys.push(rec.appId);
            }
            error? closeResult = rCsvChannel.close();
        } else {
            return tblResult;
        }
    }
    return keys;
}
