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

# Read file content as a JSON.
# ```ballerina
# json|io:Error content = io:fileReadJson("./resources/myfile.json");
# ```
# + path - JSON file path
# + return - Either a JSON or `io:Error`
public function fileReadJson(@untainted string path) returns @tainted readonly & json|Error {
	var fileOpenResult = openReadableFile(path);
	if (fileOpenResult is ReadableByteChannel) {
		ReadableCharacterChannel readableCharacterChannel = new (fileOpenResult, DEFAULT_ENCODING);
        var fileReadResult = readableCharacterChannel.readJson();
        var closeResult = fileOpenResult.close();
        if (closeResult is Error) {
            return closeResult;
        }
        closeResult = readableCharacterChannel.close();
        if (closeResult is Error) {
            return closeResult;
        }
        if (fileReadResult is json) {
            return <json & readonly> fileReadResult.cloneReadOnly();
        } else {
            return fileReadResult;
        }
        
	} else {
	    return fileOpenResult;
	}
}

# Write a JSON to a file.
# ```ballerina
# json content = {"name": "Anne", "age": 30};
# io:Error? content = io:fileWriteJson("./resources/myfile.json");
# ```
# + path - JSON file path
# + content - JSON content to write
# + return - `io:Error` or else `()`
public function fileWriteJson(@untainted string path, json content) returns @tainted Error? {
    var fileOpenResult = openWritableFile(path);
    if (fileOpenResult is WritableByteChannel) {
        WritableCharacterChannel writableCharacterChannel = new (fileOpenResult, DEFAULT_ENCODING);
        var fileWriteResult = writableCharacterChannel.writeJson(content);
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
