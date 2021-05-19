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
import ballerina/jballerina.java;

@test:BeforeEach
isolated function beforePrint() {
    resetOutputStream();
    initOutputStream();
}

@test:Config {}
isolated function testPrintString() {
    string s = "A Greeting from Ballerina...!!!";
    print(s);
    test:assertEquals(readOutputStream(), s);
}

@test:Config {dependsOn: [testPrintString]}
isolated function testPrintlnString() {
    string s = "Hello World...!!!";
    string expectedOutput = s + "\n";
    println(s);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnString]}
isolated function testPrintInt() {
    int v = 1000;
    print(v);
    test:assertEquals(readOutputStream(), "1000");
}

@test:Config {dependsOn: [testPrintInt]}
isolated function testPrintlnInt() {
    int v = 1;
    println(v);
    test:assertEquals(readOutputStream(), "1\n");
}

@test:Config {dependsOn: [testPrintlnInt]}
isolated function testPrintFloat() {
    float v = 1000;
    print(v);
    test:assertEquals(readOutputStream(), "1000.0");
}

@test:Config {dependsOn: [testPrintFloat]}
isolated function testPrintlnFloat() {
    float v = 1;
    println(v);
    test:assertEquals(readOutputStream(), "1.0\n");
}

@test:Config {dependsOn: [testPrintlnFloat]}
isolated function testPrintBoolean() {
    boolean b = false;
    print(b);
    test:assertEquals(readOutputStream(), "false");
}

@test:Config {dependsOn: [testPrintBoolean]}
isolated function testPrintlnBoolean() {
    boolean b = true;
    println(b);
    test:assertEquals(readOutputStream(), "true\n");
}

@test:Config {dependsOn: [testPrintlnBoolean]}
isolated function testPrintConnector() {
    Foo f = new Foo();
    print(f);
    test:assertEquals(readOutputStream(), "object io:Foo");
}

@test:Config {dependsOn: [testPrintConnector]}
isolated function testPrintlnConnector() {
    Foo f = new Foo();
    println(f);
    test:assertEquals(readOutputStream(), "object io:Foo\n");

}

@test:Config {dependsOn: [testPrintlnConnector]}
isolated function testPrintFunctionPointer() {
    function (int, int) returns (int) addFunction = func1;
    print(addFunction);
    test:assertEquals(readOutputStream(), "function isolated function (int,int) returns (int)");
}

@test:Config {dependsOn: [testPrintFunctionPointer]}
isolated function testPrintlnFunctionPointer() {
    function (int, int) returns (int) addFunction = func1;
    println(addFunction);
    test:assertEquals(readOutputStream(), "function isolated function (int,int) returns (int)\n");
}

@test:Config {dependsOn: [testPrintlnFunctionPointer]}
isolated function testPrintVarargs() {
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string s3 = "Adios";
    string expectedOutput = s1 + s2 + s3;
    print(s1, s2, s3);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintVarargs]}
isolated function testPrintMixVarargs() {
    string s1 = "Hello World...!!!";
    int i1 = 123456789;
    float f1 = 123456789.123456789;
    boolean b1 = true;
    string expectedOutput = "Hello World...!!!1234567891.2345678912345679E8true";
    print(s1, i1, f1, b1);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintMixVarargs]}
isolated function testPrintlnVarargs() {
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string s3 = "Adios";
    string expectedOutput = s1 + s2 + s3 + "\n";
    println(s1, s2, s3);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnVarargs]}
isolated function testPrintNewline() {
    string expectedOutput = "hello\n";
    print("hello\n");
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintNewline]}
isolated function testPrintRawTemplateWithTrue() {
    boolean val = true;
    string expectedOutput = "The respective boolean value is true";
    print(`The respective boolean value is ${val}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintRawTemplateWithTrue]}
isolated function testPrintRawTemplateWithFalse() {
    boolean val = false;
    string expectedOutput = "The respective boolean value is false";
    print(`The respective boolean ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintRawTemplateWithFalse]}
isolated function testPrintRawTemplateWithInt() {
    int val = 1050;
    string expectedOutput = "The respective int value is 1050";
    print(`The respective int ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintRawTemplateWithInt]}
isolated function testPrintRawTemplateWithDecimal() {
    decimal val = 1050.0967;
    string expectedOutput = "The respective decimal value is 1050.0967";
    print(`The respective decimal ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintRawTemplateWithDecimal]}
isolated function testPrintRawTemplateWithString() {
    string val = "My String";
    string expectedOutput = "The respective string value is My String";
    print(`The respective string ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintRawTemplateWithString]}
isolated function testPrintRawTemplateWithStringAndQuotes() {
    string val = "My String";
    string expectedOutput = "The respective string value is 'My String'";
    print(`The respective string ${`value is '${val}'`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintRawTemplateWithStringAndQuotes]}
isolated function testPrintRawTemplateNested() {
    string s1 = "S1";
    string s2 = "S2";
    string s3 = "S3";
    string s4 = "S4";
    string s5 = "S5";
    string expectedOutput = "string 01: S1; string 02: S2; string 03: S3; string 04: S4; string 05: S5";

    print(`${`${`${`${`string 01: ${s1}`}; string 02: ${s2}`}; string 03: ${s3}`}; string 04: ${s4}`}; string 05: ${s5}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintRawTemplateNested]}
isolated function testPrintRawTemplateMultiple() {
    string name1 = "James";
    string name2 = "Lily";
    string expectedOutput = "Hello James!!!. After long time. Why Lily didn't come?";
    print(`Hello ${name1}!!!.`, " ", "After long time.", " ", `Why ${name2} didn't come?`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintRawTemplateMultiple]}
isolated function testPrintErrorMessage() {
    error e = error("sample error");
    string expectedOutput = "it's an error: sample error";
    print(`it's an error: ${e.message()}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintErrorMessage]}
isolated function testPrintErrorInTemplate() {
    error e = error("sample error");
    string expectedOutput = "it's an error: error(\"sample error\")";
    print(`it's an error: ${e}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintErrorInTemplate]}
isolated function testPrintError() {
    error e = error("sample error");
    string expectedOutput = "error(\"sample error\")";
    print(e);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintError]}
isolated function testPrintNil() {
    print(());
    test:assertEquals(readOutputStream(), "");
}

@test:Config {dependsOn: [testPrintNil]}
isolated function testPrintlnRawTemplateWithTrue() {
    boolean val = true;
    string expectedOutput = "The respective boolean value is true\n";
    println(`The respective boolean value is ${val}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnRawTemplateWithTrue]}
isolated function testPrintlnRawTemplateWithFalse() {
    boolean val = false;
    string expectedOutput = "The respective boolean value is false\n";
    println(`The respective boolean ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnRawTemplateWithFalse]}
isolated function testPrintlnRawTemplateWithInt() {
    int val = 1050;
    string expectedOutput = "The respective int value is 1050\n";
    println(`The respective int ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnRawTemplateWithInt]}
isolated function testPrintlnRawTemplateWithDecimal() {
    decimal val = 1050.0967;
    string expectedOutput = "The respective decimal value is 1050.0967\n";
    println(`The respective decimal ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnRawTemplateWithDecimal]}
isolated function testPrintlnRawTemplateWithString() {
    string val = "My String";
    string expectedOutput = "The respective string value is My String\n";
    println(`The respective string ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnRawTemplateWithString]}
isolated function testPrintlnRawTemplateWithStringAndQuotes() {
    string val = "My String";
    string expectedOutput = "The respective string value is 'My String'\n";
    println(`The respective string ${`value is '${val}'`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnRawTemplateWithStringAndQuotes]}
isolated function testPrintlnRawTemplateNested() {
    string s1 = "S1";
    string s2 = "S2";
    string s3 = "S3";
    string s4 = "S4";
    string s5 = "S5";
    string expectedOutput = "string 01: S1; string 02: S2; string 03: S3; string 04: S4; string 05: S5\n";
    println(
    `${`${`${`${`string 01: ${s1}`}; string 02: ${s2}`}; string 03: ${s3}`}; string 04: ${s4}`}; string 05: ${s5}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnRawTemplateNested]}
isolated function testPrintlnRawTemplateMultiple() {
    string name1 = "James";
    string name2 = "Lily";
    string expectedOutput = "Hello James!!!. After long time. Why Lily didn't come?\n";
    println(`Hello ${name1}!!!.`, " ", "After long time.", " ", `Why ${name2} didn't come?`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintRawTemplateMultiple]}
isolated function testPrintlnErrorMessage() {
    error e = error("sample error");
    string expectedOutput = "it's an error: sample error\n";
    println(`it's an error: ${e.message()}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnErrorMessage]}
isolated function testPrintlnErrorInTemplate() {
    error e = error("sample error");
    string expectedOutput = "it's an error: error(\"sample error\")\n";
    println(`it's an error: ${e}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnErrorInTemplate]}
isolated function testPrintlnError() {
    error e = error("sample error");
    string expectedOutput = "error(\"sample error\")\n";
    println(e);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnError]}
isolated function testPrintlnNil() {
    println(());
    test:assertEquals(readOutputStream(), "\n");
}

isolated function func1(int a, int b) returns (int) {
    int c = a + b;
    return c;
}

class Foo {
    isolated function bar() returns (int) {
        return 5;
    }
}

public isolated function initOutputStream() = @java:Method {
    name: "initOutputStream",
    'class: "org.ballerinalang.stdlib.io.testutils.PrintTestUtils"
} external;

public isolated function readOutputStream() returns string = @java:Method {
    name: "readOutputStream",
    'class: "org.ballerinalang.stdlib.io.testutils.PrintTestUtils"
} external;

public isolated function resetOutputStream() = @java:Method {
    name: "resetOutputStream",
    'class: "org.ballerinalang.stdlib.io.testutils.PrintTestUtils"
} external;
