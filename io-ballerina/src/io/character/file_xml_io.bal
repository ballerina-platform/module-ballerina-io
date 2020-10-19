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

# Read file content as an XML.
# ```ballerina
# xml|io:Error content = io:fileReadXml("./resources/myfile.xml");
# ```
# + path - XML file path
# + return - Either a XML or `io:Error`
public function fileReadXml(@untainted string path) returns @tainted readonly & xml|Error {
	var fileOpenResult = openReadableFile(path);
	if (fileOpenResult is ReadableByteChannel) {
		ReadableCharacterChannel readableCharacterChannel = new (fileOpenResult, DEFAULT_ENCODING);
        var fileReadResult = readableCharacterChannel.readXml();
        var closeResult = fileOpenResult.close();
        closeResult = readableCharacterChannel.close();
        if (fileReadResult is xml) {
            return <xml & readonly> fileReadResult.cloneReadOnly();
        } else {
            return fileReadResult;
        }
	} else {
	    return fileOpenResult;
	}
}

# Write XML content to a file.
# ```ballerina
# xml content = xml `<book>The Lost World</book>`;
# io:Error? result = io:fileWriteXml("./resources/myfile.xml", content);
# ```
# + path - XML file path
# + content - XML content to write
# + return - `io:Error` or else `()`
public function fileWriteXml(@untainted string path, xml content) returns Error? {
    var fileOpenResult = openWritableFile(path);
    if (fileOpenResult is WritableByteChannel) {
        WritableCharacterChannel writableCharacterChannel = new (fileOpenResult, DEFAULT_ENCODING);
        var fileWriteResult = writableCharacterChannel.writeXml(content);
        var closeResult = fileOpenResult.close();
        if (closeResult is Error) {
            return closeResult;
        }
        closeResult = writableCharacterChannel.close();
        if (closeResult is Error) {
            return closeResult;
        }
        return fileWriteResult;
    } else {
        return fileOpenResult;
    }
}
