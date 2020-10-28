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

@test:Config {dependsOn: ["testWriteRecords"]}
function testStrToJsonConvert() {
    string content = "{\n" + "  \"test\": { \"name\": \"Foo\" }\n" + "}";
    json expectedJson = {test: {name: "Foo"}};
    var result = getJson(content, "UTF-8");
    if (result is json) {
        test:assertEquals(result, expectedJson, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = result.message());
    }
}

@test:Config {dependsOn: ["testStrToJsonConvert"]}
function testXmlToJsonConvert() {
    string content = "<test>" + "<name>Foo</name>" + "</test>";
    xml expectedXml = xml `<test><name>Foo</name></test>`;

    var result = getXml(content, "UTF-8");
    if (result is xml) {
        test:assertEquals(result, expectedXml, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = (result is error) ? result.message() : "Unexpected error");
    }
}

function getJson(string content, string encoding) returns @tainted json|error {
    StringReader reader = new StringReader(content, encoding);
    var readResult = reader.readJson();
    var closeResult = reader.close();
    if (readResult is json) {
        return readResult;
    } else {
        return readResult;
    }
}

function getXml(string content, string encoding) returns @tainted xml?|error {
    StringReader reader = new StringReader(content, encoding);
    var readResult = reader.readXml();
    var closeResult = reader.close();
    if (readResult is xml?) {
        return readResult;
    } else {
        return readResult;
    }
}
