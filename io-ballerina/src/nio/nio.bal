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

# Read given number of bytes from a file.
# ```ballerina
# byte[]|io:Error content = io:readNBytes("./resources/myfile.txt", 10);
# ```
# + path - File path
# + n - The number of bytes to read
# + return - Either a byte array or `io:Error`
public function readNBytes(@untainted string path, 
                           @untainted int n) returns @tainted byte[]|Error {}

# Read all bytes as a stream from a file.
# ```ballerina
# stream<byte|Error>|io:Error content = io:readAllBytes("./resources/myfile.txt");
# ```
# + path - File path
# + return - Either a byte stream or `io:Error`
public function readAllBytes(@untainted string path) returns stream<byte|Error>|Error {}

# Read given number of characters from a file.
# ```ballerina
# byte[]|io:Error content = io:readNCharacters("./resources/myfile.txt", 10);
# ```
# + path - File path
# + n - The number of characters to read
# + return - Either a string or `io:Error`
public function readNCharacters(@untainted string path, 
                                @untainted int n) returns string|Error {}

# Read file content as a string.
# ```ballerina
# string|io:Error content = io:readString("./resources/myfile.txt");
# ```
# + path - File path
# + return - Either a string or `io:Error`
public function readString(@untainted string path) returns @tainted string|Error {}

# Read file content as a JSON.
# ```ballerina
# json|io:Error content = io:readJson("./resources/myfile.json");
# ```
# + path - File path
# + return - Either a JSON or `io:Error`
public function readJson(@untainted string path) returns @tainted json|Error {}

# Read file content as a XML.
# ```ballerina
# xml|io:Error content = io:readXml("./resources/myfile.xml");
# ```
# + path - File path
# + return - Either a XML or `io:Error`
public function readXml(@untainted string path) returns @tainted xml|Error {}

# Read file content as a CSV.
# ```ballerina
# table<record {}>|io:Error content = io:readCsv("./resources/myfile.csv");
# ```
# + path - File path
# + fs - Field separator, which will separate between the records in the CSV file
# + nHeaders - Number of headers, which should be skipped prior to reading records
# + return - Either a record table or `io:Error`
public function readCsv(@untainted string path, 
                        Separator fs = ",", 
                        int nHeaders = 0) returns @tainted table<record {}>|Error {}


# Read file content as a CSV.
# ```ballerina
# stream<string[]|Error>|io:Error content = io:readCsvAsStream("./resources/myfile.csv");
# ```
# + path - File path
# + fs - Field separator, which will separate between the records in the CSV file
# + nHeaders - Number of headers, which should be skipped prior to reading records
# + return - Either a stream of string array or `io:Error`
public function readCsvAsStream(@untainted string path,
                        Separator fs = ",",
                        int nHeaders = 0) returns @tainted stream<string[]|Error>|Error {}
                        
# Reads a property from a .properties file with a default value.
# ```ballerina
# string|io:Error result = io:readProperty(key, defaultValue);
# ```
# + path - File path
# + key - The property key needs to read.
# + defaultValue - Default value to be return.
# + return - Either a property value as a string or `io:Error`
public function readProperty(@untainted string path, 
                             @untainted string key, 
                             @untainted string defaultValue="") returns @tainted string|Error {}

# Reads all properties from a .properties file.
# ```ballerina
# map<string>|io:Error result = io:readAllProperties();
# ```
# + path - File path
# + return - Either a map that contains all properties or or `io:Error`
public function readAllProperties(@untainted string path) returns @tainted map<string>|Error {}

# Write a set of bytes to a file.
# ```ballerina
# byte[] content = [60, 78, 39, 28];
# io:Error? result = io:writeBytes("./resources/myfile.txt", content, 0);
# ```
# + path - File path
# + return - `io:Error` or else `()`
public function writeBytes(@untainted string path, byte[] content, int offset) returns Error? {}

# Write string content to a file.
# ```ballerina
# io:Error? result = io:writeString("./resources/myfile.txt", "Hello World..!");
# ```
# + path - File path
# + return - `io:Error` or else `()`
public function writeString(@untainted string path, string content) returns Error? {}

# Write JSON content to a file.
# ```ballerina
# json content = {"name": "Anne", "age": 30};
# io:Error? result = io:writeJson("./resources/myfile.json", content);
# ```
# + path - File path
# + return - `io:Error` or else `()`
public function writeJson(@untainted string path, json content) returns Error? {}

# Write XML content to a file.
# ```ballerina
# xml content = xml `<book>The Lost World</book>`;
# io:Error? result = io:writeXml("./resources/myfile.xml", content);
# ```
# + path - File path
# + return - `io:Error` or else `()`
public function writeXml(@untainted string path, xml content) returns Error? {}

# Write CSV content to a file.
# ```ballerina
# table<Employee> employeeTable = table [];
# io:Error? result = io:writeCsv("./resources/myfile.csv", employeeTable);
# ```
# + path - File path
# + return - `io:Error` or else `()`
public function writeCsv(@untainted string path, table<record {}> content) returns Error? {}

# Splits the content based on the specific delimiter.
# TODO: better name for the function
#
# + path - File path
# + delimiter - delimiter to split the content
# + return - `io:Error` or else `strema<string>`
public function scanString(string path, string delimiter) returns stream<String>|Error {}

# Splits the content based on the specific delimiter.
# TODO: better name for the function
#
# + path - File path
# + delimiter - delimiter to split the content
# + return - `io:Error` or else `strema<byte[]>`
public function scanBytes(string path, string delimiter) returns stream<byte[]>|Error {}
