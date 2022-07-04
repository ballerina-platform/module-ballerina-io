# Proposal: Support Data Mapping in CSV read/write operations

_Owners_: @daneshk @sahanhe  
_Reviewers_: @daneshk  
_Created_: 2022/07/04   
_Updated_: -  
_Issues_: [#3004](https://github.com/ballerina-platform/ballerina-standard-library/issues/3004#event-6837345074)

## Summary

Current CSV read/write APIs supports reading and writing as string[][] values. In this proposal we propose to add data mapping to return an array of particular record defined by the user.

## Goals

* Add data mapping feature to CSV READ/Write operations to return an array of particular record defined by the user.

* Change ```fileReadCsv, fileWriteCsv, fileReadCsvAsStream, fileWriteCsvFromStream``` to support data mapping.

* Carry out the data mapping by inferring the return type automatically as a dependently-typed function.

## Motivation

Until now, user doesn't have a direct data mapping method to get an array of user defined records from CSVs.

## Description

```fileReadCsv(), fileWriteCsv(), fileReadCsvAsStream(), fileWriteCsvFromStream()```  APIs are modified to support data mapping in CSV read/write operations. Existing Currently ```fileReadCsv()``` API returns String[][] and modified API can return either String[][] or record[] depending on the return type. Similarly ```fileWriteCsv()``` currently accepts String[][] inputs and modified API can accept both String[][] and record[].

For stream type APIs, ```fileReadCsvAsStream()``` currently returns ```stream<string[], Error?>|Error``` and modified API will return ```stream<string[]|record{}, Error?>|Error```.  Similarly, ```fileWriteCsvFromStream()``` accepts ```stream<string[], Error?>```  as the input and it will be modified to ```stream<string[]|record{}, Error?>```.

modified APIs
```ballerina
# Read file content as a CSV.
# + path - The CSV file path
# + skipHeaders - Number of headers, which should be skipped prior to reading records
# + returnType - The type of the return value (string[] or record{})
# + return - The entire CSV content in the channel as an array of string arrays, an array of records or an `io:Error`

public isolated function fileReadCsv(string path, int skipHeaders = 0, typedesc<record{}|string[]> returnType = <>) returns returnType[]|Error = @java:Method ;
```

``` ballerina
# Write CSV content to a file.
# + path - The CSV file path
# + content - CSV content as an array of string arrays or an array of records
# + option - To indicate whether to overwrite or append the given content
# + return - `()` when the writing was successful or an `io:Error`

public isolated function fileWriteCsv(string path, string[][]|map<anydata>[] content, FileWriteOption option = OVERWRITE) returns Error? ;
```

```ballerina
# Read file content as a CSV.
# + path - The CSV file path
# + returnType - The type of the return value (string[] or map<anydata>)
# + return - The entire CSV content in the channel a stream of string arrays, an stream of records or an `io:Error`
public isolated function fileReadCsvAsStream(string path, typedesc<string[]|record{}>  returnType = <>) returns  stream<returnType, Error?>|Error ;
```

```ballerina
# Write CSV record stream to a file.
# + path - The CSV file path
# + content - A CSV record stream to be written
# + option - To indicate whether to overwrite or append the given content
# + return - `()` when the writing was successful or an `io:Error`
public isolated function fileWriteCsvFromStream(string path, stream<string[]|map<anydata>, Error?> content, FileWriteOption option = OVERWRITE) returns Error? ;
```

Example of a data mapping in to array of records.

CSV file
```
id, name, salary
User1, WSO2, 10000.50
User2, WSO2, 20000.50
User3, WSO2, 30000.00
```

Code

```ballerina
type Employee record {
    string id;
    string name;
    float salary;
};


@test:Config {}
isolated function testCsvContent() returns error? {
    float expectedValue = 60001.00;
    float total = 0;

    Employee[] result = check fileReadCSV(filePath);
    foreach Employee x in result {
        total = total + x.salary;
    }
    test:assertEquals(total, expectedValue);
    check fileWriteCsv(filePath, result);
}


@test:Config {}
isolated function testCsvStreamContent() returns error? {
    float expectedValue = 60001.00;
    float total = 0;
    stream<Employee{}, io:Error?> csvStream = check io:fileReadCsvAsStream(filePath);
    check csvStream.forEach(function(Employee{} x) {
                              total = total + x.salary;
                          });
    test:assertEquals(total, expectedValue);
    check fileWriteCsv(filePath, result);
}
```


## Risks and Assumptions

1. Headers of the record is provided in the first row of CSV, and they are equal to the headers in record type, otherwise data gets mapped in the order of fields in the record..
2. Number of fields in defined record and the number of headers in the CSV file are equal.
