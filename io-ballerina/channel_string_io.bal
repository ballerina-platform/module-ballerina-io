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

isolated function channelReadString(ReadableChannel readableChannel) returns @tainted string|Error {
    ReadableCharacterChannel characterChannel = check getReadableCharacterChannel(readableChannel);
    var result = characterChannel.readString();
    Error? closeResult = characterChannel.close();
    return result;
}

isolated function channelReadLines(ReadableChannel readableChannel) returns @tainted string[]|Error {
    ReadableCharacterChannel characterChannel = check getReadableCharacterChannel(readableChannel);
    var result = characterChannel.readAllLines();
    Error? closeResult = characterChannel.close();
    return result;
}

isolated function channelReadLinesAsStream(ReadableChannel readableChannel) returns @tainted stream<string, Error?>|
Error {
    return (check getReadableCharacterChannel(readableChannel)).lineStream();
}

isolated function channelReadJson(ReadableChannel readableChannel) returns @tainted json|Error {
    ReadableCharacterChannel characterChannel = check getReadableCharacterChannel(readableChannel);
    var result = characterChannel.readJson();
    Error? closeResult = characterChannel.close();
    return result;
}

isolated function channelReadXml(ReadableChannel readableChannel) returns @tainted xml|Error {
    ReadableCharacterChannel characterChannel = check getReadableCharacterChannel(readableChannel);
    var result = characterChannel.readXml();
    Error? closeResult = characterChannel.close();
    return result;
}

isolated function channelWriteString(WritableChannel writableChannel, string content) returns Error? {
    WritableCharacterChannel characterChannel = check getWritableCharacterChannel(writableChannel);
    var writeResult = characterChannel.write(content, 0);
    var closeResult = characterChannel.close();
    if (writeResult is Error) {
        return writeResult;
    }
    if (closeResult is Error) {
        return closeResult;
    }
}

isolated function channelWriteLines(WritableChannel writableChannel, string[] content) returns Error? {
    WritableCharacterChannel characterChannel = check getWritableCharacterChannel(writableChannel);
    string writeContent = "";
    foreach string line in content {
        writeContent = writeContent + line + NEW_LINE;
    }
    var writeResult = characterChannel.write(writeContent, 0);
    var closeResult = characterChannel.close();
    if (writeResult is Error) {
        return writeResult;
    }
    if (closeResult is Error) {
        return closeResult;
    }
}

isolated function channelWriteLinesFromStream(WritableChannel writableChannel, stream<string, Error?> lineStream) returns
Error? {
    WritableCharacterChannel characterChannel = check getWritableCharacterChannel(writableChannel);
    record {| string value; |}|Error? line = lineStream.next();
    while (line is record {| string value; |}) {
        Error? writeResult = characterChannel.writeLine(line.value);
        line = lineStream.next();
    }
    var closeResult = characterChannel.close();
    if (line is Error) {
        return line;
    }
    if (closeResult is Error) {
        return closeResult;
    }
    return ();
}

isolated function channelWriteJson(WritableChannel writableChannel, json content) returns @tainted Error? {
    WritableCharacterChannel characterChannel = check getWritableCharacterChannel(writableChannel);
    var writeResult = characterChannel.writeJson(content);
    var closeResult = characterChannel.close();
    if (writeResult is Error) {
        return writeResult;
    }
    if (closeResult is Error) {
        return closeResult;
    }
    return ();
}

isolated function channelWriteXml(WritableChannel writableChannel, xml content, XmlDoctype? xmlDoctype = ()) returns 
Error? {
    WritableCharacterChannel characterChannel = check getWritableCharacterChannel(writableChannel);
    Error? writeResult = ();
    if (xmlDoctype != ()) {
        writeResult = characterChannel.writeXml(content, <XmlDoctype>xmlDoctype);
    } else {
        writeResult = characterChannel.writeXml(content);
    }
    var closeResult = characterChannel.close();
    if (writeResult is Error) {
        return writeResult;
    }
    if (closeResult is Error) {
        return closeResult;
    }
    return ();
}

isolated function getReadableCharacterChannel(ReadableChannel readableChannel) returns ReadableCharacterChannel|Error {
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

isolated function getWritableCharacterChannel(WritableChannel writableChannel) returns WritableCharacterChannel|Error {
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
