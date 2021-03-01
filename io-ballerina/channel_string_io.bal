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

function channelReadLinesAsStream(ReadableChannel readableChannel) returns @tainted stream<string, Error>|Error {
    var characterChannel = getReadableCharacterChannel(readableChannel);
    if (characterChannel is ReadableCharacterChannel) {
        return characterChannel.lineStream();
    } else {
        return characterChannel;
    }
}

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

function channelWriteLinesFromStream(WritableChannel writableChannel, stream<string, Error> lineStream) returns Error? {
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

function channelWriteXml(WritableChannel writableChannel, xml content, XmlDoctype? xmlDoctype = ()) returns Error? {
    var characterChannel = getWritableCharacterChannel(writableChannel);
    if (characterChannel is WritableCharacterChannel) {
        Error? writeResult = ();
        if (xmlDoctype != ()) {
            writeResult = characterChannel.writeXml(content, <XmlDoctype>xmlDoctype);
        } else {
            writeResult = characterChannel.writeXml(content);
        }
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
        TypeMismatchError e = error TypeMismatchError("Expected ReadableByteChannel/ReadableCharacterChannel but found a " +
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
        TypeMismatchError e = error TypeMismatchError("Expected ReadableByteChannel/ReadableCharacterChannel but found a " +
        'value:toString(typeof writableChannel));
        return e;
    }
    return writableCharacterChannel;
}
