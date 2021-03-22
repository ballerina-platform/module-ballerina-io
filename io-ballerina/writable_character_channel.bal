// Copyright (c) 2017 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Represents a channel which could be used to write characters through a given WritableCharacterChannel.
public class WritableCharacterChannel {

    private WritableByteChannel bChannel;
    private string charset;

    # Constructs a `WritableByteChannel` from a given `WritableByteChannel` and `Charset`.
    # 
    # + bChannel - The `WritableByteChannel`, which would be used to write the characters
    # + charset - The character set, which would be used to encode the given bytes to characters
    public isolated function init(WritableByteChannel bChannel, string charset) {
        self.bChannel = bChannel;
        self.charset = charset;
        initWritableCharacterChannel(self, bChannel, charset);
    }

    # Writes a given sequence of characters (string).
    # ```ballerina
    # int|io:Error result = writableCharChannel.write("Content", 0);
    # ```
    #
    # + content - Content to be written
    # + startOffset - Number of characters to be offset when writing the content
    # + return - Content length that written or else `io:Error`
    public isolated function write(string content, int startOffset) returns int|Error {
        return writeExtern(self, content, startOffset);
    }

    # Writes a string as a line with a following newline character `\n`.
    # ```ballerina
    # io:Error? result = writableCharChannel.writeLine("Content");
    # ```
    #
    # + content - Content to be written
    # + return - Returns null if the writing was successful or an `io:Error`
    public isolated function writeLine(string content) returns Error? {
        string lineContent = content + NEW_LINE;
        var result = writeExtern(self, lineContent, 0);
        if (result is Error) {
            return result;
        } else {
            return ();
        }
    }

    # Writes a given JSON to the given channel.
    # ```ballerina
    # io:Error? err = writableCharChannel.writeJson(inputJson, 0);
    # ```
    #
    # + content - The JSON to be written
    # + return - Returns null if the writing was successful or an `io:Error`
    public isolated function writeJson(json content) returns Error? {
        return writeJsonExtern(self, content);
    }

    # Writes a given XML to the channel.
    # ```ballerina
    # io:Error? err = writableCharChannel.writeXml(inputXml, 0);
    # ```
    #
    # + content - The XML to be written
    # + xmlDoctype - Optional argument to specify the XML DOCTYPE configurations
    # + return - `()` or else `io:Error` if any error occurred
    public isolated function writeXml(xml content, XmlDoctype? xmlDoctype = ()) returns Error? {
        string doctype = "";
        if (xmlDoctype != ()) {
            doctype = populateDoctype(content, <XmlDoctype>xmlDoctype);
        }
        return writeXmlExtern(self, content, doctype);
    }

    # Writes a given key-valued pair `map<string>` to a property file.
    # ```ballerina
    # io:Error? err = writableCharChannel.writeProperties(properties);
    # ```
    # + properties - The map<string> that contains keys and values
    # + comment - Comment describing the property list
    # + return - `()` or else `io:Error` if any error occurred
    public isolated function writeProperties(map<string> properties, string comment) returns Error? {
        return writePropertiesExtern(self, properties, comment);
    }

    # Closes a given `WritableCharacterChannel` channel.
    # After a channel is closed, any further writing operations will cause an error.
    # ```ballerina
    # io:Error err = writableCharChannel.close();
    # ```
    #
    # + return - `()` or else an `io:Error` if any error occurred
    public isolated function close() returns Error? {
        return closeWritableCharacterChannel(self);
    }
}

isolated function populateDoctype(xml content, XmlDoctype doctype) returns string {
    // Generate <!DOCTYPE rootElementName PUBLIC|SYSTEM PublicIdentifier SystemIdentifier internalSubset>
    string doctypeElement = "";
    string startElement = "<!DOCTYPE";
    string endElement = ">";
    string systemElement = "SYSTEM";
    string publicElement = "PUBLIC";
    xml:Element rootElement = <xml:Element>content;
    if (doctype.internalSubset != ()) {
        doctypeElement = string `${startElement} ${<string>rootElement.getName()} ${<string>doctype.internalSubset}${
        endElement}`;
    } else if (doctype.'public != () && doctype.system != ()) {
        doctypeElement = string `${startElement} ${<string>rootElement.getName()} ${publicElement} "${<string>doctype.
        'public}" "${<string>doctype.system}"${endElement}`;

    } else if (doctype.'public != ()) {
        doctypeElement = string `${startElement} ${<string>rootElement.getName()} ${publicElement} "${<string>doctype.
        'public}"${endElement}`;
    } else if (doctype.system != ()) {
        doctypeElement = string `${startElement} ${<string>rootElement.getName()} ${systemElement} "${<string>doctype.
        system}"${endElement}`;
    }
    return doctypeElement;
}

isolated function initWritableCharacterChannel(WritableCharacterChannel characterChannel, 
                                               WritableByteChannel byteChannel, string charset) = @java:Method {
    name: "initCharacterChannel",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterChannelUtils"
} external;

isolated function writeExtern(WritableCharacterChannel characterChannel, string content, int startOffset) returns int|
Error = @java:Method {
    name: "write",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterChannelUtils"
} external;

isolated function writeJsonExtern(WritableCharacterChannel characterChannel, json content) returns Error? = @java:Method {
    name: "writeJson",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterChannelUtils"
} external;

isolated function writeXmlExtern(WritableCharacterChannel characterChannel, xml content, string doctype) returns Error? = @java:Method {
    name: "writeXml",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterChannelUtils"
} external;

isolated function writePropertiesExtern(WritableCharacterChannel characterChannel, map<string> properties, 
                                        string comment) returns Error? = @java:Method {
    name: "writeProperties",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterChannelUtils"
} external;

isolated function closeWritableCharacterChannel(WritableCharacterChannel characterChannel) returns Error? = @java:Method {
    name: "close",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterChannelUtils"
} external;
