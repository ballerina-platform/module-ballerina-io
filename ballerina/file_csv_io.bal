// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/jballerina.java;

# Reads file content as a CSV.
# When the expected data type is record[], the first entry of the csv file should contain matching headers.
# ```ballerina
# string[][]|io:Error content = io:fileReadCsv("./resources/myfile.csv");
# record{}[]|io:Error content = io:fileReadCsv("./resources/myfile.csv");
# ```
# + path - The CSV file path
# + skipHeaders - Number of headers, which should be skipped prior to reading records
# + returnType - The type of the return value (string[] or a Ballerina record)
# + return - The entire CSV content in the channel as an array of string arrays, array of Ballerina records or an `io:Error`
public isolated function fileReadCsv(string path, int skipHeaders = 0, typedesc<string[]|map<anydata>> returnType = <>) returns returnType[]|Error = @java:Method {
    name: "fileReadCsv",
    'class: "io.ballerina.stdlib.io.nativeimpl.CsvChannelUtils"
} external;

# Reads file content as a CSV.
# When the expected data type is stream<record, io:Error?>, the first entry of the csv file should contain matching headers.
# ```ballerina
# stream<string[]|io:Error content = io:fileReadCsvAsStream("./resources/myfile.csv");
# stream<record{}, io:Error?>|io:Error content = io:fileReadCsvAsStream("./resources/myfile.csv");
# ```
# + path - The CSV file path
# + returnType - The type of the return value (string[] or a Ballerina record)
# + return - The entire CSV content in the channel a stream of string arrays, Ballerina records or an `io:Error`
public isolated function fileReadCsvAsStream(string path, typedesc<string[]|map<anydata>> returnType = <>) returns stream<returnType, Error?>|Error = @java:Method {
    name: "createCsvAsStream",
    'class: "io.ballerina.stdlib.io.nativeimpl.CsvChannelUtils"
} external;

# Writes CSV content to a file.
# When the input is a record[] type in `OVERWRITE`, headers will be written to the CSV file.
# For `APPEND`, order of the existing csv file is inferred using the headers.
# ```ballerina
# type Coord record {int x;int y;};
# Coord[] contentRecord = [{x: 1,y: 2},{x: 1,y: 2}]
# string[][] content = [["Anne", "Johnson", "SE"], ["John", "Cameron", "QA"]];
# io:Error? result = io:fileWriteCsv("./resources/myfile.csv", content);
# io:Error? resultRecord = io:fileWriteCsv("./resources/myfileRecord.csv", contentRecord);
# ```
# + path - The CSV file path
# + content - CSV content as a two-dimensional string array or a Ballerina records array
# + option - Indicate whether to overwrite or append the given content
# + return - `()` when the writing was successful or an `io:Error`
public isolated function fileWriteCsv(string path, string[][]|map<anydata>[] content, FileWriteOption option = OVERWRITE) returns
Error? {
    return channelWriteCsv(path, option, content);
}

# Writes CSV record stream to a file.
# When the input is a `stream<record, io:Error?>` in `OVERWRITE`, headers will be written to the CSV file.
# For `APPEND`, order of the existing csv file is inferred using the headers.
# ```ballerina
# type Coord record {int x;int y;};
# Coord[] contentRecord = [{x: 1,y: 2},{x: 1,y: 2}]
# string[][] content = [["Anne", "Johnson", "SE"], ["John", "Cameron", "QA"]];
# stream<string[], io:Error?> stringStream = content.toStream();
# stream<Coord, io:Error?> recordStream = contentRecord.toStream();
# io:Error? result = io:fileWriteCsvFromStream("./resources/myfile.csv", stringStream);
# io:Error? resultRecord = io:fileWriteCsvFromStream("./resources/myfileRecord.csv", recordStream);
# ```
# + path - The CSV file path
# + content - A CSV record stream to be written
# + option - Indicate whether to overwrite or append the given content
# + return - `()` when the writing was successful or an `io:Error`
public isolated function fileWriteCsvFromStream(string path, stream<string[]|map<anydata>, Error?> content,
        FileWriteOption option = OVERWRITE) returns Error? {
    return channelWriteCsvFromStream(path, option, content);
}
