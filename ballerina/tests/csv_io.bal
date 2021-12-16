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
isolated function testReadCsv() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";
    int expectedRecordLength = 3;

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    ReadableCSVChannel csvChannel = new ReadableCSVChannel(characterChannel, COMMA);

    test:assertTrue(csvChannel.hasNext());
    string[]? recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertFalse(csvChannel.hasNext());
    string[]|Error? endResult = csvChannel.getNext();
    test:assertTrue(endResult is Error);
    test:assertEquals((<Error>endResult).message(), "EoF when reading from the channel");

    check csvChannel.close();
}

@test:Config {}
isolated function testOpenAndReadCsv() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample.csv";
    int expectedRecordLength = 3;

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath);
    test:assertTrue(csvChannel.hasNext());
    string[]? recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertFalse(csvChannel.hasNext());
    string[]|Error? endResult = csvChannel.getNext();
    test:assertTrue(endResult is Error);
    test:assertEquals((<Error>endResult).message(), "EoF when reading from the channel");

    check csvChannel.close();
}

@test:Config {}
isolated function testOpenAndReadColonDelimitedFile() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleWithColon.txt";
    int expectedRecordLength = 3;

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    ReadableCSVChannel csvChannel = new ReadableCSVChannel(characterChannel, COLON);

    test:assertTrue(csvChannel.hasNext());
    string[]? recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertFalse(csvChannel.hasNext());
    string[]|Error? endResult = csvChannel.getNext();
    test:assertTrue(endResult is Error);
    test:assertEquals((<Error>endResult).message(), "EoF when reading from the channel");

    check csvChannel.close();
}

@test:Config {dependsOn: [testOpenAndReadColonDelimitedFile]}
isolated function testOpenAndReadCsvWithHeaders() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleWithHeader.csv";
    int expectedRecordLength = 3;

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath, COMMA, DEFAULT_ENCODING, 1);
    test:assertTrue(csvChannel.hasNext());
    string[]? recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    check csvChannel.close();
}

@test:Config {}
isolated function testReadRfc() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleRfc.csv";
    int expectedRecordLength = 3;

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath);
    test:assertTrue(csvChannel.hasNext());
    string[]? recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);
    test:assertEquals((<string[]>recordResult)[0], "User1,12");
    test:assertEquals((<string[]>recordResult)[1], "WSO2");
    test:assertEquals((<string[]>recordResult)[2], "07xxxxxx");

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    check csvChannel.close();
}

@test:Config {}
isolated function testReadTdf() returns Error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sampleTdf.tsv";
    int expectedRecordLength = 3;

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath, TAB);
    test:assertTrue(csvChannel.hasNext());
    string[]? recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertTrue(csvChannel.hasNext());
    recordResult = check csvChannel.getNext();
    test:assertTrue(recordResult is string[]);
    test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);

    test:assertFalse(csvChannel.hasNext());
    string[]|Error? endResult = csvChannel.getNext();
    test:assertTrue(endResult is Error);
    test:assertEquals((<Error>endResult).message(), "EoF when reading from the channel");

    check csvChannel.close();
}

@test:Config {}
isolated function testWriteDefaultCsv() returns Error? {
    string filePath = TEMP_DIR + "recordsDefault.csv";
    string[] content1 = ["Name", "Email", "Telephone"];
    string[] content2 = ["Foo,12", "foo@ballerina/io", "332424242"];
    int expectedRecordLength = 3;

    WritableCSVChannel writeCsvChannel = check openWritableCsvFile(filePath);
    check writeCsvChannel.write(content1);
    check writeCsvChannel.write(content2);

    ReadableCSVChannel readCsvChannel = check openReadableCsvFile(filePath);
    test:assertTrue(readCsvChannel.hasNext());
    string[]? recordResult1 = check readCsvChannel.getNext();
    test:assertTrue(recordResult1 is string[]);
    test:assertEquals((<string[]>recordResult1).length(), expectedRecordLength);
    test:assertEquals((<string[]>recordResult1)[0], content1[0]);
    test:assertEquals((<string[]>recordResult1)[1], content1[1]);
    test:assertEquals((<string[]>recordResult1)[2], content1[2]);

    test:assertTrue(readCsvChannel.hasNext());
    string[]? recordResult2 = check readCsvChannel.getNext();
    test:assertTrue(recordResult2 is string[]);
    test:assertEquals((<string[]>recordResult2).length(), expectedRecordLength);
    test:assertEquals((<string[]>recordResult2)[0], content2[0]);
    test:assertEquals((<string[]>recordResult2)[1], content2[1]);
    test:assertEquals((<string[]>recordResult2)[2], content2[2]);

    test:assertFalse(readCsvChannel.hasNext());
    string[]|Error? endResult = readCsvChannel.getNext();
    test:assertTrue(endResult is Error);
    test:assertEquals((<Error>endResult).message(), "EoF when reading from the channel");

    check readCsvChannel.close();
}

@test:Config {}
isolated function testReadWriteCustomSeparator() returns Error? {
    string filePath = TEMP_DIR + "recordsUserDefine.csv";
    string[][] data = [
        ["1", "James", "10000"],
        ["2", "Nathan", "150000"],
        ["3", "Ronald", "120000"],
        [
            "4",
            "Roy",
            "6000"
        ],
        ["5", "Oliver", "1100000"]
    ];
    int expectedRecordLength = 3;

    WritableCSVChannel writeCsvChannel = check openWritableCsvFile(filePath);
    foreach string[] entry in data {
        check writeCsvChannel.write(entry);
    }
    check writeCsvChannel.close();

    ReadableCSVChannel readCsvChannel = check openReadableCsvFile(filePath);
    foreach int i in 0 ..< data.length() {
        test:assertTrue(readCsvChannel.hasNext());
        string[]? recordResult = check readCsvChannel.getNext();
        test:assertTrue(recordResult is string[]);
        test:assertEquals((<string[]>recordResult).length(), expectedRecordLength);
        test:assertEquals((<string[]>recordResult)[0], data[i][0]);
        test:assertEquals((<string[]>recordResult)[1], data[i][1]);
        test:assertEquals((<string[]>recordResult)[2], data[i][2]);

    }
    check readCsvChannel.close();
}

@test:Config {}
isolated function testWriteTdf() returns Error? {
    string filePath = TEMP_DIR + "recordsTdf.csv";
    string[] content = ["Name", "Email", "Telephone"];

    WritableCSVChannel csvChannel = check openWritableCsvFile(filePath, TAB);
    check csvChannel.write(content);
    check csvChannel.close();
}

@test:Config {}
isolated function testTableContent() returns Error? {
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
    check csvChannel.close();
}

@test:Config {}
isolated function testTableWithNull() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample6.csv";
    string name = "";
    string dep = "";

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath, skipHeaders = 1);
    table<record {}> tblResult = check csvChannel.getTable(PerDiem);
    table<PerDiem> tb = <table<PerDiem>>tblResult;
    foreach PerDiem rec in tb {
        name = name + rec.name;
        dep = dep + (rec.department ?: "-1");
    }
    test:assertEquals(name, "Person1Person2Person3");
    test:assertEquals(dep, "EngMrk-1");
    check csvChannel.close();
}

@test:Config {}
isolated function testTableWithNull2() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample6.csv";
    string name = "";
    string dep = "";

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath, skipHeaders = 1);
    table<record {}> tblResult = check csvChannel.toTable(PerDiem, ["id"]);
    table<PerDiem> tb = <table<PerDiem>>tblResult;
    foreach PerDiem rec in tb {
        name = name + rec.name;
        dep = dep + (rec.department ?: "-1");
    }
    test:assertEquals(name, "Person1Person2Person3");
    test:assertEquals(dep, "EngMrk-1");
    check csvChannel.close();
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
        test:assertEquals(keys[i], s);
        i += 1;
    }
    check csvChannel.close();
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
        test:assertEquals(keys[i], s);
        i += 1;
    }
    check csvChannel.close();
}

@test:Config {}
isolated function testTableMultipleKeyFields() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample8.csv";
    float expectedValue = 120002.00;
    float total = 0.0;

    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath);
    table<record {}> tableResult = check csvChannel.toTable(Employee2, ["emp_type", "emp_no"]);
    table<Employee2> tb = <table<Employee2>>tableResult;
    foreach Employee2 x in tb {
        total = total + x.salary;
    }
    test:assertEquals(total, expectedValue);
    check csvChannel.close();
}

@test:Config {}
isolated function testTableNegative() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample8.csv";
    ReadableCSVChannel csvChannel = check openReadableCsvFile(filePath);
    table<record {}>|error tableResult = csvChannel.toTable(Employee2, ["emp_no"]);
    test:assertTrue(tableResult is error);
    test:assertEquals((<error>tableResult).message(), "failed to process the delimited file: {ballerina/lang.table}KeyConstraintViolation");
    check csvChannel.close();
}

@test:Config {}
isolated function testFileCsvWrite() returns Error? {
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
    string filePath = TEMP_DIR + "workers1.csv";
    check fileWriteCsv(filePath, content);
}

@test:Config {dependsOn: [testFileCsvWrite]}
isolated function testFileCsvRead() returns Error? {
    string[][] expectedContent = [
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
    string filePath = TEMP_DIR + "workers1.csv";
    string[][] result = check fileReadCsv(filePath);
    int i = 0;
    foreach string[] r in result {
        int j = 0;
        foreach string s in r {
            test:assertEquals(s, expectedContent[i][j]);
            j += 1;
        }
        i += 1;
    }
}

@test:Config {}
isolated function testFileCsvWriteWithSkipHeaders() returns Error? {
    string[][] content = [
        ["Name", "Occupation", "Company", "Age", "Hometown"],
        [
            "Ross Meton",
            "Civil Engineer",
            "ABC Construction",
            "26 years",
            "Sydney"
        ],
        ["Matt Jason", "Architect", "Typer", "38 years", "Colombo"]
    ];
    string filePath = TEMP_DIR + "workers2.csv";
    check fileWriteCsv(filePath, content);
}

@test:Config {dependsOn: [testFileCsvWriteWithSkipHeaders]}
isolated function testFileCsvReadWithSkipHeaders() returns Error? {
    string[][] expectedContent = [
        [
            "Ross Meton",
            "Civil Engineer",
            "ABC Construction",
            "26 years",
            "Sydney"
        ],
        ["Matt Jason", "Architect", "Typer", "38 years", "Colombo"]
    ];
    string filePath = TEMP_DIR + "workers2.csv";
    string[][] result = check fileReadCsv(filePath, 1);
    int i = 0;
    foreach string[] r in result {
        int j = 0;
        foreach string s in r {
            test:assertEquals(s, expectedContent[i][j]);
            j += 1;
        }
        i += 1;
    }
}

@test:Config {}
isolated function testFileWriteCsvFromStreamUsingResourceFile() returns Error? {
    string filePath = TEMP_DIR + "workers4_A.csv";
    string resourceFilePath = TEST_RESOURCE_PATH + "csvResourceFile1.csv";
    stream<string[], Error?> csvStream = check fileReadCsvAsStream(resourceFilePath);
    check fileWriteCsvFromStream(filePath, csvStream);
}

@test:Config {dependsOn: [testFileWriteCsvFromStreamUsingResourceFile]}
function testFileReadCsvAsStreamUsingResourceFile() returns error? {
    string filePath = TEMP_DIR + "workers4_A.csv";
    string[][] expectedContent = [
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
    stream<string[], Error?> result = check fileReadCsvAsStream(filePath);
    int i = 0;
    check result.forEach(function(string[] val) {
        int j = 0;
        foreach string s in val {
            test:assertEquals('string:trim(s), expectedContent[i][j]);
            j += 1;
        }
        i += 1;
    });
    test:assertEquals(i, 3);
}

@test:Config {}
function testFileWriteCsvFromStream() returns Error? {
    string filePath = TEMP_DIR + "workers4_B.csv";
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
}

@test:Config {dependsOn: [testFileWriteCsvFromStream]}
function testFileReadCsvAsStream() returns Error? {
    string filePath = TEMP_DIR + "workers4_B.csv";
    string[][] expectedContent = [
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
    stream<string[], Error?> result = check fileReadCsvAsStream(filePath);
    int i = 0;
    check result.forEach(function(string[] val) {
        int j = 0;
        foreach string s in val {
            test:assertEquals(s, expectedContent[i][j]);
            j += 1;
        }
        i += 1;
    });
    test:assertEquals(i, 3);
}

@test:Config {}
isolated function testFileCsvWriteWithOverwrite() returns Error? {
    string filePath = TEMP_DIR + "workers2.csv";
    string[][] content1 = [
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
    string[][] content2 = [
        ["Distributed Computing", "A001", "Prof. Jack"],
        ["Quantum Computing", "A002", "Dr. Sam"],
        ["Artificial Intelligence", "A003", "Prof. Angelina"]
    ];

    // Check content 01
    check fileWriteCsv(filePath, content1);

    string[][] result1 = check fileReadCsv(filePath);
    int i = 0;
    foreach string[] r in result1 {
        int j = 0;
        foreach string s in r {
            test:assertEquals(s, content1[i][j]);
            j += 1;
        }
        i += 1;
    }

    // Check content 02
    check fileWriteCsv(filePath, content2);
    string[][] result2 = check fileReadCsv(filePath);
    i = 0;
    foreach string[] r in result2 {
        int j = 0;
        foreach string s in r {
            test:assertEquals(s, content2[i][j]);
            j += 1;
        }
        i += 1;
    }
}

@test:Config {}
isolated function testFileCsvWriteWithAppend() returns Error? {
    string filePath = TEMP_DIR + "workers3.csv";
    string[][] content1 = [
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
    string[][] content2 = [
        ["Distributed Computing", "A001", "Prof. Jack"],
        ["Quantum Computing", "A002", "Dr. Sam"],
        ["Artificial Intelligence", "A003", "Prof. Angelina"]
    ];
    string[][] expectedCsv = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
        ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"],
        ["Distributed Computing", "A001", "Prof. Jack"],
        ["Quantum Computing", "A002", "Dr. Sam"],
        ["Artificial Intelligence", "A003", "Prof. Angelina"]
    ];

    // Check content 01
    check fileWriteCsv(filePath, content1);

    string[][] result1 = check fileReadCsv(filePath);
    int i = 0;
    foreach string[] r in result1 {
        int j = 0;
        foreach string s in r {
            test:assertEquals(s, content1[i][j]);
            j += 1;
        }
        i += 1;
    }

    // Check content 01 + 02
    check fileWriteCsv(filePath, content2, APPEND);
    string[][] result4 = check fileReadCsv(filePath);
    i = 0;
    foreach string[] r in result4 {
        int j = 0;
        foreach string s in r {
            test:assertEquals(s, expectedCsv[i][j]);
            j += 1;
        }
        i += 1;
    }
}

@test:Config {}
function testFileCsvWriteFromStreamWithOverwriteUsingResourceFile() returns Error? {
    string filePath = TEMP_DIR + "workers5.csv";
    string resourceFilePath1 = TEST_RESOURCE_PATH + "csvResourceFile1.csv";
    string resourceFilePath2 = TEST_RESOURCE_PATH + "csvResourceFile2.csv";
    stream<string[], Error?> csvStream1 = check fileReadCsvAsStream(resourceFilePath1);
    stream<string[], Error?> csvStream2 = check fileReadCsvAsStream(resourceFilePath2);
    string[][] content1 = [
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
    string[][] content2 = [
        ["Distributed Computing", "A001", "Prof. Jack"],
        ["Quantum Computing", "A002", "Dr. Sam"],
        ["Artificial Intelligence", "A003", "Prof. Angelina"]
    ];

    // Check content 01
    check fileWriteCsvFromStream(filePath, csvStream1);
    stream<string[], Error?> result1 = check fileReadCsvAsStream(filePath);
    int i = 0;
    check result1.forEach(function(string[] val) {
        int j = 0;
        foreach string s in val {
            test:assertEquals('string:trim(s), content1[i][j]);
            j += 1;
        }
        i += 1;
    });
    test:assertEquals(i, 3);

    // Check content 02
    check fileWriteCsvFromStream(filePath, csvStream2);
    stream<string[], Error?> result4 = check fileReadCsvAsStream(filePath);
    i = 0;
    check result4.forEach(function(string[] val) {
        int j = 0;
        foreach string s in val {
            test:assertEquals('string:trim(s), content2[i][j]);
            j += 1;
        }
        i += 1;
    });
    test:assertEquals(i, 3);
}

@test:Config {}
function testFileCsvWriteFromStreamWithAppendUsingResourceFile() returns Error? {
    string filePath = TEMP_DIR + "workers6.csv";
    string resourceFilePath1 = TEST_RESOURCE_PATH + "csvResourceFile1.csv";
    string resourceFilePath2 = TEST_RESOURCE_PATH + "csvResourceFile2.csv";
    stream<string[], Error?> csvStream1 = check fileReadCsvAsStream(resourceFilePath1);
    stream<string[], Error?> csvStream2 = check fileReadCsvAsStream(resourceFilePath2);
    string[][] initialContent = [
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
    string[][] expectedCsv = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
        ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"],
        ["Distributed Computing", "A001", "Prof. Jack"],
        ["Quantum Computing", "A002", "Dr. Sam"],
        ["Artificial Intelligence", "A003", "Prof. Angelina"]
    ];

    // Check content 01
    check fileWriteCsvFromStream(filePath, csvStream1);
    stream<string[], Error?> result1 = check fileReadCsvAsStream(filePath);
    int i = 0;
    check result1.forEach(function(string[] val) {
        int j = 0;
        foreach string s in val {
            test:assertEquals('string:trim(s), initialContent[i][j]);
            j += 1;
        }
        i += 1;
    });
    test:assertEquals(i, 3);

    // Check content 02
    check fileWriteCsvFromStream(filePath, csvStream2, APPEND);
    stream<string[], Error?> result2 = check fileReadCsvAsStream(filePath);
    i = 0;
    check result2.forEach(function(string[] val) {
        int j = 0;
        foreach string s in val {
            test:assertEquals('string:trim(s), expectedCsv[i][j]);
            j += 1;
        }
        i += 1;
    });
    test:assertEquals(i, 6);
}

@test:Config {}
function testFileCsvWriteFromStreamWithOverwrite() returns Error? {
    string filePath = TEMP_DIR + "workers7.csv";
    string[][] content1 = [
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
    string[][] content2 = [
        ["Distributed Computing", "A001", "Prof. Jack"],
        ["Quantum Computing", "A002", "Dr. Sam"],
        ["Artificial Intelligence", "A003", "Prof. Angelina"]
    ];

    // Check content 01
    check fileWriteCsvFromStream(filePath, content1.toStream());
    stream<string[], Error?> result1 = check fileReadCsvAsStream(filePath);
    int i = 0;
    check result1.forEach(function(string[] val) {
        int j = 0;
        foreach string s in val {
            test:assertEquals(s, content1[i][j]);
            j += 1;
        }
        i += 1;
    });
    test:assertEquals(i, 3);
    check result1.close();

    // Check content 02
    check fileWriteCsvFromStream(filePath, content2.toStream());
    stream<string[], Error?> result2 = check fileReadCsvAsStream(filePath);
    i = 0;
    check result2.forEach(function(string[] val) {
        int j = 0;
        foreach string s in val {
            test:assertEquals(s, content2[i][j]);
            j += 1;
        }
        i += 1;
    });
    test:assertEquals(i, 3);
    check result2.close();
}

@test:Config {}
function testFileCsvWriteFromStreamWithAppend() returns Error? {
    string filePath = TEMP_DIR + "workers8.csv";
    string[][] content1 = [
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
    string[][] content2 = [
        ["Distributed Computing", "A001", "Prof. Jack"],
        ["Quantum Computing", "A002", "Dr. Sam"],
        ["Artificial Intelligence", "A003", "Prof. Angelina"]
    ];
    string[][] expectedCsv = [
        ["Anne Hamiltom", "Software Engineer", "Microsoft", "26 years", "New York"],
        ["John Thomson", "Software Architect", "WSO2", "38 years", "Colombo"],
        ["Mary Thompson", "Banker", "Sampath Bank", "30 years", "Colombo"],
        ["Distributed Computing", "A001", "Prof. Jack"],
        ["Quantum Computing", "A002", "Dr. Sam"],
        ["Artificial Intelligence", "A003", "Prof. Angelina"]
    ];

    // Check content 01
    check fileWriteCsvFromStream(filePath, content1.toStream());
    stream<string[], Error?> result1 = check fileReadCsvAsStream(filePath);
    int i = 0;
    check result1.forEach(function(string[] val) {
        int j = 0;
        foreach string s in val {
            test:assertEquals(s, content1[i][j]);
            j += 1;
        }
        i += 1;
    });
    test:assertEquals(i, 3);

    // Check content 02
    check fileWriteCsvFromStream(filePath, content2.toStream(), APPEND);
    stream<string[], Error?> result2 = check fileReadCsvAsStream(filePath);
    i = 0;
    check result2.forEach(function(string[] val) {
        int j = 0;
        foreach string s in val {
            test:assertEquals(s, expectedCsv[i][j]);
            j += 1;
        }
        i += 1;
    });
    test:assertEquals(i, 6);
}

@test:Config {}
isolated function testGetReadableCSVChannel() returns error? {
    string filePath = TEST_RESOURCE_PATH + "csvResourceFileForUtils.csv";
    ReadableByteChannel readableByteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel readableCharacterChannel = new (readableByteChannel, DEFAULT_ENCODING);
    ReadableCSVChannel readableCsvChannel = new (readableCharacterChannel);
    ReadableTextRecordChannel readableTextRecordChannel = new (readableCharacterChannel);

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
    var readableCsvChannel4 = getReadableCSVChannel(readableTextRecordChannel, 0);
    if !(readableCsvChannel4 is Error) {
        test:assertFail(msg = "Expected error not found");
    }
}

@test:Config {}
isolated function testGetWritableCSVChannel() returns error? {
    string filePath = TEST_RESOURCE_PATH + "csvResourceFileForUtils.csv";
    WritableByteChannel writableByteChannel = check openWritableFile(filePath);
    WritableCharacterChannel writableCharacterChannel = new (writableByteChannel, DEFAULT_ENCODING);
    WritableCSVChannel writableCsvChannel = new (writableCharacterChannel);
    WritableTextRecordChannel writableTextRecordChannel = new (writableCharacterChannel);

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
    var writableCsvChannel4 = getWritableCSVChannel(writableTextRecordChannel);
    if !(writableCsvChannel4 is Error) {
        test:assertFail(msg = "Expected error not found");
    }
}

@test:Config {}
isolated function testReadCsvWithQuotedField() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample9.csv";
    string[][] expectedContent = [
        ["permanent", "one,two,three", "WSO2", "10000.50"],
        ["permanent", "four,five,six", "WSO2", "20000.50"],
        ["permanent", "seven,eight,nine", "WSO2", "30000.00"]
    ];

    string[][] content = check fileReadCsv(filePath);

    int i = 0;
    foreach string[] row in content {
        int j = 0;
        foreach string element in row {
            test:assertEquals(element, expectedContent[i][j]);
            j += 1;
        }
        i += 1;
    }
    test:assertEquals(i, 3);
}

@test:Config {}
function testReadCsvAsStreamWithQuotedField() returns error? {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/records/sample9.csv";
    string[][] expectedContent = [
        ["permanent", "one,two,three", "WSO2", "10000.50"],
        ["permanent", "four,five,six", "WSO2", "20000.50"],
        ["permanent", "seven,eight,nine", "WSO2", "30000.00"]
    ];

    stream<string[], Error?> content = check fileReadCsvAsStream(filePath);

    int i = 0;
    error? e = content.forEach(function(string[] row) {
        int j = 0;
        foreach string element in row {
            test:assertEquals(element, expectedContent[i][j]);
            j += 1;
        }
        i += 1;
    });

    if e is error {
        test:assertFail(msg = e.message());
    }
    check content.close();
    test:assertEquals(i, 3);
}
