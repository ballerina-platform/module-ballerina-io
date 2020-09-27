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
# io:FileInfo | error result = io:getFileInfo("foo/bar.txt");
# ```
#
# + path - String value of the file path.
# + return - The `FileInfo` instance with the file metadata or else an `io:Error`
public isolated function getFileInfo(@untainted string path) returns FileInfo|Error {}

# Reads the directory and returns a list of files and directories 
# inside the specified directory.
# ```ballerina
# io:FileInfo[] | error results = io:readDir("foo/bar");
# ```
#
# + path - String value of the directory path.
# + maxDepth - The maximum number of directory levels to visit. -1 to indicate that all levels should be visited
# + return - The `FileInfo` array or else an `io:Error` if there is an error while changing the mode.
public function readDir(@untainted string path, int maxDepth = -1) returns FileInfo[]|Error {}

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
