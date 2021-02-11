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
# ```ballerina
# string|io:Error content = io:fileReadString("./resources/myfile.txt");
# ```
# + path - The path of the file
# + return - The entire file content as a string or an `io:Error`
public function fileReadString(@untainted string path) returns @tainted string|Error {
    var byteChannel = openReadableFile(path);
    if (byteChannel is ReadableByteChannel) {
        return channelReadString(byteChannel);
    } else {
        return byteChannel;
    }
}

# Reads the entire file content as a list of lines.
# ```ballerina
# string[]|io:Error content = io:fileReadLines("./resources/myfile.txt");
# ```
# + path - The path of the file
# + return - The file as list of lines or an `io:Error`
public function fileReadLines(@untainted string path) returns @tainted string[]|Error {
    var byteChannel = openReadableFile(path);
    if (byteChannel is ReadableByteChannel) {
        return channelReadLines(byteChannel);
    } else {
        return byteChannel;
    }
}

# Reads file content as a stream of lines.
# ```ballerina
# stream<string, io:Error>|io:Error content = io:fileReadLinesAsStream("./resources/myfile.txt");
# ```
# + path - The path of the file
# + return - The file content as a stream of strings or an `io:Error`
public function fileReadLinesAsStream(@untainted string path) returns @tainted stream<string, Error>|Error {
    var byteChannel = openReadableFile(path);
    if (byteChannel is ReadableByteChannel) {
        return channelReadLinesAsStream(byteChannel);
    } else {
        return byteChannel;
    }
}

# Reads file content as a JSON.
# ```ballerina
# json|io:Error content = io:fileReadJson("./resources/myfile.json");
# ```
# + path - The path of the JSON file
# + return - The file content as a JSON object or an `io:Error`
public function fileReadJson(@untainted string path) returns @tainted json|Error {
    var byteChannel = openReadableFile(path);
    if (byteChannel is ReadableByteChannel) {
        return channelReadJson(byteChannel);
    } else {
        return byteChannel;
    }
}

# Reads file content as an XML.
# ```ballerina
# xml|io:Error content = io:fileReadXml("./resources/myfile.xml");
# ```
# + path - The path of the XML file
# + return - The file content as an XML or an `io:Error`
public function fileReadXml(@untainted string path) returns @tainted xml|Error {
    var byteChannel = openReadableFile(path);
    if (byteChannel is ReadableByteChannel) {
        return channelReadXml(byteChannel);
    } else {
        return byteChannel;
    }
}

# Write a string content to a file.
# ```ballerina
# string content = "Hello Universe..!!";
# io:Error? result = io:fileWriteString("./resources/myfile.txt", content);
# ```
# + path - The path of the file
# + content - String content to write
# + option - To indicate whether to overwrite or append the given content
# + return - The null `()` value when the writing was successful or an `io:Error`
public function fileWriteString(@untainted string path, string content,
                    FileWriteOption option = OVERWRITE) returns Error? {
    var byteChannel = openWritableFile(path, option);
    if (byteChannel is WritableByteChannel) {
        return channelWriteString(byteChannel, content);
    } else {
        return byteChannel;
    }
}

# Write an array of lines to a file.
# During the writing operation, a newline character `\n` will be added after each line.
# ```ballerina
# string[] content = ["Hello Universe..!!", "How are you?"];
# io:Error? result = io:fileWriteLines("./resources/myfile.txt", content);
# ```
# + path - The path of the file
# + content - An array of string lines to write
# + option - To indicate whether to overwrite or append the given content
# + return - The null `()` value when the writing was successful or an `io:Error`
public function fileWriteLines(@untainted string path, string[] content,
                    FileWriteOption option = OVERWRITE) returns Error? {
    var byteChannel = openWritableFile(path, option);
    if (byteChannel is WritableByteChannel) {
        return channelWriteLines(byteChannel, content);
    } else {
        return byteChannel;
    }
}

# Write stream of lines to a file.
# During the writing operation, a newline character `\n` will be added after each line.
# ```ballerina
# string content = ["Hello Universe..!!", "How are you?"];
# stream<string, io:Error> lineStream = content.toStream();
# io:Error? result = io:fileWriteLinesFromStream("./resources/myfile.txt", lineStream);
# ```
# + path - The path of the file
# + lineStream -  A stream of lines to write
# + option - To indicate whether to overwrite or append the given content
# + return - The null `()` value when the writing was successful or an `io:Error`
public function fileWriteLinesFromStream(@untainted string path, stream<string, Error> lineStream,
                    FileWriteOption option = OVERWRITE) returns Error? {
    var byteChannel = openWritableFile(path, option);
    if (byteChannel is WritableByteChannel) {
        return channelWriteLinesFromStream(byteChannel, lineStream);
    } else {
        return byteChannel;
    }
}

# Write a JSON to a file.
# ```ballerina
# json content = {"name": "Anne", "age": 30};
# io:Error? content = io:fileWriteJson("./resources/myfile.json");
# ```
# + path - The path of the JSON file
# + content - JSON content to write
# + return - The null `()` value when the writing was successful or an `io:Error`
public function fileWriteJson(@untainted string path, json content) returns @tainted Error? {
    var byteChannel = openWritableFile(path);
    if (byteChannel is WritableByteChannel) {
        return channelWriteJson(byteChannel, content);
    } else {
        return byteChannel;
    }
}

# Write XML content to a file.
# ```ballerina
# xml content = xml `<book>The Lost World</book>`;
# io:Error? result = io:fileWriteXml("./resources/myfile.xml", content);
# ```
# + path - The path of the XML file
# + content - XML content to write
# + xmlOptions - XML writing options(XML entity type and DOCTYPE)
# + fileWriteOption - file write option(`OVERWRITE` and `APPEND` are the possible values, and the default value is `OVERWRITE`)
# + return - The null `()` value when the writing was successful or an `io:Error`
public function fileWriteXml(@untainted string path, xml content, *XmlWriteOptions xmlOptions, FileWriteOption fileWriteOption = OVERWRITE) returns Error? {
    WritableByteChannel|Error byteChannel;
    xml writeContent = xml ``;
    if (xmlOptions.xmlEntityType == DOCUMENT_ENTITY) {
        if (fileWriteOption == APPEND) {
            return error ConfigurationError("The APPEND operation not allowed with DOCUMENT");
        }
        if (xml:length(content) > 1) {
            return error ConfigurationError("The DOCUMENT XML can only contains single root");
        }
        if (xmlOptions.doctype != ()) {
            writeContent = xml:concat(populateDoctype(content, <XmlDoctype>xmlOptions.doctype), NEW_LINE, content);
        } else {
            writeContent = content;
        }
        byteChannel = openWritableFile(path);
    } else {
        if (fileWriteOption == APPEND) {
            byteChannel = openWritableFile(path, APPEND);
        } else {
            byteChannel = openWritableFile(path);
        }
        writeContent = content;
    }

    if (byteChannel is WritableByteChannel) {
        return channelWriteXml(byteChannel, writeContent);
    } else {
        return byteChannel;
    }
}

function populateDoctype(xml content, XmlDoctype doctype) returns string {
    // Generate <!DOCTYPE rootElementName PUBLIC|SYSTEM PublicIdentifier SystemIdentifier internalSubset>
    string doctypeElement = "";
    string startElement = "<!DOCTYPE ";
    string endElement = ">";
    string systemElement = "SYSTEM";
    string publicElement = "PUBLIC";
    xml:Element rootElement = <xml:Element> content;
    if (doctype.internalSubset != ()) {
         doctypeElement = startElement + <string>rootElement.getName() +
                            SINGLE_SPACE + <string>doctype.internalSubset + endElement;
    } else if (doctype.'public != () && doctype.system != ()) {
         doctypeElement = startElement + <string>rootElement.getName() +
                            SINGLE_SPACE + publicElement + SINGLE_SPACE +
                            DOUBLE_QUOTE + <string>doctype.'public + DOUBLE_QUOTE + SINGLE_SPACE +
                            DOUBLE_QUOTE + <string>doctype.system + DOUBLE_QUOTE + endElement;

    } else if (doctype.'public != ()) {
         doctypeElement = startElement + <string>rootElement.getName() +
                            SINGLE_SPACE + publicElement + SINGLE_SPACE +
                            DOUBLE_QUOTE + <string>doctype.'public + DOUBLE_QUOTE + endElement;
    } else if (doctype.system != ()) {
         doctypeElement = startElement + <string>rootElement.getName() +
                            SINGLE_SPACE + systemElement + SINGLE_SPACE +
                            DOUBLE_QUOTE + <string>doctype.system + DOUBLE_QUOTE + endElement;
    }
    return doctypeElement;
}
