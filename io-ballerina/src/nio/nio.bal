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

# Read bytes as a stream of chunks.
# ```ballerina
# stream<byte[], io:Error>|io:Error content = io:readNBytes("./resources/myfile.txt", 1000);
# ```
# + path - File path
# + n - Chunk size
# + return - Either a byte chunk stream or `io:Error`
public function readBytesAsStream(@untainted string path, 
                                  @untainted int n = 4096) returns @tainted stream<byte[], Error>|Error {}

# Read all bytes from a file.
# ```ballerina
# byte[]|io:Error content = io:readAllBytes("./resources/myfile.txt");
# ```
# + path - File path
# + return - Either a byte array or `io:Error`
public function readAllBytes(@untainted string path) returns @tainted byte[]|Error {}

# Read file lines as a stream.
# ```ballerina
# stream<string, io:Error>|io:Error content = io:readLinesAsStream("./resources/myfile.txt");
# ```
# + path - File path
# + return - Either a string or `io:Error`
public function readLinesAsStream(@untainted string path) returns @tainted stream<string, Error>|Error {}

# Read all lines of a given file.
# ```ballerina
# string[]|io:Error content = io:readAllLines("./resources/myfile.txt");
# ```
# + path - File path
# + return - Either a string array or `io:Error`
public function readAllLines(@untainted string path) returns @tainted string[]|Error {}

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
# string[][]|io:Error content = io:readCsv("./resources/myfile.csv");
# ```
# + path - File path
# + fs - Field separator (this could be a regex)
# + rs - Record separator (this could be a regex)
# + nHeaders - Number of headers, which should be skipped prior to reading records
# + return - Either an array of string arrays or `io:Error`
public function readCsv(@untainted string path, 
                        Separator fs = ",", 
                        Separator rs = "\n", 
                        int nHeaders = 0) returns @tainted string[][]|Error {}


# Read file content as a CSV.
# ```ballerina
# stream<string[]|Error>|io:Error content = io:readCsvAsStream("./resources/myfile.csv");
# ```
# + path - File path
# + fs - Field separator (this could be a regex)
# + rs - Record separator (this could be a regex)
# + nHeaders - Number of headers, which should be skipped prior to reading records
# + return - Either a stream of string array or `io:Error`
public function readCsvAsStream(@untainted string path,
                                Separator fs = ",",
                                Separator rs = "\n", 
                                int nHeaders = 0) returns @tainted stream<string[], Error>|Error, {}

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
# io:Error? result = io:writeBytes("./resources/myfile.txt", content);
# ```
# + path - File path
# + content - Byte content to write
# + return - `io:Error` or else `()`
public function writeAllBytes(@untainted string path, byte[] content) returns Error? {}

# Append a set of bytes to a file.
# ```ballerina
# byte[] content = [60, 78, 39, 28];
# io:Error? result = io:appendBytes("./resources/myfile.txt", content);
# ```
# + path - File path
# + content - Byte content to append
# + return - `io:Error` or else `()`
public function appendBytes(@untainted string path, byte[] content) returns Error? {}

# Write string content to a file.
# ```ballerina
# io:Error? result = io:writeString("./resources/myfile.txt", "Hello World..!");
# ```
# + path - File path
# + content - String content to write
# + return - `io:Error` or else `()`
public function writeString(@untainted string path, string content) returns Error? {}

# Append string content to a file.
# ```ballerina
# io:Error? result = io:appendString("./resources/myfile.txt", "Good Day..!!");
# ```
# + path - File path
# + content - String content to append
# + return - `io:Error` or else `()`
public function appendString(@untainted string path, string content) returns Error? {}

# Write JSON content to a file.
# ```ballerina
# json content = {"name": "Anne", "age": 30};
# io:Error? result = io:writeJson("./resources/myfile.json", content);
# ```
# + path - File path
# + content - JSON content to write
# + return - `io:Error` or else `()`
public function writeJson(@untainted string path, json content) returns Error? {}

# Write XML content to a file.
# ```ballerina
# xml content = xml `<book>The Lost World</book>`;
# io:Error? result = io:writeXml("./resources/myfile.xml", content);
# ```
# + path - File path
# + content - XML content to write
# + return - `io:Error` or else `()`
public function writeXml(@untainted string path, xml content) returns Error? {}

# Write CSV content to a file.
# ```ballerina
# string[][] content = [["Anne", "Johnson", "SE"], ["John", "Cameron", "QA"]];
# io:Error? result = io:writeCsv("./resources/myfile.csv", content);
# ```
# + path - File path
# + content - CSV content as an array of string arrays
# + fs - Field separator (this could be a regex)
# + rs - Record separator (this could be a regex)
# + return - `io:Error` or else `()`
public function writeCsv(@untainted string path, 
                         string[][] content, 
                         Separator fs = ",", 
                         Separator rs = "\n") returns Error? {}

# Append CSV content to a file.
# ```ballerina
# string[] content = ["Jamie", "Fox", "TL"];
# io:Error? result = io:writeCsv("./resources/myfile.csv", content);
# ```
# + path - File path
# + content - CSV record as an array of strings
# + fs - Field separator (this could be a regex)
# + rs - Record separator (this could be a regex)
# + return - `io:Error` or else `()`
public function appendCsv(@untainted string path, 
                          string[] content, 
                          Separator fs = ",", 
                          Separator rs = "\n") returns Error? {}


# Returns the current working directory.
# ```ballerina
# string dirPath = io:getCurrentDirectory();
# ```
# 
# + return - Current working directory or else an empty string if the current working directory cannot be determined
public isolated function getCurrentDirectory() returns string {};

# Reports whether the file or directory exists in the given the path.
# ```ballerina
# boolean result = io:exists("foo/bar.txt");
# ```
#
# + path - String value of the file path
# + return - True if the path is absolute or else false
public isolated function exists(@untainted string path) returns boolean {}

# Creates a new directory with the specified file name.
# If the `parentDirs` flag is true, it creates a directory in the specified path with any necessary parents.
# ```ballerina
# string | error results = io:createDir("foo/bar");
# ```
#
# + dir - Directory name
# + parentDirs - Indicates whether the `createDir` should create non-existing parent directories
# + return - Absolute path value of the created directory or else an `io:Error` if failed
public function createDir(@untainted string dir, boolean parentDirs = false) returns string|Error {}

# Removes the specified file or directory.
# If the recursive flag is true, it removes the path and any children it contains.
# ```ballerina
# io:Error? results = io:remove("foo/bar.txt");
# ```
#
# + path - String value of the file/directory path
# + recursive - Indicates whether the `remove` should recursively remove all the files inside the given directory
# + return - An `io:Error` if failed to remove
public function remove(@untainted string path, boolean recursive = false) returns Error? {}

# Renames(Moves) the old path with the new path.
# If the new path already exists and it is not a directory, this replaces the file.
# ```ballerina
# io:error? results = io:rename("/A/B/C", "/A/B/D");
# ```
#
# + oldPath - String value of the old file path
# + newPath - String value of the new file path
# + return - An `io:Error` if failed to rename
public function rename(@untainted string oldPath, @untainted string newPath) returns Error? {}

# Returns the default directory to use for temporary files.
# ```ballerina
# string results = io:tempDir();
# ```
#
# + return - Temporary directory location
public isolated function tempDir() returns string {}

# Creates a file in the specified file path.
# Truncates if the file already exists in the given path.
# ```ballerina
# string | error results = io:createFile("bar.txt");
# ```
#
# + path - String value of the file path
# + return - Absolute path value of the created file or else an `io:Error` if failed
public function createFile(@untainted string path) returns string|Error {}

# Returns the metadata information of the file specified in the file path.
# ```ballerina
# io:Stat | error result = io:getFileInfo("foo/bar.txt");
# ```
#
# + path - String value of the file path.
# + return - The `Stat` instance with the file metadata or else an `io:Error`
public isolated function stat(@untainted string path) returns readonly & Stat|Error {}

# Reads the directory and returns a list of files and directories 
# inside the specified directory.
# ```ballerina
# io:Stat[] | error results = io:readDir("foo/bar");
# ```
#
# + path - String value of the directory path.
# + maxDepth - The maximum number of directory levels to visit. -1 to indicate that all levels should be visited
# + return - The `Stat` array or else an `io:Error` if there is an error while changing the mode.
public function readDir(@untainted string path, int maxDepth = -1) returns readonly & Stat[]|Error {}

# Copy the file/directory in the old path to the new path.
# If a file already exists in the new path, this replaces that file.
# ```ballerina
# io:Error? results = io:copy("/A/B/C", "/A/B/D", true);
# ```
#
# + sourcePath - String value of the old file path
# + destinationPath - String value of the new file path
# + replaceExisting - Flag to replace if the file already exists in the destination path
# + return - An `io:Error` if failed to rename
public function copy(@untainted string sourcePath, @untainted string destinationPath,
                     boolean replaceExisting = false) returns Error? {}

# Truncates the file.
# ```ballerina
# io:Error? results = io:truncate("/A/B/C");
# ```
#
# + path - String value of the file path.
# + return - An `io:Error` if failed to truncate.
public function truncate(@untainted string path) returns Error? {}

# Creates new path as a symbolic link to old path.
# ```ballerina
# io:Error? results = io:symlink("/A/B/C", "/A/B/D");
# ```
#
# + oldpath - String value of the old file path
# + newpath - String value of the new file path
public function symlink(@untainted string oldpath, @untainted string newpath) returns Error? {}

# Watches the changes of a given directory and execute the given callback.
# ```ballerina
# var callaback = function(FileEvent event) => {
# 
#                 }
# io:Error? results = io:watch("foo/bar", callaback);
# ```
#
# + path - File path to be watched
# + callback - The callback function
public function watchDir(@untainted string path, function callback) returns Error? {}

