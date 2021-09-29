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

import ballerina/lang.'string;
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

type Employee2 record {
    string emp_type;
    string emp_no;
    string name;
    float salary;
};

@test:Config {}
isolated function testReadCsv() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";
    int expectedRecordLength = 3;

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        ReadableCSVChannel csvChannel = new ReadableCSVChannel(characterChannel, COMMA);

        test:assertTrue(csvChannel.hasNext());
        var recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertFalse(csvChannel.hasNext());
        var endResult = csvChannel.getNext();
        if (endResult is error) {
            test:assertEquals(endResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        var closeResult = csvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
isolated function testOpenAndReadCsv() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";
    int expectedRecordLength = 3;

    var csvChannel = openReadableCsvFile(filePath);
    if (csvChannel is ReadableCSVChannel) {
        test:assertTrue(csvChannel.hasNext());
        var recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertFalse(csvChannel.hasNext());
        var endResult = csvChannel.getNext();
        if (endResult is error) {
            test:assertEquals(endResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        var closeResult = csvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = csvChannel.message());
    }
}

@test:Config {}
isolated function testOpenAndReadColonDelimitedFile() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleWithColon.txt";
    int expectedRecordLength = 3;

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        ReadableCSVChannel csvChannel = new ReadableCSVChannel(characterChannel, COLON);

        test:assertTrue(csvChannel.hasNext());
        var recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertFalse(csvChannel.hasNext());
        var endResult = csvChannel.getNext();
        if (endResult is error) {
            test:assertEquals(endResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        var closeResult = csvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testOpenAndReadColonDelimitedFile]}
isolated function testOpenAndReadCsvWithHeaders() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleWithHeader.csv";
    int expectedRecordLength = 3;

    var csvChannel = openReadableCsvFile(filePath, COMMA, DEFAULT_ENCODING, 1);
    if (csvChannel is ReadableCSVChannel) {
        test:assertTrue(csvChannel.hasNext());
        var recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        var closeResult = csvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = csvChannel.message());
    }
}

@test:Config {}
isolated function testReadRfc() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleRfc.csv";
    int expectedRecordLength = 3;

    var csvChannel = openReadableCsvFile(filePath);
    if (csvChannel is ReadableCSVChannel) {
        test:assertTrue(csvChannel.hasNext());
        var recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
            test:assertEquals(recordResult[0], "User1,12", msg = "Found unexpected output");
            test:assertEquals(recordResult[1], "WSO2", msg = "Found unexpected output");
            test:assertEquals(recordResult[2], "07xxxxxx", msg = "Found unexpected output");
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        var closeResult = csvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = csvChannel.message());
    }
}

@test:Config {}
isolated function testReadTdf() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleTdf.tsv";
    int expectedRecordLength = 3;

    var csvChannel = openReadableCsvFile(filePath, TAB);
    if (csvChannel is ReadableCSVChannel) {
        test:assertTrue(csvChannel.hasNext());
        var recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(csvChannel.hasNext());
        recordResult = csvChannel.getNext();
        if (recordResult is string[]) {
            test:assertEquals(recordResult.length(), expectedRecordLength);
        } else if (recordResult is Error) {
            test:assertFail(msg = recordResult.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertFalse(csvChannel.hasNext());
        var endResult = csvChannel.getNext();
        if (endResult is error) {
            test:assertEquals(endResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        var closeResult = csvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = csvChannel.message());
    }
}

@test:Config {}
isolated function testWriteDefaultCsv() {
    string filePath = TEMP_DIR + "recordsDefault.csv";
    string[] content1 = ["Name", "Email", "Telephone"];
    string[] content2 = ["Foo,12", "foo@ballerina/io", "332424242"];
    int expectedRecordLength = 3;

    var writeCsvChannel = openWritableCsvFile(filePath);
    if (writeCsvChannel is WritableCSVChannel) {
        var writeResult = writeCsvChannel.write(content1);
        if (writeResult is Error) {
            test:assertFail(msg = writeResult.message());
        }
        writeResult = writeCsvChannel.write(content2);
        if (writeResult is Error) {
            test:assertFail(msg = writeResult.message());
        }
    } else {
        test:assertFail(msg = writeCsvChannel.message());
    }

    var readCsvChannel = openReadableCsvFile(filePath);
    if (readCsvChannel is ReadableCSVChannel) {
        test:assertTrue(readCsvChannel.hasNext());
        var recordResult1 = readCsvChannel.getNext();
        if (recordResult1 is string[]) {
            test:assertEquals(recordResult1.length(), expectedRecordLength);
            test:assertEquals(recordResult1[0], content1[0]);
            test:assertEquals(recordResult1[1], content1[1]);
            test:assertEquals(recordResult1[2], content1[2]);
        } else if (recordResult1 is Error) {
            test:assertFail(msg = recordResult1.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertTrue(readCsvChannel.hasNext());
        var recordResult2 = readCsvChannel.getNext();
        if (recordResult2 is string[]) {
            test:assertEquals(recordResult2.length(), expectedRecordLength);
            test:assertEquals(recordResult2[0], content2[0]);
            test:assertEquals(recordResult2[1], content2[1]);
            test:assertEquals(recordResult2[2], content2[2]);
        } else if (recordResult2 is Error) {
            test:assertFail(msg = recordResult2.message());
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        test:assertFalse(readCsvChannel.hasNext());
        var endResult = readCsvChannel.getNext();
        if (endResult is error) {
            test:assertEquals(endResult.message(), "EoF when reading from the channel", msg = "Found unexpected output");
        } else {
            test:assertFail(msg = "Unexpected result");
        }

        var closeResult = readCsvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }

    } else {
        test:assertFail(msg = readCsvChannel.message());
    }
}

@test:Config {}
isolated function testReadWriteCustomSeparator() {
    string filePath = TEMP_DIR + "recordsUserDefine.csv";
    string[][] data = [["1", "James", "10000"], ["2", "Nathan", "150000"], ["3", "Ronald", "120000"], ["4", "Roy", 
    "6000"], ["5", "Oliver", "1100000"]];
    int expectedRecordLength = 3;

    var writeCsvChannel = openWritableCsvFile(filePath);
    if (writeCsvChannel is WritableCSVChannel) {
        foreach string[] entry in data {
            var writeResult = writeCsvChannel.write(entry);
            if (writeResult is Error) {
                test:assertFail(msg = writeResult.message());
            }
        }
        var closeResult = writeCsvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = writeCsvChannel.message());
    }

    var readCsvChannel = openReadableCsvFile(filePath);
    if (readCsvChannel is ReadableCSVChannel) {
        int i = 0;
        foreach string[] entry in data {
            test:assertTrue(readCsvChannel.hasNext());
            var recordResult = readCsvChannel.getNext();
            if (recordResult is string[]) {
                test:assertEquals(recordResult.length(), expectedRecordLength);
                test:assertEquals(recordResult[0], data[i][0]);
                test:assertEquals(recordResult[1], data[i][1]);
                test:assertEquals(recordResult[2], data[i][2]);
            } else if (recordResult is Error) {
                test:assertFail(msg = recordResult.message());
            } else {
                test:assertFail(msg = "Unexpected result");
            }
            i += 1;
        }
        var closeResult = readCsvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = readCsvChannel.message());
    }
}

@test:Config {}
isolated function testWriteTdf() {
    string filePath = TEMP_DIR + "recordsTdf.csv";
    string[] content = ["Name", "Email", "Telephone"];

    var csvChannel = openWritableCsvFile(filePath, TAB);
    if (csvChannel is WritableCSVChannel) {
        var result = csvChannel.write(content);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }
        var closeResult = csvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = csvChannel.message());
    }
}

@test:Config {}
isolated function testTableContent() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample5.csv";
    float expectedValue = 60001.00;
    float total = 0.0;

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath);
    table<record {}> tableResult = check csvChannel.getTable(Employee);
    table<Employee> tb = <table<Employee>>tableResult;
    foreach Employee x in tb {
        total = total + x.salary;
    }
    test:assertEquals(total, expectedValue);
    _ = check csvChannel.close();
}

@test:Config {}
isolated function testTableContent2() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample5.csv";
    float expectedValue = 60001.00;
    float total = 0.0;

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath);
    table<record {}> tableResult = check csvChannel.toTable(Employee, ["id"]);
    table<Employee> tb = <table<Employee>>tableResult;
    foreach Employee x in tb {
        total = total + x.salary;
    }
    test:assertEquals(total, expectedValue);
    _ = check csvChannel.close();
}

@test:Config {}
isolated function testTableWithNull() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample6.csv";
    string name = "";
    string dep = "";

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath, skipHeaders = 1);
    table <record {}> tblResult = check csvChannel.getTable(PerDiem);
    table<PerDiem> tb = <table<PerDiem>>tblResult;
    foreach PerDiem rec in tb {
        name = name + rec.name;
        dep = dep + (rec.department ?: "-1");
    }
    test:assertEquals(name, "Person1Person2Person3", msg = "Found unexpected output");
    test:assertEquals(dep, "EngMrk-1", msg = "Found unexpected output");
    _ = check csvChannel.close();
}

@test:Config {}
isolated function testTableWithNull2() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample6.csv";
    string name = "";
    string dep = "";

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath, skipHeaders = 1);
    table <record {}> tblResult = check csvChannel.toTable(PerDiem, ["id"]);
    table<PerDiem> tb = <table<PerDiem>>tblResult;
    foreach PerDiem rec in tb {
        name = name + rec.name;
        dep = dep + (rec.department ?: "-1");
    }
    test:assertEquals(name, "Person1Person2Person3", msg = "Found unexpected output");
    test:assertEquals(dep, "EngMrk-1", msg = "Found unexpected output");
    _ = check csvChannel.close();
}

@test:Config {}
isolated function testTableWithHeader() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample7.csv";
    string[] expectedOutput = ["Common App ID", "11111111", "22222222", "33333333", "44444444", "55555555", "55555556"];
    string[] keys = [];

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath);
    table<record {}> tblResult = check csvChannel.getTable(CommonApp);
    table<CommonApp> tb = <table<CommonApp>>tblResult;
    foreach CommonApp rec in tb {
        keys.push(rec.appId);
    }

    int i = 0;
    foreach string s in expectedOutput {
        test:assertEquals(keys[i], s, msg = "Found unexpected output");
        i += 1;
    }

    _ = check csvChannel.close();
}

@test:Config {}
isolated function testTableWithHeader2() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample7.csv";
    string[] expectedOutput = ["Common App ID", "11111111", "22222222", "33333333", "44444444", "55555555", "55555556"];
    string[] keys = [];

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath);
    table<record {}> tblResult = check csvChannel.toTable(CommonApp, ["appId"]);
    table<CommonApp> tb = <table<CommonApp>>tblResult;
    foreach CommonApp rec in tb {
        keys.push(rec.appId);
    }

    int i = 0;
    foreach string s in expectedOutput {
        test:assertEquals(keys[i], s, msg = "Found unexpected output");
        i += 1;
    }

    _ = check csvChannel.close();
}

@test:Config {}
isolated function testTableMultipleKeyFields() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample8.csv";
    float expectedValue = 120002.00;
    float total = 0.0;

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath);
    table <record {}> tableResult = check csvChannel.toTable(Employee2, ["emp_type", "emp_no"]);
    table<Employee2> tb = <table<Employee2>>tableResult;
    foreach Employee2 x in tb {
        total = total + x.salary;
    }
    test:assertEquals(total, expectedValue);
    _ = check csvChannel.close();
}

@test:Config {}
isolated function testTableNegative() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample8.csv";
    float expectedValue = 120002.00;
    float total = 0.0;

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath);
    table<record {}>|error tableResult = csvChannel.toTable(Employee2, ["emp_no"]);
    if (tableResult is error) {
        test:assertEquals(tableResult.message(), "failed to process the delimited file: {ballerina/lang.table}KeyConstraintViolation");
        var closeResult = csvChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail("Error expected.");
    }
}

@test:Config {}
isolated function testFileCsvWrite() {
    string[][] content = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], ["John Thomson", 
    "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", "30 years", 
    "Colombo"]];
    string filePath = TEMP_DIR + "workers1.csv";
    var result = fileWriteCsv(filePath, content);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileCsvWrite]}
isolated function testFileCsvRead() {
    string[][] expectedContent = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], [
    "John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", 
    "30 years", "Colombo"]];
    string filePath = TEMP_DIR + "workers1.csv";
    var result = fileReadCsv(filePath);
    if (result is string[][]) {
        int i = 0;
        foreach string[] r in result {
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
isolated function testFileCsvWriteWithSkipHeaders() {
    string[][] content = [["Name", "Occupation", "Company", "Age", "Hometown"], ["Ross Meton", "Civil Engineer", 
    "ABC Construction", "26 years", "Sydney"], ["Matt Jason", "Architect", "Typer", "38 years", "Colombo"]];
    string filePath = TEMP_DIR + "workers2.csv";
    var result = fileWriteCsv(filePath, content);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileCsvWriteWithSkipHeaders]}
isolated function testFileCsvReadWithSkipHeaders() {
    string[][] expectedContent = [["Ross Meton", "Civil Engineer",
    "ABC Construction", "26 years", "Sydney"], ["Matt Jason", "Architect", "Typer", "38 years", "Colombo"]];
    string filePath = TEMP_DIR + "workers2.csv";
    var result = fileReadCsv(filePath, 1);
    if (result is string[][]) {
        int i = 0;
        foreach string[] r in result {
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
isolated function testFileWriteCsvFromStreamUsingResourceFile() returns Error? {
    string filePath = TEMP_DIR + "workers4_A.csv";
    string resourceFilePath = TEST_RESOURCE_PATH + "csvResourceFile1.csv";
    stream<string[], Error?> csvStream = check fileReadCsvAsStream(resourceFilePath);
    var result = fileWriteCsvFromStream(filePath, csvStream);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileWriteCsvFromStreamUsingResourceFile]}
function testFileReadCsvAsStreamUsingResourceFile() {
    string filePath = TEMP_DIR + "workers4_A.csv";
    string[][] expectedContent = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], [
    "John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", 
    "30 years", "Colombo"]];
    var result = fileReadCsvAsStream(filePath);
    if (result is stream<string[], Error?>) {
        int i = 0;
        error? e = result.forEach(function(string[] val) {
                               int j = 0;
                               foreach string s in val {
                                   test:assertEquals('string:trim(s), expectedContent[i][j]);
                                   j += 1;
                               }
                               i += 1;
                           });
        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 3);
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
function testFileWriteCsvFromStream() {
    string filePath = TEMP_DIR + "workers4_B.csv";
    string[][] content = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], ["John Thomson",
    "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", "30 years",
    "Colombo"]];
    var result = fileWriteCsvFromStream(filePath, content.toStream());
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileWriteCsvFromStream]}
function testFileReadCsvAsStream() {
    string filePath = TEMP_DIR + "workers4_B.csv";
    string[][] expectedContent = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], [
    "John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank",
    "30 years", "Colombo"]];
    var result = fileReadCsvAsStream(filePath);
    if (result is stream<string[], Error?>) {
        int i = 0;
        error? e = result.forEach(function(string[] val) {
                               int j = 0;
                               foreach string s in val {
                                   test:assertEquals(s, expectedContent[i][j]);
                                   j += 1;
                               }
                               i += 1;
                           });
        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 3);
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
isolated function testFileCsvWriteWithOverwrite() {
    string filePath = TEMP_DIR + "workers2.csv";
    string[][] content1 = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], ["John Thomson",
    "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", "30 years",
    "Colombo"]];
    string[][] content2 = [["Distributed Computing", "A001", "Prof. Jack"], ["Quantum Computing", "A002", "Dr. Sam"],
    ["Artificial Intelligence", "A003", "Prof. Angelina"]];

    // Check content 01
    var result1 = fileWriteCsv(filePath, content1);
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadCsv(filePath);
    if (result2 is string[][]) {
        int i = 0;
        foreach string[] r in content1 {
            int j = 0;
            foreach string s in r {
                test:assertEquals(s, content1[i][j]);
                j += 1;
            }
            i += 1;
        }
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 02
    var result3 = fileWriteCsv(filePath, content2);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadCsv(filePath);
    if (result4 is string[][]) {
        int i = 0;
        foreach string[] r in result4 {
            int j = 0;
            foreach string s in r {
                test:assertEquals(s, content2[i][j]);
                j += 1;
            }
            i += 1;
        }
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
isolated function testFileCsvWriteWithAppend() {
    string filePath = TEMP_DIR + "workers3.csv";
    string[][] content1 = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], ["John Thomson",
    "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", "30 years",
    "Colombo"]];
    string[][] content2 = [["Distributed Computing", "A001", "Prof. Jack"], ["Quantum Computing", "A002", "Dr. Sam"],
    ["Artificial Intelligence", "A003", "Prof. Angelina"]];
    string[][] expectedCsv = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
    ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
    ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"],
    ["Distributed Computing", "A001", "Prof. Jack"], ["Quantum Computing", "A002", "Dr. Sam"],
    ["Artificial Intelligence", "A003", "Prof. Angelina"]];

    // Check content 01
    var result1 = fileWriteCsv(filePath, content1);
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadCsv(filePath);
    if (result2 is string[][]) {
        int i = 0;
        foreach string[] r in result2 {
            int j = 0;
            foreach string s in r {
                test:assertEquals(s, content1[i][j]);
                j += 1;
            }
            i += 1;
        }
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 01 + 02
    var result3 = fileWriteCsv(filePath, content2, APPEND);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadCsv(filePath);
    if (result4 is string[][]) {
        int i = 0;
        foreach string[] r in result4 {
            int j = 0;
            foreach string s in r {
                test:assertEquals(s, expectedCsv[i][j]);
                j += 1;
            }
            i += 1;
        }
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
function testFileCsvWriteFromStreamWithOverwriteUsingResourceFile() returns Error? {
    string filePath = TEMP_DIR + "workers5.csv";
    string resourceFilePath1 = TEST_RESOURCE_PATH + "csvResourceFile1.csv";
    string resourceFilePath2 = TEST_RESOURCE_PATH + "csvResourceFile2.csv";
    stream<string[], Error?> csvStream1 = check fileReadCsvAsStream(resourceFilePath1);
    stream<string[], Error?> csvStream2 = check fileReadCsvAsStream(resourceFilePath2);
    string[][] content1 = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], ["John Thomson",
    "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", "30 years",
    "Colombo"]];
    string[][] content2 = [["Distributed Computing", "A001", "Prof. Jack"], ["Quantum Computing", "A002", "Dr. Sam"],
    ["Artificial Intelligence", "A003", "Prof. Angelina"]];

    // Check content 01
    var result1 = fileWriteCsvFromStream(filePath, csvStream1);
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadCsvAsStream(filePath);
    if (result2 is stream<string[], Error?>) {
        int i = 0;
        error? e = result2.forEach(function(string[] val) {
                               int j = 0;
                               foreach string s in val {
                                   test:assertEquals('string:trim(s), content1[i][j]);
                                   j += 1;
                               }
                               i += 1;
                           });
        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 3);
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 02
    var result3 = fileWriteCsvFromStream(filePath, csvStream2);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadCsvAsStream(filePath);
    if (result4 is stream<string[], Error?>) {
        int i = 0;
        error? e = result4.forEach(function(string[] val) {
                               int j = 0;
                               foreach string s in val {
                                   test:assertEquals('string:trim(s), content2[i][j]);
                                   j += 1;
                               }
                               i += 1;
                           });
        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 3);
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
function testFileCsvWriteFromStreamWithAppendUsingResourceFile() returns Error? {
    string filePath = TEMP_DIR + "workers6.csv";
    string resourceFilePath1 = TEST_RESOURCE_PATH + "csvResourceFile1.csv";
    string resourceFilePath2 = TEST_RESOURCE_PATH + "csvResourceFile2.csv";
    stream<string[], Error?> csvStream1 = check fileReadCsvAsStream(resourceFilePath1);
    stream<string[], Error?> csvStream2 = check fileReadCsvAsStream(resourceFilePath2);
    string[][] initialContent = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], ["John Thomson",
    "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", "30 years",
    "Colombo"]];
    string[][] expectedCsv = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
    ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
    ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"],
    ["Distributed Computing", "A001", "Prof. Jack"], ["Quantum Computing", "A002", "Dr. Sam"],
    ["Artificial Intelligence", "A003", "Prof. Angelina"]];

    // Check content 01
    var result1 = fileWriteCsvFromStream(filePath, csvStream1);
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadCsvAsStream(filePath);
    if (result2 is stream<string[], Error?>) {
        int i = 0;
        error? e = result2.forEach(function(string[] val) {
                               int j = 0;
                               foreach string s in val {
                                   test:assertEquals('string:trim(s), initialContent[i][j]);
                                   j += 1;
                               }
                               i += 1;
                           });
        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 3);
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 02
    var result3 = fileWriteCsvFromStream(filePath, csvStream2, APPEND);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadCsvAsStream(filePath);
    if (result4 is stream<string[], Error?>) {
        int i = 0;
        error? e = result4.forEach(function(string[] val) {
                               int j = 0;
                               foreach string s in val {
                                   test:assertEquals('string:trim(s), expectedCsv[i][j]);
                                   j += 1;
                               }
                               i += 1;
                           });
        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 6);
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
function testFileCsvWriteFromStreamWithOverwrite() returns Error? {
    string filePath = TEMP_DIR + "workers7.csv";
    string[][] content1 = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], ["John Thomson",
    "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", "30 years",
    "Colombo"]];
    string[][] content2 = [["Distributed Computing", "A001", "Prof. Jack"], ["Quantum Computing", "A002", "Dr. Sam"],
    ["Artificial Intelligence", "A003", "Prof. Angelina"]];

    // Check content 01
    var result1 = fileWriteCsvFromStream(filePath, content1.toStream());
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadCsvAsStream(filePath);
    if (result2 is stream<string[], Error?>) {
        int i = 0;
        error? e = result2.forEach(function(string[] val) {
                               int j = 0;
                               foreach string s in val {
                                   test:assertEquals(s, content1[i][j]);
                                   j += 1;
                               }
                               i += 1;
                           });
        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 3);
        check result2.close();
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 02
    var result3 = fileWriteCsvFromStream(filePath, content2.toStream());
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadCsvAsStream(filePath);
    if (result4 is stream<string[], Error?>) {
        int i = 0;
        error? e = result4.forEach(function(string[] val) {
                               int j = 0;
                               foreach string s in val {
                                   test:assertEquals(s, content2[i][j]);
                                   j += 1;
                               }
                               i += 1;
                           });
        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 3);
        check result4.close();
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
function testFileCsvWriteFromStreamWithAppend() {
    string filePath = TEMP_DIR + "workers8.csv";
    string[][] content1 = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"], ["John Thomson",
    "Software Architect", "WSO2", "38 years", "Colombo"], ["Mary Thompson", "Banker", "Sampath Bank", "30 years",
    "Colombo"]];
    string[][] content2 = [["Distributed Computing", "A001", "Prof. Jack"], ["Quantum Computing", "A002", "Dr. Sam"],
    ["Artificial Intelligence", "A003", "Prof. Angelina"]];
    string[][] expectedCsv = [["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
    ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
    ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"],
    ["Distributed Computing", "A001", "Prof. Jack"], ["Quantum Computing", "A002", "Dr. Sam"],
    ["Artificial Intelligence", "A003", "Prof. Angelina"]];

    // Check content 01
    var result1 = fileWriteCsvFromStream(filePath, content1.toStream());
    if (result1 is Error) {
        test:assertFail(msg = result1.message());
    }
    var result2 = fileReadCsvAsStream(filePath);
    if (result2 is stream<string[], Error?>) {
        int i = 0;
        error? e = result2.forEach(function(string[] val) {
                               int j = 0;
                               foreach string s in val {
                                   test:assertEquals(s, content1[i][j]);
                                   j += 1;
                               }
                               i += 1;
                           });
        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 3);
    } else {
        test:assertFail(msg = result2.message());
    }

    // Check content 02
    var result3 = fileWriteCsvFromStream(filePath, content2.toStream(), APPEND);
    if (result3 is Error) {
        test:assertFail(msg = result3.message());
    }
    var result4 = fileReadCsvAsStream(filePath);
    if (result4 is stream<string[], Error?>) {
        int i = 0;
        error? e = result4.forEach(function(string[] val) {
                               int j = 0;
                               foreach string s in val {
                                   test:assertEquals(s, expectedCsv[i][j]);
                                   j += 1;
                               }
                               i += 1;
                           });
        if (e is error) {
            test:assertFail(msg = e.message());
        }
        test:assertEquals(i, 6);
    } else {
        test:assertFail(msg = result4.message());
    }
}

@test:Config {}
isolated function testGetReadableCSVChannel() returns error? {
    string filePath = TEST_RESOURCE_PATH + "csvResourceFileForUtils.csv";
    ReadableByteChannel readableByteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel readableCharacterChannel = new(readableByteChannel, DEFAULT_ENCODING);
    ReadableCSVChannel readableCsvChannel = new(readableCharacterChannel);

    var readableCsvChannel1 = getReadableCSVChannel(readableByteChannel, 0);
    if !(readableCsvChannel1 is ReadableCSVChannel) {
        test:assertFail(msg = "Expected ReadableCSVChannel not found");
    }
    var readableCsvChannel2 = getReadableCSVChannel(readableCharacterChannel, 0);
    if !(readableCsvChannel2 is ReadableCSVChannel) {
        test:assertFail(msg = "Expected ReadableCSVChannel not found");
    }
    var readableCsvChannel3 = getReadableCSVChannel(readableCsvChannel, 0);
    if !(readableCsvChannel3 is ReadableCSVChannel) {
        test:assertFail(msg = "Expected ReadableCSVChannel not found");
    }
}

@test:Config {}
isolated function testGetWritableCSVChannel() returns error? {
    string filePath = TEST_RESOURCE_PATH + "csvResourceFileForUtils.csv";
    WritableByteChannel writableByteChannel = check openWritableFile(filePath);
    WritableCharacterChannel writableCharacterChannel = new(writableByteChannel, DEFAULT_ENCODING);
    WritableCSVChannel writableCsvChannel = new(writableCharacterChannel);

    var writableCsvChannel1 = getWritableCSVChannel(writableByteChannel);
    if !(writableCsvChannel1 is WritableCSVChannel) {
        test:assertFail(msg = "Expected WritableCSVChannel not found");
    }
    var writableCsvChannel2 = getWritableCSVChannel(writableCharacterChannel);
    if !(writableCsvChannel2 is WritableCSVChannel) {
        test:assertFail(msg = "Expected WritableCSVChannel not found");
    }
    var writableCsvChannel3 = getWritableCSVChannel(writableCsvChannel);
    if !(writableCsvChannel3 is WritableCSVChannel) {
        test:assertFail(msg = "Expected WritableCSVChannel not found");
    }
}

