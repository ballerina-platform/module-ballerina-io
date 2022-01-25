// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Represents a reader which will wrap string content as a channel.
public class StringReader {
    private ReadableCharacterChannel? charChannel;

    # Constructs a channel to read string.
    #
    # + content - The content, which should be written
    # + encoding - Encoding of the characters of the content
    public isolated function init(string content, string encoding = "UTF-8") {
        byte[] contentBytes = content.toBytes();
        ReadableByteChannel|Error byteChannel = createReadableChannel(contentBytes);
        if byteChannel is Error {
            self.charChannel = ();
        } else {
            self.charChannel = new ReadableCharacterChannel(byteChannel, encoding);
        }
    }

    # Reads string as JSON using the reader.
    # ```ballerina
    # io:StringReader reader = new("{\"name\": \"Alice\"}");
    # json|io:Error? person = reader.readJson();
    # ```
    #
    # + return - JSON or else an `io:Error` if any error occurred
    public isolated function readJson() returns json|Error {
        if self.charChannel is ReadableCharacterChannel {
            var result = <ReadableCharacterChannel>self.charChannel;
            return result.readJson();
        }
        return;
    }

    # Reads a string as XML using the reader.
    # ```ballerina
    # io:StringReader reader = new("<Person><Name>Alice</Name></Person>");
    # xml|io:Error? person = reader.readXml();
    # ```
    #
    # + return - XML or else an `io:Error` if any error occurred
    public isolated function readXml() returns xml|Error? {
        if self.charChannel is ReadableCharacterChannel {
            var result = <ReadableCharacterChannel>self.charChannel;
            return result.readXml();
        }
        return;
    }

    # Reads the characters from the given string.
    # ```ballerina
    # io:StringReader reader = new("Some text");
    # string|io:Error? person = reader.readChar(4);
    # ```
    #
    # + nCharacters - Number of characters to be read
    # + return - String or else an `io:Error` if any error occurred
    public isolated function readChar(int nCharacters) returns string|Error? {
        if self.charChannel is ReadableCharacterChannel {
            var result = <ReadableCharacterChannel>self.charChannel;
            return result.read(nCharacters);
        }
        return;
    }

    # Closes the string reader.
    # ```ballerina
    # io:Error? err = reader.close();
    # ```
    #
    # + return - `()` or else an `io:Error` if any error occurred
    public isolated function close() returns Error? {
        if self.charChannel is ReadableCharacterChannel {
            var result = <ReadableCharacterChannel>self.charChannel;
            return result.close();
        }
        return;
    }
}
