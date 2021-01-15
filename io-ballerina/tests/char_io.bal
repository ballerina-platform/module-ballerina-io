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

@test:Config {dependsOn: [testWriteBytes]}
function testReadCharacters() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/utf8file.txt";
    string expectedCharacters = "aaa";
    int numberOfCharacters = 3;

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.read(numberOfCharacters);
        if (result is string) {
            test:assertEquals(result, expectedCharacters, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        expectedCharacters = "bbǊ";
        result = characterChannel.read(numberOfCharacters);
        if (result is string) {
            test:assertEquals(result, expectedCharacters, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        expectedCharacters = "";
        result = characterChannel.read(numberOfCharacters);
        if (result is string) {
            test:assertEquals(result, expectedCharacters, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testReadCharacters]}
function testReadAllCharacters() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/fileThatExceeds2MB.txt";
    string result = "";
    int expectedNumberOfCharacters = 2265223;
    int fixedSize = 500;
    boolean isDone = false;

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);

        while (!isDone) {
            var readResult = characterChannel.read(fixedSize);
            if (readResult is string) {
                result = result + readResult;
            } else {
                error e = readResult;
                if (e is EofError) {
                    isDone = true;
                } else {
                    test:assertFail(msg = e.message());
                }
            }
        }
        test:assertEquals(result.length(), expectedNumberOfCharacters);

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testReadAllCharacters]}
function testReadAllCharactersFromEmptyFile() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/emptyFile.txt";
    string result = "";
    int expectedNumberOfCharacters = 0;
    int fixedSize = 500;
    boolean isDone = false;

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);

        while (!isDone) {
            var readResult = characterChannel.read(fixedSize);
            if (readResult is string) {
                result = result + readResult;
            } else {
                error e = readResult;
                if (e is EofError) {
                    isDone = true;
                } else {
                    test:assertFail(msg = e.message());
                }
            }
        }
        test:assertEquals(result.length(), expectedNumberOfCharacters);

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testReadAllCharactersFromEmptyFile]}
function testWriteCharacters() {
    string filePath = TEMP_DIR + "characterFile.txt";
    string content = "The quick brown fox jumps over the lazy dog";

    var byteChannel = openWritableFile(filePath);
    if (byteChannel is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.write(content, 0);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testWriteCharacters]}
function testAppendCharacters() {
    string filePath = TEMP_DIR + "appendCharacterFile.txt";
    string initialContent = "Hi, I'm the initial content. ";
    string appendingContent = "Hi, I was appended later. ";

    var byteChannel = openWritableFile(filePath, true);
    if (byteChannel is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.write(initialContent, 0);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }

    var byteChannelToAppend = openWritableFile(filePath, true);
    if (byteChannelToAppend is WritableByteChannel) {
        WritableCharacterChannel characterChannelToAppend = new WritableCharacterChannel(byteChannelToAppend, 
        DEFAULT_ENCODING);
        var result = characterChannelToAppend.write(initialContent, 0);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        result = characterChannelToAppend.write(initialContent, 0);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannelToAppend.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannelToAppend.message());
    }
}

@test:Config {}
function testWriteJson() {
    string filePath = TEMP_DIR + "jsonCharsFile1.json";
    json content = {"web-app": {"servlet-mapping": {
                "cofaxCDS": "/",
                "cofaxEmail": "/cofaxutil/aemail/*",
                "cofaxAdmin": "/admin/*",
                "fileServlet": "/static/*",
                "cofaxTools": ["/tools1/*", "/tools2/*", "/tools3/*"]
            }}};

    var byteChannel = openWritableFile(filePath);
    if (byteChannel is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.writeJson(content);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testWriteJson]}
function testReadJson() {
    string filePath = TEMP_DIR + "jsonCharsFile1.json";
    json expectedJson = {"web-app": {"servlet-mapping": {
                "cofaxCDS": "/",
                "cofaxEmail": "/cofaxutil/aemail/*",
                "cofaxAdmin": "/admin/*",
                "fileServlet": "/static/*",
                "cofaxTools": ["/tools1/*", "/tools2/*", "/tools3/*"]
            }}};

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.readJson();
        if (result is json) {
            test:assertEquals(result, expectedJson, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
function testFileWriteJson() {
    string filePath = TEMP_DIR + "jsonCharsFile2.json";
    json content = {"web-app": {"servlet-mapping": {
                "cofaxCDS": "/",
                "cofaxEmail": "/cofaxutil/aemail/*",
                "cofaxAdmin": "/admin/*",
                "fileServlet": "/static/*",
                "cofaxTools": ["/tools1/*", "/tools2/*", "/tools3/*"]
            }}};

    var result = fileWriteJson(filePath, content);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileWriteJson]}
function testFileReadJson() {
    string filePath = TEMP_DIR + "jsonCharsFile2.json";
    json expectedJson = {"web-app": {"servlet-mapping": {
                "cofaxCDS": "/",
                "cofaxEmail": "/cofaxutil/aemail/*",
                "cofaxAdmin": "/admin/*",
                "fileServlet": "/static/*",
                "cofaxTools": ["/tools1/*", "/tools2/*", "/tools3/*"]
            }}};

    var result = fileReadJson(filePath);
    if (result is json) {
        test:assertEquals(result, expectedJson, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
function testWriteHigherUnicodeJson() {
    string filePath = TEMP_DIR + "higherUniJsonCharsFile.json";
    createDirectoryExtern(TEMP_DIR);
    json content = {"loop": "É"};

    var byteChannel = openWritableFile(filePath);
    if (byteChannel is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.writeJson(content);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testWriteHigherUnicodeJson]}
function testReadHigherUnicodeJson() {
    string filePath = TEMP_DIR + "higherUniJsonCharsFile.json";
    createDirectoryExtern(TEMP_DIR);
    json expectedJson = {"loop": "É"};
    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.readJson();
        if (result is json) {
            test:assertEquals(result, expectedJson, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
function testWriteXml() {
    string filePath = TEMP_DIR + "xmlCharsFile1.xml";
    createDirectoryExtern(TEMP_DIR);
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
    var byteChannel = openWritableFile(filePath);
    if (byteChannel is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.writeXml(content);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testWriteXml]}
function testReadXml() {
    string filePath = TEMP_DIR + "xmlCharsFile1.xml";
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
    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.readXml();
        if (result is xml) {
            test:assertEquals(result, expectedXml, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
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

@test:Config {dependsOn: [testFileWriteXml]}
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
    if (result is xml) {
        test:assertEquals(result, expectedXml, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
function testReadAvailableProperty() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";
    string expectedProperty = "John Smith";
    string key = "name";

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.readProperty(key);
        if (result is json) {
            test:assertEquals(result, expectedProperty, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testReadAvailableProperty]}
function testAllProperties() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.readAllProperties();
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testAllProperties]}
function testReadUnavailableProperty() {
    string filePath = RESOURCES_BASE_PATH + "datafiles/io/text/person.properties";
    string defaultValue = "Default";

    var byteChannel = openReadableFile(filePath);
    if (byteChannel is ReadableByteChannel) {
        ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.readProperty("key", defaultValue);
        if (result is json) {
            test:assertEquals(result, defaultValue, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {dependsOn: [testReadUnavailableProperty]}
function testWriteProperties() {
    string filePath = TEMP_DIR + "/tmp_person.properties";
    map<string> properties = {
        name: "Anna Johnson",
        age: "25",
        occupation: "Banker"
    };
    var byteChannel = openWritableFile(filePath);
    if (byteChannel is WritableByteChannel) {
        WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
        var result = characterChannel.writeProperties(properties, "");
        if (result is Error) {
            test:assertFail(msg = result.message());
        }

        var closeResult = characterChannel.close();
        if (closeResult is Error) {
            test:assertFail(msg = closeResult.message());
        }
    } else {
        test:assertFail(msg = byteChannel.message());
    }
}

@test:Config {}
function testFileWriteString() {
    string filePath = TEMP_DIR + "stringContent1.txt";
    string content = "The Big Bang Theory";
    var result = fileWriteString(filePath, content);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileWriteString]}
function testFileReadString() {
    string filePath = TEMP_DIR + "stringContent1.txt";
    string expectedString = "The Big Bang Theory";
    var result = fileReadString(filePath);
    if (result is string) {
        test:assertEquals(result, expectedString);
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
function testFileWriteLines() {
    string filePath = TEMP_DIR + "stringContentAsLines1.txt";
    string[] content = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    var result = fileWriteLines(filePath, content);
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileWriteLines]}
function testFileReadLines() {
    string filePath = TEMP_DIR + "stringContentAsLines1.txt";
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    var result = fileReadLines(filePath);
    if (result is string[]) {
        int i = 0;
        foreach string line in result {
            test:assertEquals(line, expectedLines[i]);
            i += 1;
        }
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
function testFileWriteLinesFromStream() {
    string filePath = TEMP_DIR + "stringContentAsLines2.txt";
    string[] content = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    var result = fileWriteLinesFromStream(filePath, content.toStream());
    if (result is Error) {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: [testFileWriteLinesFromStream]}
function testFileReadLinesAsStream() {
    string filePath = TEMP_DIR + "stringContentAsLines2.txt";
    string[] expectedLines = ["The Big Bang Theory", "F.R.I.E.N.D.S", "Game of Thrones", "LOST"];
    var result = fileReadLinesAsStream(filePath);
    if (result is stream<string>) {
        int i = 0;
        _ = result.forEach(function(string val) {
                               test:assertEquals(val, expectedLines[i]);
                               i += 1;
                           });
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {}
function testFileChannelWriteStringWithByteChannel() {
    string filePath = TEMP_DIR + "stringContent2.txt";
    string content = "The Big Bang Theory";

    var fileOpenResult = openWritableFile(filePath);
    if (fileOpenResult is WritableByteChannel) {
        var result = channelWriteString(fileOpenResult, content);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }
    } else {
        test:assertFail(msg = fileOpenResult.message());
    }
}

@test:Config {dependsOn: [testFileChannelWriteStringWithByteChannel]}
function testFileChannelReadStringWithByteChannel() {
    string filePath = TEMP_DIR + "stringContent2.txt";
    string expectedString = "The Big Bang Theory";

    var fileOpenResult = openReadableFile(filePath);
    if (fileOpenResult is ReadableByteChannel) {
        var result = channelReadString(fileOpenResult);
        if (result is string) {
            test:assertEquals(result, expectedString, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }
    } else {
        test:assertFail(msg = fileOpenResult.message());
    }
}

@test:Config {}
function testFileChannelWriteLinesWithByteChannel() {
    string filePath = TEMP_DIR + "stringContent2.txt";
    string content = "The Big Bang Theory";

    var fileOpenResult = openWritableFile(filePath);
    if (fileOpenResult is WritableByteChannel) {
        var result = channelWriteString(fileOpenResult, content);
        if (result is Error) {
            test:assertFail(msg = result.message());
        }
    } else {
        test:assertFail(msg = fileOpenResult.message());
    }
}

@test:Config {dependsOn: [testFileChannelWriteLinesWithByteChannel]}
function testFileChannelReadLinesWithByteChannel() {
    string filePath = TEMP_DIR + "stringContent2.txt";
    string expectedString = "The Big Bang Theory";

    var fileOpenResult = openReadableFile(filePath);
    if (fileOpenResult is ReadableByteChannel) {
        var result = channelReadString(fileOpenResult);
        if (result is string) {
            test:assertEquals(result, expectedString, msg = "Found unexpected output");
        } else {
            test:assertFail(msg = result.message());
        }
    } else {
        test:assertFail(msg = fileOpenResult.message());
    }
}
