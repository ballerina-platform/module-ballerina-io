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

function nextRecord() returns @tainted string[] | error {
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

function getTable(string filePath, string encoding, Separator fieldSeparator) returns @tainted float | error {
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

function getTableWithNill(string filePath) returns @tainted [string, string] | error {
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

function getTableWithHeader(string filePath) returns @tainted string[] | error {
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
