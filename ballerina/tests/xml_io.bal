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
import ballerina/lang.'string as langstring;

@test:Config {}
isolated function testWriteXml() returns Error? {
    string filePath = TEMP_DIR + "xmlCharsFile1.xml";
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
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel characterChannel = new WritableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    check characterChannel.writeXml(content);
    check characterChannel.close();
}

@test:Config {dependsOn: [testWriteXml]}
isolated function testReadXml() returns Error? {
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
    ReadableByteChannel byteChannel = check openReadableFile(filePath);
    ReadableCharacterChannel characterChannel = new ReadableCharacterChannel(byteChannel, DEFAULT_ENCODING);
    xml result = check characterChannel.readXml();
    test:assertEquals(result, expectedXml);
    check characterChannel.close();
}

@test:Config {}
isolated function testFileWriteXml() returns Error? {
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
    check fileWriteXml(filePath, content);
}

@test:Config {dependsOn: [testFileWriteXml]}
isolated function testFileReadXml() returns Error? {
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
    xml result = check fileReadXml(filePath);
    test:assertEquals(result, expectedXml);
}

@test:Config {}
isolated function testFileWriteXmlWithOverwrite() returns Error? {
    string filePath = TEMP_DIR + "xmlCharsFile3.xml";
    xml content1 = xml `<CATALOG>
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
    xml content2 = xml `<USER><NAME>Mary Jane</NAME><AGE>33</AGE></USER>`;
    // Check content 01
    check fileWriteXml(filePath, content1);

    xml result1 = check fileReadXml(filePath);
    test:assertEquals(result1, content1);

    // Check content 02
    check fileWriteXml(filePath, content2);

    xml result2 = check fileReadXml(filePath);
    test:assertEquals(result2, content2);
}

@test:Config {}
isolated function testFileWriteDocTypedXml() returns Error? {
    string filePath = TEMP_DIR + "xmlCharsFile4.xml";
    string resultFilePath = "tests/resources/expectedXmlCharsFile4.xml";
    string originalFilePath = "tests/resources/originalXmlContent.xml";

    xml content = check fileReadXml(originalFilePath);
    check fileWriteXml(filePath, content, doctype = {system: "Note.dtd"});
    string readResult = check fileReadString(filePath);
    string expectedResult = check fileReadString(resultFilePath);
    test:assertEquals(readResult, expectedResult);
}

@test:Config {}
isolated function testFileWriteDocTypedWithMultiRoots() returns Error? {
    string filePath = TEMP_DIR + "xmlCharsFile4.xml";
    string originalFilePath = "tests/resources/originalXmlContent.xml";

    xml content = check fileReadXml(originalFilePath);
    xml x1 = xml `<body>Don't forget me this weekend!</body>`;

    var err = fileWriteXml(filePath, xml:concat(content, x1));
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "The XML Document can only contains single root");
}

@test:Config {}
isolated function testFileWriteDocTypedWithAppend() returns Error? {
    string filePath = TEMP_DIR + "xmlCharsFile4.xml";
    string originalFilePath = "tests/resources/originalXmlContent.xml";

    xml content = check fileReadXml(originalFilePath);
    var err = fileWriteXml(filePath, content, fileWriteOption = APPEND);
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "The file append operation is not allowed for Document Entity");
}

@test:Config {}
isolated function testFileAppendDocTypedXml() returns Error? {
    string filePath = TEMP_DIR + "xmlCharsFile5.xml";
    string originalFilePath = "tests/resources/originalXmlContent.xml";
    string resultFilePath = "tests/resources/expectedXmlCharsFile5.xml";

    xml content1 = check fileReadXml(originalFilePath);
    xml content2 = xml `<body>Don't forget me this weekend!</body>`;
    check fileWriteXml(filePath, content1);
    check fileWriteXml(filePath, content2, fileWriteOption = APPEND, xmlEntityType = EXTERNAL_PARSED_ENTITY);

    string readResult = check fileReadString(filePath);
    string expectedResult = check fileReadString(resultFilePath);
    test:assertEquals(readResult, expectedResult);
}

@test:Config {}
isolated function testFileWriteDocTypedXmlWithInternalSubset() returns Error? {
    string filePath = TEMP_DIR + "xmlCharsFile6.xml";
    string originalFilePath = "tests/resources/originalXmlContent.xml";
    string resultFilePath = "tests/resources/expectedXmlCharsFile6.xml";

    xml content = check fileReadXml(originalFilePath);
    string internalSub = string `[
        <!ELEMENT note (to,from,heading,body)>
        <!ELEMENT to (#PCDATA)>
        <!ELEMENT from (#PCDATA)>
        <!ELEMENT heading (#PCDATA)>
        <!ELEMENT body (#PCDATA)>
    ]`;
    check fileWriteXml(filePath, content, doctype = {internalSubset: internalSub});

    string readResult = check fileReadString(filePath);
    string expectedResult = check fileReadString(resultFilePath);
    test:assertEquals(readResult, expectedResult);
}

@test:Config {}
isolated function testFileWriteDocTypedXmlWithPrioritizeInternalSubset() returns Error? {
    string filePath = TEMP_DIR + "xmlCharsFile6.xml";
    string originalFilePath = "tests/resources/originalXmlContent.xml";
    string resultFilePath = "tests/resources/expectedXmlCharsFile6.xml";

    xml content = check fileReadXml(originalFilePath);
    string systemId = "http://www.w3.org/TR/html4/loose.dtd";
    string internalSub = string `[
        <!ELEMENT note (to,from,heading,body)>
        <!ELEMENT to (#PCDATA)>
        <!ELEMENT from (#PCDATA)>
        <!ELEMENT heading (#PCDATA)>
        <!ELEMENT body (#PCDATA)>
    ]`;
    check fileWriteXml(filePath, content, doctype = {
        internalSubset: internalSub,
        system: systemId
    });
    string readResult = check fileReadString(filePath);
    string expectedResult = check fileReadString(resultFilePath);
    test:assertEquals(readResult, expectedResult);
}

@test:Config {}
isolated function testFileWriteDocTypedXmlWithPublicAndSystemId() returns Error? {
    string filePath = TEMP_DIR + "xmlCharsFile7.xml";
    string originalFilePath = "tests/resources/originalXmlContent.xml";
    string resultFilePath = "tests/resources/expectedXmlCharsFile7.xml";

    xml content = check fileReadXml(originalFilePath);
    string publicId = "-//W3C//DTD HTML 4.01 Transitional//EN";
    string systemId = "http://www.w3.org/TR/html4/loose.dtd";
    check fileWriteXml(filePath, content, doctype = {
        system: systemId,
        'public: publicId
    });
    string readResult = check fileReadString(filePath);
    string expectedResult = check fileReadString(resultFilePath);
    test:assertEquals(readResult, expectedResult);
}

@test:Config {}
isolated function testFileWriteDocTypedXmlWithPublic() returns Error? {
    string filePath = TEMP_DIR + "xmlCharsFile7.xml";
    string originalFilePath = "tests/resources/originalXmlContent.xml";
    string resultFilePath = "tests/resources/expectedXmlCharsFile8.xml";

    xml content = check fileReadXml(originalFilePath);
    string publicId = "-//W3C//DTD HTML 4.01 Transitional//EN";
    check fileWriteXml(filePath, content, doctype = {'public: publicId});
    string readResult = check fileReadString(filePath);
    string expectedResult = check fileReadString(resultFilePath);
    test:assertEquals(readResult, expectedResult);
}

@test:Config {}
isolated function testReadInvalidXmlFile() returns Error? {
    string filePath = TEMP_DIR + "invalidXmlFile.json";
    string content = "{ stuff:";

    check fileWriteString(filePath, content);

    xml|Error readResult = fileReadXml(filePath);
    test:assertTrue(readResult is Error);
    test:assertTrue(langstring:includes((<Error>readResult).message(),
        "failed to create xml: Unexpected character '{' (code 123) in prolog; expected '<", 0));
}
