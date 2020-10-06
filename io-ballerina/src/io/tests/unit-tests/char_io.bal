// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

ReadableCharacterChannel? rch = ();
WritableCharacterChannel? wch = ();
WritableCharacterChannel? wca = ();

@test:Config {
    dependsOn: ["testWriteBytes"]
}
function testReadCharacters() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/utf8file.txt";
    Error? initResult = initReadableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    int numberOfCharactersToRead = 3;
    string expectedCharacters = "aaa";
    var result = readCharacters(numberOfCharactersToRead);
    if (result is string) {
        test:assertEquals(result, expectedCharacters, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }

    expectedCharacters = "bbǊ";
    result = readCharacters(numberOfCharactersToRead);
    if (result is string) {
        test:assertEquals(result, expectedCharacters, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }

    expectedCharacters = "";
    result = readCharacters(numberOfCharactersToRead);
    if (result is string) {
        test:assertEquals(result, expectedCharacters, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }
    closeReadableCharChannel();
}

@test:Config {
    dependsOn: ["testReadCharacters"]
}
function testReadAllCharacters() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/fileThatExceeds2MB.txt";
    Error? initResult = initReadableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    int expectedNumberOfCharacters = 2265223;
    var result = readAllCharacters();
    if (result is string) {
        test:assertEquals(result.length(), expectedNumberOfCharacters, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }
    closeReadableCharChannel();
}

@test:Config {
    dependsOn: ["testReadAllCharacters"]
}
function testReadAllCharactersFromEmptyFile() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/emptyFile.txt";
    Error? initResult = initReadableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    int expectedNumberOfCharacters = 0;
    var result = readAllCharacters();
    if (result is string) {
        test:assertEquals(result.length(), expectedNumberOfCharacters, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Unexpected result");
    }
    closeReadableCharChannel();
}

@test:Config {
    dependsOn: ["testReadAllCharactersFromEmptyFile"]
}
function testWriteCharacters() {
    string filePath = TEMP_DIR + "characterFile.txt";
    string content = "The quick brown fox jumps over the lazy dog";
    Error? initResult = initWritableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    var result = writeCharacters(content, 0);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
    closeWritableBytesChannel();
}

@test:Config {
    dependsOn: ["testWriteCharacters"]
}
function testAppendCharacters() {
    string filePath = TEMP_DIR + "appendCharacterFile.txt";
    string initialContent = "Hi, I'm the initial content. ";
    string appendingContent = "Hi, I was appended later. ";
    Error? initResult = initWritableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    var result = writeCharacters(initialContent, 0);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }

    initResult = initWritableChannelToAppend(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    result = appendCharacters(appendingContent, 0);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
    closeWritableCharChannel();
    closeWritableCharChannelToAppend();
}

@test:Config {
    dependsOn: ["testAppendCharacters"]
}
function testWriteJson() {
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
    Error? initResult = initWritableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    writeJson(content);
    closeWritableBytesChannel();
}

@test:Config {
    dependsOn: ["testWriteJson"]
}
function testReadJson() {
    string filePath = TEMP_DIR + "jsonCharsFile1.json";
    Error? initResult = initReadableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

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
    var result = readJson();
    if (result is json) {
        test:assertEquals(result, expectedJson, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }

    closeReadableCharChannel();
}

@test:Config {
    dependsOn: ["testReadJson"]
}
function testFileWriteJson() {
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
    var result = fileWriteJson(filePath, content);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {
    dependsOn: ["testFileWriteJson"]
}
function testFileReadJson() {
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
    var result = fileReadJson(filePath);
    if (result is json & readonly) {
        test:assertEquals(result, expectedJson, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {
    dependsOn: ["testFileReadJson"]
}
function testWriteHigherUnicodeJson() {
    string filePath = TEMP_DIR + "higherUniJsonCharsFile.json";
    Error? initResult = initWritableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    writeJsonWithHigherUnicodeRange();
    closeWritableBytesChannel();
}

@test:Config {
    dependsOn: ["testWriteHigherUnicodeJson"]
}
function testReadHigherUnicodeJson() {
    string filePath = TEMP_DIR + "higherUniJsonCharsFile.json";
    Error? initResult = initReadableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    json expectedJson = {
        "loop": "É"
    };
    var result = readJson();
    if (result is json) {
        test:assertEquals(result, expectedJson, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }

    closeReadableCharChannel();
}

@test:Config {
    dependsOn: ["testReadHigherUnicodeJson"]
}
function testWriteXml() {
    string filePath = TEMP_DIR + "xmlCharsFile1.xml";
    Error? initResult = initWritableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    xml content = xml `<CATALOG>
                       <CD>
                           <TITLE>Empire Burlesque</TITLE>
                           <ARTIST>Bob Dylan</ARTIST>
                           <COUNTRY>USA</COUNTRY>
                           <COMPANY>Columbia</COMPANY>
                           <PRICE>10.90</PRICE>
                           <YEAR>1985</YEAR>
                       </CD>
                       <CD>
                           <TITLE>Hide your heart</TITLE>
                           <ARTIST>Bonnie Tyler</ARTIST>
                           <COUNTRY>UK</COUNTRY>
                           <COMPANY>CBS Records</COMPANY>
                           <PRICE>9.90</PRICE>
                           <YEAR>1988</YEAR>
                       </CD>
                       <CD>
                           <TITLE>Greatest Hits</TITLE>
                           <ARTIST>Dolly Parton</ARTIST>
                           <COUNTRY>USA</COUNTRY>
                           <COMPANY>RCA</COMPANY>
                           <PRICE>9.90</PRICE>
                           <YEAR>1982</YEAR>
                       </CD>
                   </CATALOG>`;
    writeXml(content);
    closeWritableBytesChannel();
}

@test:Config {
    dependsOn: ["testWriteXml"]
}
function testReadXml() {
    string filePath = TEMP_DIR + "xmlCharsFile1.xml";
    Error? initResult = initReadableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    xml expectedXml = xml `<CATALOG>
                       <CD>
                           <TITLE>Empire Burlesque</TITLE>
                           <ARTIST>Bob Dylan</ARTIST>
                           <COUNTRY>USA</COUNTRY>
                           <COMPANY>Columbia</COMPANY>
                           <PRICE>10.90</PRICE>
                           <YEAR>1985</YEAR>
                       </CD>
                       <CD>
                           <TITLE>Hide your heart</TITLE>
                           <ARTIST>Bonnie Tyler</ARTIST>
                           <COUNTRY>UK</COUNTRY>
                           <COMPANY>CBS Records</COMPANY>
                           <PRICE>9.90</PRICE>
                           <YEAR>1988</YEAR>
                       </CD>
                       <CD>
                           <TITLE>Greatest Hits</TITLE>
                           <ARTIST>Dolly Parton</ARTIST>
                           <COUNTRY>USA</COUNTRY>
                           <COMPANY>RCA</COMPANY>
                           <PRICE>9.90</PRICE>
                           <YEAR>1982</YEAR>
                       </CD>
                   </CATALOG>`;
    var result = readXml();
    if (result is xml) {
        test:assertEquals(result, expectedXml, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }

    closeReadableCharChannel();
}

@test:Config {
    dependsOn: ["testReadXml"]
}
function testFileWriteXml() {
    string filePath = TEMP_DIR + "xmlCharsFile2.xml";
    xml content = xml `<CATALOG>
                       <CD>
                           <TITLE>Empire Burlesque</TITLE>
                           <ARTIST>Bob Dylan</ARTIST>
                           <COUNTRY>USA</COUNTRY>
                           <COMPANY>Columbia</COMPANY>
                           <PRICE>10.90</PRICE>
                           <YEAR>1985</YEAR>
                       </CD>
                       <CD>
                           <TITLE>Hide your heart</TITLE>
                           <ARTIST>Bonnie Tyler</ARTIST>
                           <COUNTRY>UK</COUNTRY>
                           <COMPANY>CBS Records</COMPANY>
                           <PRICE>9.90</PRICE>
                           <YEAR>1988</YEAR>
                       </CD>
                       <CD>
                           <TITLE>Greatest Hits</TITLE>
                           <ARTIST>Dolly Parton</ARTIST>
                           <COUNTRY>USA</COUNTRY>
                           <COMPANY>RCA</COMPANY>
                           <PRICE>9.90</PRICE>
                           <YEAR>1982</YEAR>
                       </CD>
                   </CATALOG>`;
    var result = fileWriteXml(filePath, content);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {
    dependsOn: ["testFileWriteXml"]
}
function testFileReadXml() {
    string filePath = TEMP_DIR + "xmlCharsFile2.xml";
    xml expectedXml = xml `<CATALOG>
                       <CD>
                           <TITLE>Empire Burlesque</TITLE>
                           <ARTIST>Bob Dylan</ARTIST>
                           <COUNTRY>USA</COUNTRY>
                           <COMPANY>Columbia</COMPANY>
                           <PRICE>10.90</PRICE>
                           <YEAR>1985</YEAR>
                       </CD>
                       <CD>
                           <TITLE>Hide your heart</TITLE>
                           <ARTIST>Bonnie Tyler</ARTIST>
                           <COUNTRY>UK</COUNTRY>
                           <COMPANY>CBS Records</COMPANY>
                           <PRICE>9.90</PRICE>
                           <YEAR>1988</YEAR>
                       </CD>
                       <CD>
                           <TITLE>Greatest Hits</TITLE>
                           <ARTIST>Dolly Parton</ARTIST>
                           <COUNTRY>USA</COUNTRY>
                           <COMPANY>RCA</COMPANY>
                           <PRICE>9.90</PRICE>
                           <YEAR>1982</YEAR>
                       </CD>
                   </CATALOG>`;
    var result = fileReadXml(filePath);
    if (result is xml & readonly) {
        test:assertEquals(result, expectedXml, msg = "Found unexpected output");
    } else if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {
    dependsOn: ["testFileReadXml"]
}
function testReadAvailableProperty() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";
    Error? initResult = initReadableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }

    string expectedProperty = "John Smith";
    string key = "name";
    var result = readAvailableProperty(key);
    if (result is string) {
        test:assertEquals(result, expectedProperty, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = (result is error)? result.message(): "Unexpected error");
    }
    closeReadableCharChannel();
}

@test:Config {
    dependsOn: ["testReadAvailableProperty"]
}
function testAllProperties() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";
    Error? initResult = initReadableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }
    test:assertTrue(readAllProperties(), msg = "Found unexpected output");
    closeReadableCharChannel();
}

@test:Config {
    dependsOn: ["testAllProperties"]
}
function testReadUnavailableProperty() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";
    Error? initResult = initReadableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }
    test:assertTrue(readUnavailableProperty("key"), msg = "Found unexpected output");
    closeReadableCharChannel();
}

@test:Config {
    dependsOn: ["testReadUnavailableProperty"]
}
function testWriteProperties() {
    string filePath = TEMP_DIR + "/tmp_person.properties";
    Error? initResult = initWritableCharChannel(filePath, "UTF-8");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }
    test:assertTrue(writePropertiesFromMap(), msg = "Found unexpected output");
    closeWritableBytesChannel();
}

function initReadableCharChannel(string filePath, string encoding) returns Error? {
    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        rch = new ReadableCharacterChannel(byteChannel, encoding);
    } else {
        return byteChannel;
    }
}

function initWritableCharChannel(string filePath, string encoding) returns Error? {
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    wch = new WritableCharacterChannel(byteChannel, encoding);
}

function initWritableChannelToAppend(string filePath, string encoding) returns Error? {
    WritableByteChannel byteChannel = check openWritableFile(filePath, true);
    wca = new WritableCharacterChannel(byteChannel, encoding);
}

function readCharacters(int numberOfCharacters) returns @tainted string|error {
    var rCha = rch;
    if(rCha is ReadableCharacterChannel){
        var result = rCha.read(numberOfCharacters);
        if (result is string) {
            return result;
        } else {
            return result;
        }
    }
    error e = error("Character channel not initialized properly");
    return e;
}

function readAllCharacters() returns @tainted string|Error? {
    int fixedSize = 500;
    boolean isDone = false;
    string result = "";
    while (!isDone) {
        var readResult = readCharacters(fixedSize);
        if (readResult is string) {
            result = result + readResult;
        } else {
            error e = readResult;
            if (e is EofError) {
                isDone = true;
            } else {
                GenericError readError = GenericError("Error while reading the content", readResult);
                return readError;
            }
        }
    }
    return result;
}

function writeCharacters(string content, int startOffset) returns int|Error? {
    var wCha = wch;
    if(wCha is WritableCharacterChannel){
        var result = wCha.write(content, startOffset);
        return result;
    }
    // error e = error("Character channel not initialized properly");
    GenericError e = GenericError("Character channel not initialized properly");
    return e;
}

function appendCharacters(string content, int startOffset) returns int|Error? {
    var wCha = wca;
    if(wCha is WritableCharacterChannel){
        var result = wCha.write(content, startOffset);
        return result;
    }
    GenericError e = GenericError("Character channel not initialized properly");
    return e;
}

function readJson() returns @tainted json|error {
    var rCha = rch;
    if(rCha is ReadableCharacterChannel){
        var result = rCha.readJson();
        return result;
    }
    return ();
}

function readXml() returns @tainted xml|error {
    var rCha = rch;
    if(rCha is ReadableCharacterChannel){
        var result = rCha.readXml();
        return result;
    }
    GenericError e = GenericError("Character channel not initialized properly");
    return e;
}

function readAvailableProperty(string key) returns @tainted string?|error {
    var rCha = rch;
    if(rCha is ReadableCharacterChannel) {
        var result = rCha.readProperty(key);
        return result;
    }
    GenericError e = GenericError("Character channel not initialized properly");
    return e;
}

function readAllProperties() returns boolean {
    var rCha = rch;
    if(rCha is ReadableCharacterChannel) {
        var results = rCha.readAllProperties();
        if (results is map<string>) {
            return true;
        }
    }
    return false;
}

function readUnavailableProperty(string key) returns boolean {
    var rCha = rch;
    if(rCha is ReadableCharacterChannel) {
        string defaultValue = "Default";
        var results = rCha.readProperty(key, defaultValue);
        if (results is string) {
            if (results == defaultValue) {
                return true;
            }
        }
    }
    return false;
}

function writePropertiesFromMap() returns boolean {
    var wCha = wch;
    if (wCha is WritableCharacterChannel) {
        map<string> properties = {
            name: "Anna Johnson",
            age: "25",
            occupation: "Banker"
        };
        var writeResults = wCha.writeProperties(properties, "Comment");
        if !(writeResults is Error) {
            return true;
        }
    }
    return false;
}

function writeJson(json content) {
    var wCha = wch;
    if(wCha is WritableCharacterChannel){
        var result = wCha.writeJson(content);
    }
}

function writeJsonWithHigherUnicodeRange() {
    json content = {
        "loop": "É"
    };
    var wCha = wch;
    if(wCha is WritableCharacterChannel){
        var result = wCha.writeJson(content);
        if (result is error) {
            panic <error>result;
        }
    }
}

function writeXml(xml content) {
    var wCha = wch;
    if(wCha is WritableCharacterChannel){
        var result = wCha.writeXml(content);
    }
}

function closeReadableCharChannel() {
    var rCha = rch;
    if(rCha is ReadableCharacterChannel){
        var err = rCha.close();
    }
}

function closeWritableCharChannel() {
    var wCha = wch;
    if(wCha is WritableCharacterChannel){
        var err = wCha.close();
    }
}

function closeWritableCharChannelToAppend() {
    var wCha = wch;
    if(wCha is WritableCharacterChannel){
        var err = wCha.close();
    }
}
