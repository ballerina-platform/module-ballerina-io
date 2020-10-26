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

# Read the entire file content as a string.
# ```ballerina
# string|io:Error content = io:fileReadString("./resources/myfile.txt");
# ```
# + path - File path
# + return - Either a string or `io:Error`
public function fileReadString(@untainted string path) returns @tainted readonly & string|Error {
    var fileOpenResult = openReadableFile(path);
    if (fileOpenResult is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new (fileOpenResult, DEFAULT_ENCODING);
        var fileReadResult = characterChannel.readString();
        if (fileReadResult is string) {
            return <readonly & string> fileReadResult.cloneReadOnly();
        } else {
            return fileReadResult;
        }
    } else {
        return fileOpenResult;
    }
}

# Read the entire file content as a list of lines.
# ```ballerina
# string[]|io:Error content = io:fileReadLines("./resources/myfile.txt");
# ```
# + path - File path
# + return - Either a string array or `io:Error`
public function fileReadLines(@untainted string path) returns @tainted readonly & string[]|Error {
    var fileOpenResult = openReadableFile(path);
    if (fileOpenResult is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new (fileOpenResult, DEFAULT_ENCODING);
        var fileReadResult = characterChannel.readAllLines();
        if (fileReadResult is string[]) {
            return <readonly & string[]> fileReadResult.cloneReadOnly();
        } else {
            return fileReadResult;
        }
    } else {
        return fileOpenResult;
    }
}

# Read file content as a stream of lines.
# ```ballerina
# stream<string>|io:Error content = io:fileReadLinesAsStream("./resources/myfile.txt");
# ```
# + path - File path
# + return - Either a string array or `io:Error`
public function fileReadLinesAsStream(@untainted string path) returns @tainted stream<string>|Error? {
    var fileOpenResult = openReadableFile(path);
    if (fileOpenResult is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new (fileOpenResult, DEFAULT_ENCODING);
        return characterChannel.lineStream();
    } else {
        return fileOpenResult;
    }
}

# Write a string content to a file.
# ```ballerina
# string content = "Hello Universe..!!";
# io:Error result = io:fileWriteString("./resources/myfile.txt", content);
# ```
# + path - File path
# + content - String content to read
# + return - Either `io:Error` or `()`
public function fileWriteString(@untainted string path, string content) returns Error? {
    var fileOpenResult = openWritableFile(path);
    if (fileOpenResult is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new (fileOpenResult, DEFAULT_ENCODING);
        var writeResult = characterChannel.write(content, 0);
        if (writeResult is Error) {
            return writeResult;
        } else {
            return ();
        }
    } else {
        return fileOpenResult;
    }
}

# Write an array of lines to a file.
# ```ballerina
# string[] content = ["Hello Universe..!!", "How are you?"];
# io:Error result = io:fileWriteLines("./resources/myfile.txt", content);
# ```
# + path - File path
# + content - An array of string lines
# + return - Either `io:Error` or `()`
public function fileWriteLines(@untainted string path, string[] content) returns Error? {
    var fileOpenResult = openWritableFile(path);
    if (fileOpenResult is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new (fileOpenResult, DEFAULT_ENCODING);
        string[] reversedContent = content.reverse();
        string writeContent = "";
        foreach string line in reversedContent {
            writeContent = line + "\n";
        }
        var writeResult = characterChannel.write(writeContent, 0);
        if (writeResult is Error) {
            return writeResult;
        } else {
            return ();
        }
    } else {
        return fileOpenResult;
    }
}

# Write stream of lines to a file.
# ```ballerina
# string content = ["Hello Universe..!!", "How are you?"];
# stream<string, io:Error> lineStream = content.toStream();
# io:Error result = io:fileWriteLinesFromStream("./resources/myfile.txt", lineStream);
# ```
# + path - File path
# + content - A stream of lines
# + return - Either `io:Error` or `()`
public function fileWriteLinesFromStream(@untainted string path, stream<string> characterStream) returns Error? {
    var fileOpenResult = openWritableFile(path);
    if (fileOpenResult is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new (fileOpenResult, DEFAULT_ENCODING);
        error? e = characterStream.forEach(function (string stringContent) {
            var r = characterChannel.writeLine(stringContent);
        });
        var fileCloseResult = fileOpenResult.close();
        if (e is Error) {
            return e;
        }
        if (fileCloseResult is Error) {
            return fileCloseResult;
        }
    } else {
        return fileOpenResult;
    }
}

