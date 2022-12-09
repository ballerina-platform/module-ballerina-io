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

# Read file content as a CSV.
# ```ballerina
# string[][]|io:Error content = io:fileReadCsv("./resources/myfile.csv");
# record[]|io:Error content = io:fileReadCsv("./resources/myfile.csv");
# ```
# + path - The CSV file path
# + skipHeaders - Number of headers, which should be skipped prior to reading records
# + returnType - The type of the return value (string[] or a Ballerina record)
# + return - The entire CSV content in the channel as an array of string arrays, array of Ballerina records or an `io:Error`
public isolated function fileReadCsv(string path, int skipHeaders = 0, typedesc<string[]|map<anydata>> returnType = <>) returns returnType[]|Error = @java:Method {
    name: "fileReadCsv",
    'class: "io.ballerina.stdlib.io.nativeimpl.CsvChannelUtils"
} external;

# Read file content as a CSV.
# ```ballerina
# stream<string[]|io:Error content = io:fileReadCsvAsStream("./resources/myfile.csv");
# stream<record, io:Error?>|io:Error content = io:fileReadCsvAsStream("./resources/myfile.csv");
# ```
# + path - The CSV file path
# + returnType - The type of the return value (string[] or a Ballerina record)
# + return - The entire CSV content in the channel a stream of string arrays, Ballerina records or an `io:Error`
public isolated function fileReadCsvAsStream(string path, typedesc<string[]|map<anydata>> returnType = <>) returns stream<returnType, Error?>|Error = @java:Method {
    name: "createCsvAsStream",
    'class: "io.ballerina.stdlib.io.nativeimpl.CsvChannelUtils"
} external;

# Write CSV content to a file.
# If the input is of `record{}[]` type, the field names of the record{} are written as headers to the file. Additionally if the CSV contains data records, the header is used to identify the order of the values.
# ```ballerina
# type Coord record {int x;int y;};
# Coord[] contentRecord = [{x: 1,y: 2},{x: 1,y: 2}]
# string[][] content = [["Anne", "Johnson", "SE"], ["John", "Cameron", "QA"]];
# io:Error? result = io:fileWriteCsv("./resources/myfile.csv", content);
# io:Error? resultRecord = io:fileWriteCsv("./resources/myfileRecord.csv", contentRecord);
# ```
# + path - The CSV file path
# + content - CSV content as an array of string arrays or a array of Ballerina records
# + option - To indicate whether to overwrite or append the given content
# + return - `()` when the writing was successful or an `io:Error`
public isolated function fileWriteCsv(string path, string[][]|map<anydata>[] content, FileWriteOption option = OVERWRITE) returns
Error? {
    return channelWriteCsv(path, option, content);
}

# Write CSV record stream to a file.
# If the input is of `stream<record{}, io:Error?>` type, the field names of the record{} are written as headers to the file. Additionally if the CSV contains data records, the header is used to identify the order of the values.
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
# + option - To indicate whether to overwrite or append the given content
# + return - `()` when the writing was successful or an `io:Error`
public isolated function fileWriteCsvFromStream(string path, stream<string[]|map<anydata>, Error?> content,
        FileWriteOption option = OVERWRITE) returns Error? {
    return channelWriteCsvFromStream(path, option, content);
}
