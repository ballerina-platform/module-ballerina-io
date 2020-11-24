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

import ballerina/lang.'value;

# Reads the entire channel content as a `string` from the specified channel.
# ```ballerina
# string|io:Error content = io:channelReadString(readableChannel);
# ```
# + readableChannel - A readable channel. The possible inputs are `io:ReadableByteChannel` or `io:ReadableCharacterChannel`.
# + return - The entire channel content as a string or an `io:Error`
function channelReadString(ReadableChannel readableChannel) returns @tainted string|Error {
    var characterChannel = getReadableCharacterChannel(readableChannel);
    if (characterChannel is ReadableCharacterChannel) {
        var result = characterChannel.readString();
        var closeResult = characterChannel.close();
        return result;
    } else {
        return characterChannel;
    }
}

# Reads the entire channel content as a list of lines from the specified channel.
# ```ballerina
# string[]|io:Error content = io:channelReadLines(readableChannel);
# ```
# + readableChannel - A readable channel. The possible inputs are `io:ReadableByteChannel` or `io:ReadableCharacterChannel`.
# + return - The channel content as list of lines or an `io:Error`
function channelReadLines(ReadableChannel readableChannel) returns @tainted string[]|Error {
    var characterChannel = getReadableCharacterChannel(readableChannel);
    if (characterChannel is ReadableCharacterChannel) {
        var result = characterChannel.readAllLines();
        var closeResult = characterChannel.close();
        return result;
    } else {
        return characterChannel;
    }
}

# Reads channel content as a stream of lines from the specified channel.
# ```ballerina
# stream<string>|io:Error content = io:channelReadLinesAsStream(readableChannel);
# ```
# + readableChannel - A readable channel. The possible inputs are `io:ReadableByteChannel` or `io:ReadableCharacterChannel`.
# + return - The channel content as a stream of strings or an `io:Error`
function channelReadLinesAsStream(ReadableChannel readableChannel) returns @tainted stream<string>|Error {
    var characterChannel = getReadableCharacterChannel(readableChannel);
    if (characterChannel is ReadableCharacterChannel) {
        return characterChannel.lineStream();
    } else {
        return characterChannel;
    }
}

# Reads channel content as a JSON from the specified channel.
# ```ballerina
# json|io:Error content = io:channelReadJson(readableChannel);
# ```
# + readableChannel - A readable channel. The possible inputs are `io:ReadableByteChannel` or `io:ReadableCharacterChannel`.
# + return - The channel content as a JSON object or an `io:Error`
function channelReadJson(ReadableChannel readableChannel) returns @tainted json|Error {
    var characterChannel = getReadableCharacterChannel(readableChannel);
    if (characterChannel is ReadableCharacterChannel) {
        var result = characterChannel.readJson();
        var closeResult = characterChannel.close();
        return result;
    } else {
        return characterChannel;
    }
}

# Reads channel content as an XML from the specified channel.
# ```ballerina
# xml|io:Error content = io:channelReadXml(readableChannel);
# ```
# + readableChannel - A readable channel. The possible inputs are `io:ReadableByteChannel` or `io:ReadableCharacterChannel`.
# + return - The channel content as an XML or an `io:Error`
function channelReadXml(ReadableChannel readableChannel) returns @tainted xml|Error {
    var characterChannel = getReadableCharacterChannel(readableChannel);
    if (characterChannel is ReadableCharacterChannel) {
        var result = characterChannel.readXml();
        var closeResult = characterChannel.close();
        return result;
    } else {
        return characterChannel;
    }
}

# Writes the given `string` value to the specified channel.
# ```ballerina
# string content = "Hello Universe..!!";
# io:Error result = io:channelWriteString(writableChannel, content);
# ```
# + writableChannel - A writable channel. The possible inputs are `io:WritableByteChannel` or `io:WritableCharacterChannel`.
# + content - String content to be written
# + return - The null `()` value when the writing was successful or an `io:Error`
function channelWriteString(WritableChannel writableChannel, string content) returns Error? {
    var characterChannel = getWritableCharacterChannel(writableChannel);
    if (characterChannel is WritableCharacterChannel) {
        var writeResult = characterChannel.write(content, 0);
        if (writeResult is Error) {
            return writeResult;
        }
        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            return closeResult;
        }
        return ();
    } else {
        return characterChannel;
    }
}

# Write the given array of lines to the specified channel.
# During the writing operation, a newline character `\n` will be added after each line.
# ```ballerina
# string[] content = ["Hello Universe..!!", "How are you?"];
# io:Error result = io:channelWriteLines(writableChannel, content);
# ```
# + writableChannel - A writable channel. The possible inputs are `io:WritableByteChannel` or `io:WritableCharacterChannel`.
# + content - An array of string lines to be written
# + return - The null `()` value when the writing was successful or an `io:Error`
function channelWriteLines(WritableChannel writableChannel, string[] content) returns Error? {
    var characterChannel = getWritableCharacterChannel(writableChannel);
    if (characterChannel is WritableCharacterChannel) {
        string writeContent = "";
        foreach string line in content {
            writeContent = writeContent + line + NEW_LINE;
        }
        var writeResult = characterChannel.write(writeContent, 0);
        if (writeResult is Error) {
            return writeResult;
        }
        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            return closeResult;
        }
        return ();
    } else {
        return characterChannel;
    }
}

# Write lines from the given stream to the specified channel.
# During the writing operation, a newline character `\n` will be added after each line.
# ```ballerina
# string content = ["Hello Universe..!!", "How are you?"];
# stream<string, io:Error> lineStream = content.toStream();
# io:Error result = io:channelWriteLinesFromStream(writableChannel, lineStream);
# ```
# + writableChannel - A writable channel. The possible inputs are `io:WritableByteChannel` or `io:WritableCharacterChannel`.
# + lineStream - A stream of lines to be written
# + return - The null `()` value when the writing was successful or an `io:Error`
function channelWriteLinesFromStream(WritableChannel writableChannel, stream<string> lineStream) returns Error? {
    var characterChannel = getWritableCharacterChannel(writableChannel);
    if (characterChannel is WritableCharacterChannel) {
        error? e = lineStream.forEach(function(string stringContent) {
                                          if (characterChannel is WritableCharacterChannel) {
                                              var r = characterChannel.writeLine(stringContent);
                                          }
                                      });
        if (e is Error) {
            return e;
        }
        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            return closeResult;
        }
        return ();
    } else {
        return characterChannel;
    }
}

# Write the given JSON content to the specified channel.
# ```ballerina
# json content = {"name": "Anne", "age": 30};
# io:Error? content = io:channelWriteJson(writableChannel);
# ```
# + writableChannel - A writable channel. The possible inputs are `io:WritableByteChannel` or `io:WritableCharacterChannel`.
# + content - JSON content to be written
# + return - The null `()` value when the writing was successful or an `io:Error`
function channelWriteJson(WritableChannel writableChannel, json content) returns @tainted Error? {
    var characterChannel = getWritableCharacterChannel(writableChannel);
    if (characterChannel is WritableCharacterChannel) {
        var writeResult = characterChannel.writeJson(content);
        if (writeResult is Error) {
            return writeResult;
        }
        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            return closeResult;
        }
        return ();
    } else {
        return characterChannel;
    }
}

# Write the XML content to the specified channel.
# ```ballerina
# xml content = xml `<book>The Lost World</book>`;
# io:Error? result = io:channelWriteXml(writableChannel, content);
# ```
# + writableChannel - A writable channel. The possible inputs are `io:WritableByteChannel` or `io:WritableCharacterChannel`.
# + content - XML content to be written
# + return - The null `()` value when the writing was successful or an `io:Error`
function channelWriteXml(WritableChannel writableChannel, xml content) returns Error? {
    var characterChannel = getWritableCharacterChannel(writableChannel);
    if (characterChannel is WritableCharacterChannel) {
        var writeResult = characterChannel.writeXml(content);
        if (writeResult is Error) {
            return writeResult;
        }
        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            return closeResult;
        }
        return ();
    } else {
        return characterChannel;
    }
}

function getReadableCharacterChannel(ReadableChannel readableChannel) returns ReadableCharacterChannel|Error {
    ReadableCharacterChannel readableCharacterChannel;
    if (readableChannel is ReadableByteChannel) {
        readableCharacterChannel = new (readableChannel, DEFAULT_ENCODING);
    } else if (readableChannel is ReadableCharacterChannel) {
        readableCharacterChannel = readableChannel;
    } else {
        TypeMismatchError e = TypeMismatchError("Expected ReadableByteChannel/ReadableCharacterChannel but found a " + 
        'value:toString(typeof readableChannel));
        return e;
    }
    return readableCharacterChannel;
}

function getWritableCharacterChannel(WritableChannel writableChannel) returns WritableCharacterChannel|Error {
    WritableCharacterChannel writableCharacterChannel;
    if (writableChannel is WritableByteChannel) {
        writableCharacterChannel = new (writableChannel, DEFAULT_ENCODING);
    } else if (writableChannel is WritableCharacterChannel) {
        writableCharacterChannel = writableChannel;
    } else {
        TypeMismatchError e = TypeMismatchError("Expected ReadableByteChannel/ReadableCharacterChannel but found a " + 
        'value:toString(typeof writableChannel));
        return e;
    }
    return writableCharacterChannel;
}
