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

# Reads the entire file content as a `string`.
# The resulting string output does not contain the terminal carriage (e.g., `\r` or `\n`).
# ```ballerina
# string|io:Error content = io:fileReadString("./resources/myfile.txt");
# ```
# + path - The file path
# + return - The entire file content as a string or an `io:Error`
public isolated function fileReadString(string path) returns string|Error {
    return channelReadString(check openReadableFile(path));
}

# Reads the entire file content as a list of lines.
# The resulting string array does not contain the terminal carriage (e.g., `\r` or `\n`).
# ```ballerina
# string[]|io:Error content = io:fileReadLines("./resources/myfile.txt");
# ```
# + path - The file path
# + return - The file content as a string array or an `io:Error`
public isolated function fileReadLines(string path) returns string[]|Error {
    return channelReadLines(check openReadableFile(path));
}

# Reads file content as a stream of lines.
# The resulting stream does not contain the terminal carriage (e.g., `\r` or `\n`).
# ```ballerina
# stream<string, io:Error?>|io:Error content = io:fileReadLinesAsStream("./resources/myfile.txt");
# ```
# + path - The file path
# + return - The file content as a stream of strings or an `io:Error`
public isolated function fileReadLinesAsStream(string path) returns stream<string, Error?>|Error {
    return channelReadLinesAsStream(check openReadableFile(path));
}

# Reads file content as a JSON.
# ```ballerina
# json|io:Error content = io:fileReadJson("./resources/myfile.json");
# ```
# + path - The JSON file path
# + return - The file content as a JSON object or an `io:Error`
public isolated function fileReadJson(string path) returns json|Error {
    return channelReadJson(check openReadableFile(path));
}

# Reads file content as an XML.
# ```ballerina
# xml|io:Error content = io:fileReadXml("./resources/myfile.xml");
# ```
# + path - The XML file path
# + return - The file content as an XML or an `io:Error`
public isolated function fileReadXml(string path) returns xml|Error {
    return channelReadXml(check openReadableFile(path));
}

# Writes a string content to a file.
# ```ballerina
# string content = "Hello Universe..!!";
# io:Error? result = io:fileWriteString("./resources/myfile.txt", content);
# ```
# + path - The file path
# + content - String content to write
# + option - Indicate whether to overwrite or append the given content
# + return - `()` when the writing was successful or an `io:Error`
public isolated function fileWriteString(string path, string content, FileWriteOption option = OVERWRITE) returns
Error? {
    return channelWriteString(check openWritableFile(path, option), content);
}

# Writes an array of lines to a file.
# During the writing operation, a newline character `\n` will be added after each line.
# ```ballerina
# string[] content = ["Hello Universe..!!", "How are you?"];
# io:Error? result = io:fileWriteLines("./resources/myfile.txt", content);
# ```
# + path - The file path
# + content - An array of string lines to write
# + option - Indicate whether to overwrite or append the given content
# + return - `()` when the writing was successful or an `io:Error`
public isolated function fileWriteLines(string path, string[] content, FileWriteOption option = OVERWRITE) returns
Error? {
    return channelWriteLines(check openWritableFile(path, option), content);
}

# Writes a stream of lines to a file.
# During the writing operation, a newline character `\n` will be added after each line.
# ```ballerina
# string content = ["Hello Universe..!!", "How are you?"];
# stream<string, io:Error?> lineStream = content.toStream();
# io:Error? result = io:fileWriteLinesFromStream("./resources/myfile.txt", lineStream);
# ```
# + path - The file path
# + lineStream - A stream of lines to write
# + option - Indicate whether to overwrite or append the given content
# + return - `()` when the writing was successful or an `io:Error`
public isolated function fileWriteLinesFromStream(string path, stream<string, Error?> lineStream,
                                                FileWriteOption option = OVERWRITE) returns Error? {
    return channelWriteLinesFromStream(check openWritableFile(path, option), lineStream);
}

# Writes a JSON to a file.
# ```ballerina
# json content = {"name": "Anne", "age": 30};
# io:Error? result = io:fileWriteJson("./resources/myfile.json", content);
# ```
# + path - The JSON file path
# + content - JSON content to write
# + return - `()` when the writing was successful or an `io:Error`
public isolated function fileWriteJson(string path, json content) returns Error? {
    return channelWriteJson(check openWritableFile(path), content);
}

# Writes XML content to a file.
# ```ballerina
# xml content = xml `<book>The Lost World</book>`;
# io:Error? result = io:fileWriteXml("./resources/myfile.xml", content);
# ```
# + path - The XML file path
# + content - XML content to write
# + xmlOptions - XML writing options (XML entity type and DOCTYPE)
# + fileWriteOption - File write option (`OVERWRITE` and `APPEND` are the possible values and the default value is `OVERWRITE`)
# + return - `()` value when the writing was successful or an `io:Error`
public isolated function fileWriteXml(string path, xml content, FileWriteOption fileWriteOption = OVERWRITE,
                                    *XmlWriteOptions xmlOptions) returns Error? {
    WritableByteChannel byteChannel;
    if xmlOptions.xmlEntityType == DOCUMENT_ENTITY {
        if fileWriteOption == APPEND {
            return error ConfigurationError("The file append operation is not allowed for Document Entity");
        }
        if xml:length(content) > 1 {
            return error ConfigurationError("The XML Document can only contains single root");
        }
        byteChannel = check openWritableFile(path);
    } else {
        if fileWriteOption == APPEND {
            byteChannel = check openWritableFile(path, APPEND);
        } else {
            byteChannel = check openWritableFile(path);
        }
    }
    if xmlOptions.doctype != () {
        return channelWriteXml(byteChannel, content, xmlOptions.doctype);
    }
    return channelWriteXml(byteChannel, content);
}
