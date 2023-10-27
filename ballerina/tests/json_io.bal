// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/test;

@test:Config {}
isolated function testWriteJson() returns Error? {
    string filePath = TEMP_DIR + "jsonCharsFile1.json";
    json content = {
        "web-app": {
            "servlet-mapping": {
                "cofaxCDS": "/",
                "cofaxEmail": "/cofaxutil/aemail/*",
                "cofaxAdmin": "/admin/*",
                "fileServlet": "/static/*",
                "cofaxTools": ["/tools1/*", "/tools2/*", "/tools3/*"]
            }
        }
    };

    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    check characterChannel.writeJson(content);
    check characterChannel.close();
}

@test:Config {dependsOn: [testWriteJson]}
isolated function testReadJson() returns Error? {
    string filePath = TEMP_DIR + "jsonCharsFile1.json";
    json expectedJson = {
        "web-app": {
            "servlet-mapping": {
                "cofaxCDS": "/",
                "cofaxEmail": "/cofaxutil/aemail/*",
                "cofaxAdmin": "/admin/*",
                "fileServlet": "/static/*",
                "cofaxTools": ["/tools1/*", "/tools2/*", "/tools3/*"]
            }
        }
    };

    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    json result = check characterChannel.readJson();
    test:assertEquals(result, expectedJson);

    check characterChannel.close();
}

@test:Config {}
isolated function testFileWriteJson() returns Error? {
    string filePath = TEMP_DIR + "jsonCharsFile2.json";
    json content = {
        "web-app": {
            "servlet-mapping": {
                "cofaxCDS": "/",
                "cofaxEmail": "/cofaxutil/aemail/*",
                "cofaxAdmin": "/admin/*",
                "fileServlet": "/static/*",
                "cofaxTools": ["/tools1/*", "/tools2/*", "/tools3/*"]
            }
        }
    };

    check fileWriteJson(filePath, content);
}

@test:Config {dependsOn: [testFileWriteJson]}
isolated function testFileReadJson() returns Error? {
    string filePath = TEMP_DIR + "jsonCharsFile2.json";
    json expectedJson = {
        "web-app": {
            "servlet-mapping": {
                "cofaxCDS": "/",
                "cofaxEmail": "/cofaxutil/aemail/*",
                "cofaxAdmin": "/admin/*",
                "fileServlet": "/static/*",
                "cofaxTools": ["/tools1/*", "/tools2/*", "/tools3/*"]
            }
        }
    };

    json result = check fileReadJson(filePath);
    test:assertEquals(result, expectedJson);
}

@test:Config {}
isolated function testFileWriteJsonWithTruncate() returns Error? {
    string filePath = TEMP_DIR + "jsonCharsFile3.json";
    json content1 = {
        "web-app": {
            "servlet-mapping": {
                "cofaxCDS": "/",
                "cofaxEmail": "/cofaxutil/aemail/*",
                "cofaxAdmin": "/admin/*",
                "fileServlet": "/static/*",
                "cofaxTools": ["/tools1/*", "/tools2/*", "/tools3/*"]
            }
        }
    };
    json content2 = {
        "userName": "Harry Thompson",
        "age": 23
    };

    // Check content 01
    check fileWriteJson(filePath, content1);

    json result1 = check fileReadJson(filePath);
    test:assertEquals(result1, content1);

    // Check content 02
    check fileWriteJson(filePath, content2);
    json result2 = check fileReadJson(filePath);
    test:assertEquals(result2, content2);
}

@test:Config {}
isolated function testWriteHigherUnicodeJson() returns Error? {
    string filePath = TEMP_DIR + "higherUniJsonCharsFile.json";
    json content = {"loop": "É"};

    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    check characterChannel.writeJson(content);
    check characterChannel.close();
}

@test:Config {dependsOn: [testWriteHigherUnicodeJson]}
isolated function testReadHigherUnicodeJson() returns Error? {
    string filePath = TEMP_DIR + "higherUniJsonCharsFile.json";
    json expectedJson = {"loop": "É"};
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    json result = check characterChannel.readJson();
    test:assertEquals(result, expectedJson);
    check characterChannel.close();
}

@test:Config {}
isolated function testReadInvalidJsonFile() returns Error? {
    string filePath = TEMP_DIR + "invalidJsonFile.json";
    string content = "{ stuff:";

    check fileWriteString(filePath, content);
    json|Error err = fileReadJson(filePath);
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "expected '\"' or '}' at line: 1 column: 3");
}
