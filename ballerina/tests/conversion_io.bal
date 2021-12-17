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

@test:Config {}
isolated function testStrToJsonConvert() returns error? {
    string content = "{\n" + "  \"test\": { \"name\": \"Foo\" }\n" + "}";
    json expectedJson = {test: {name: "Foo"}};
    json result = check getJson(content, "UTF-8");
    test:assertEquals(result, expectedJson);
}

@test:Config {}
isolated function testXmlToJsonConvert() returns error? {
    string content = "<test>" + "<name>Foo</name>" + "</test>";
    xml expectedXml = xml `<test><name>Foo</name></test>`;
    xml? result = check getXml(content, "UTF-8");
    test:assertTrue(result is xml);
    test:assertEquals(<xml>result, expectedXml);
}

isolated function getJson(string content, string encoding) returns json|error {
    StringReader reader = new StringReader(content, encoding);
    var readResult = reader.readJson();
    check reader.close();
    return readResult;
}

isolated function getXml(string content, string encoding) returns xml?|error {
    StringReader reader = new StringReader(content, encoding);
    var readResult = reader.readXml();
    check reader.close();
    return readResult;
}
