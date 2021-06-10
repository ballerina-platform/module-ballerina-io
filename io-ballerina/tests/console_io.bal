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
    resetErrorStream();
    initOutputStream();
    initErrorStream();
}

// io:println tests

@test:Config {}
isolated function testPrintString() {
    string s = "A Greeting from Ballerina...!!!";
    print(s);
    test:assertEquals(readOutputStream(), s);
}

@test:Config {dependsOn: [testPrintString]}
isolated function testPrintInt() {
    int v = 1000;
    print(v);
    test:assertEquals(readOutputStream(), "1000");
}

@test:Config {dependsOn: [testPrintInt]}
isolated function testPrintFloat() {
    float v = 1000;
    print(v);
    test:assertEquals(readOutputStream(), "1000.0");
}

@test:Config {dependsOn: [testPrintFloat]}
isolated function testPrintBoolean() {
    boolean b = false;
    print(b);
    test:assertEquals(readOutputStream(), "false");
}

@test:Config {dependsOn: [testPrintBoolean]}
isolated function testPrintConnector() {
    Foo f = new Foo();
    print(f);
    test:assertEquals(readOutputStream(), "object io:Foo");
}

@test:Config {dependsOn: [testPrintConnector]}
isolated function testPrintFunctionPointer() {
    function (int, int) returns (int) addFunction = func1;
    print(addFunction);
    test:assertEquals(readOutputStream(), "function isolated function (int,int) returns (int)");
}

@test:Config {dependsOn: [testPrintFunctionPointer]}
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

// io:println tests

@test:Config {dependsOn: [testPrintNil]}
isolated function testPrintlnString() {
    string s = "Hello World...!!!";
    string expectedOutput = s + "\n";
    println(s);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnString]}
isolated function testPrintlnInt() {
    int v = 1;
    println(v);
    test:assertEquals(readOutputStream(), "1\n");
}

@test:Config {dependsOn: [testPrintlnInt]}
isolated function testPrintlnFloat() {
    float v = 1;
    println(v);
    test:assertEquals(readOutputStream(), "1.0\n");
}

@test:Config {dependsOn: [testPrintlnFloat]}
isolated function testPrintlnBoolean() {
    boolean b = true;
    println(b);
    test:assertEquals(readOutputStream(), "true\n");
}

@test:Config {dependsOn: [testPrintlnBoolean]}
isolated function testPrintlnConnector() {
    Foo f = new Foo();
    println(f);
    test:assertEquals(readOutputStream(), "object io:Foo\n");
}

@test:Config {dependsOn: [testPrintlnConnector]}
isolated function testPrintlnFunctionPointer() {
    function (int, int) returns (int) addFunction = func1;
    println(addFunction);
    test:assertEquals(readOutputStream(), "function isolated function (int,int) returns (int)\n");
}

@test:Config {dependsOn: [testPrintlnFunctionPointer]}
isolated function testPrintlnVarargs() {
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string s3 = "Adios";
    string expectedOutput = s1 + s2 + s3 + "\n";
    println(s1, s2, s3);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnVarargs]}
isolated function testPrintlnMixVarargs() {
    string s1 = "Hello World...!!!";
    int i1 = 123456789;
    float f1 = 123456789.123456789;
    boolean b1 = true;
    string expectedOutput = "Hello World...!!!1234567891.2345678912345679E8true\n";
    println(s1, i1, f1, b1);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnMixVarargs]}
isolated function testPrintlnNewline() {
    string expectedOutput = "hello\n\n";
    println("hello\n");
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testPrintlnNewline]}
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

// io:fprint with stdout

@test:Config {dependsOn: [testPrintlnNil]}
isolated function testFprintStringWithStdout() {
    string s = "A Greeting from Ballerina...!!!";
    fprint(stdout, s);
    test:assertEquals(readOutputStream(), s);
}

@test:Config {dependsOn: [testFprintStringWithStdout]}
isolated function testFprintIntWithStdout() {
    int v = 1000;
    fprint(stdout, v);
    test:assertEquals(readOutputStream(), "1000");
}

@test:Config {dependsOn: [testFprintIntWithStdout]}
isolated function testFprintFloatWithStdout() {
    float v = 1000;
    fprint(stdout, v);
    test:assertEquals(readOutputStream(), "1000.0");
}

@test:Config {dependsOn: [testFprintFloatWithStdout]}
isolated function testFprintBooleanWithStdout() {
    boolean b = false;
    fprint(stdout, b);
    test:assertEquals(readOutputStream(), "false");
}

@test:Config {dependsOn: [testFprintBooleanWithStdout]}
isolated function testFprintConnectorWithStdout() {
    Foo f = new Foo();
    fprint(stdout, f);
    test:assertEquals(readOutputStream(), "object io:Foo");
}

@test:Config {dependsOn: [testFprintConnectorWithStdout]}
isolated function testFprintFunctionPointerWithStdout() {
    function (int, int) returns (int) addFunction = func1;
    fprint(stdout, addFunction);
    test:assertEquals(readOutputStream(), "function isolated function (int,int) returns (int)");
}

@test:Config {dependsOn: [testFprintFunctionPointerWithStdout]}
isolated function testFprintVarargsWithStdout() {
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string s3 = "Adios";
    string expectedOutput = s1 + s2 + s3;
    fprint(stdout, s1, s2, s3);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintVarargsWithStdout]}
isolated function testFprintMixVarargsWithStdout() {
    string s1 = "Hello World...!!!";
    int i1 = 123456789;
    float f1 = 123456789.123456789;
    boolean b1 = true;
    string expectedOutput = "Hello World...!!!1234567891.2345678912345679E8true";
    fprint(stdout, s1, i1, f1, b1);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintMixVarargsWithStdout]}
isolated function testFprintNewlineWithStdout() {
    string expectedOutput = "hello\n";
    fprint(stdout, "hello\n");
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintNewlineWithStdout]}
isolated function testFprintRawTemplateWithTrueWithStdout() {
    boolean val = true;
    string expectedOutput = "The respective boolean value is true";
    fprint(stdout, `The respective boolean value is ${val}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithTrueWithStdout]}
isolated function testFprintRawTemplateWithFalseWithStdout() {
    boolean val = false;
    string expectedOutput = "The respective boolean value is false";
    fprint(stdout, `The respective boolean ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithFalseWithStdout]}
isolated function testFprintRawTemplateWithIntWithStdout() {
    int val = 1050;
    string expectedOutput = "The respective int value is 1050";
    fprint(stdout, `The respective int ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithIntWithStdout]}
isolated function testFprintRawTemplateWithDecimalWithStdout() {
    decimal val = 1050.0967;
    string expectedOutput = "The respective decimal value is 1050.0967";
    fprint(stdout, `The respective decimal ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithDecimalWithStdout]}
isolated function testFprintRawTemplateWithStringWithStdout() {
    string val = "My String";
    string expectedOutput = "The respective string value is My String";
    fprint(stdout, `The respective string ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithStringWithStdout]}
isolated function testFprintRawTemplateWithStringAndQuotesWithStdout() {
    string val = "My String";
    string expectedOutput = "The respective string value is 'My String'";
    fprint(stdout, `The respective string ${`value is '${val}'`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithStringAndQuotesWithStdout]}
isolated function testFprintRawTemplateNestedWithStdout() {
    string s1 = "S1";
    string s2 = "S2";
    string s3 = "S3";
    string s4 = "S4";
    string s5 = "S5";
    string expectedOutput = "string 01: S1; string 02: S2; string 03: S3; string 04: S4; string 05: S5";

    fprint(stdout, `${`${`${`${`string 01: ${s1}`}; string 02: ${s2}`}; string 03: ${s3}`}; string 04: ${s4}`}; string 05: ${s5}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateNestedWithStdout]}
isolated function testFprintRawTemplateMultipleWithStdout() {
    string name1 = "James";
    string name2 = "Lily";
    string expectedOutput = "Hello James!!!. After long time. Why Lily didn't come?";
    fprint(stdout, `Hello ${name1}!!!.`, " ", "After long time.", " ", `Why ${name2} didn't come?`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateMultipleWithStdout]}
isolated function testFprintErrorMessageWithStdout() {
    error e = error("sample error");
    string expectedOutput = "it's an error: sample error";
    fprint(stdout, `it's an error: ${e.message()}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintErrorMessageWithStdout]}
isolated function testFprintErrorInTemplateWithStdout() {
    error e = error("sample error");
    string expectedOutput = "it's an error: error(\"sample error\")";
    fprint(stdout, `it's an error: ${e}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintErrorInTemplateWithStdout]}
isolated function testFprintErrorWithStdout() {
    error e = error("sample error");
    string expectedOutput = "error(\"sample error\")";
    fprint(stdout, e);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintErrorWithStdout]}
isolated function testFprintNilWithStdout() {
    fprint(stdout, ());
    test:assertEquals(readOutputStream(), "");
}

// io:fprintln with stdout

@test:Config {dependsOn: [testFprintNilWithStdout]}
isolated function testFprintlnStringWithStdout() {
    string s = "A Greeting from Ballerina...!!!";
    string expectedOutput = s + "\n";
    fprintln(stdout, s);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnStringWithStdout]}
isolated function testFprintlnIntWithStdout() {
    int v = 1000;
    fprintln(stdout, v);
    test:assertEquals(readOutputStream(), "1000\n");
}

@test:Config {dependsOn: [testFprintlnIntWithStdout]}
isolated function testFprintlnFloatWithStdout() {
    float v = 1000;
    fprintln(stdout, v);
    test:assertEquals(readOutputStream(), "1000.0\n");
}

@test:Config {dependsOn: [testFprintlnFloatWithStdout]}
isolated function testFprintlnBooleanWithStdout() {
    boolean b = false;
    fprintln(stdout, b);
    test:assertEquals(readOutputStream(), "false\n");
}

@test:Config {dependsOn: [testFprintlnBooleanWithStdout]}
isolated function testFprintlnConnectorWithStdout() {
    Foo f = new Foo();
    fprintln(stdout, f);
    test:assertEquals(readOutputStream(), "object io:Foo\n");
}

@test:Config {dependsOn: [testFprintlnConnectorWithStdout]}
isolated function testFprintlnFunctionPointerWithStdout() {
    function (int, int) returns (int) addFunction = func1;
    fprintln(stdout, addFunction);
    test:assertEquals(readOutputStream(), "function isolated function (int,int) returns (int)\n");
}

@test:Config {dependsOn: [testFprintlnFunctionPointerWithStdout]}
isolated function testFprintlnVarargsWithStdout() {
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string s3 = "Adios";
    string expectedOutput = s1 + s2 + s3 + "\n";
    fprintln(stdout, s1, s2, s3);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnVarargsWithStdout]}
isolated function testFprintlnMixVarargsWithStdout() {
    string s1 = "Hello World...!!!";
    int i1 = 123456789;
    float f1 = 123456789.123456789;
    boolean b1 = true;
    string expectedOutput = "Hello World...!!!1234567891.2345678912345679E8true\n";
    fprintln(stdout, s1, i1, f1, b1);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnMixVarargsWithStdout]}
isolated function testFprintlnNewlineWithStdout() {
    string expectedOutput = "hello\n\n";
    fprintln(stdout, "hello\n");
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnNewlineWithStdout]}
isolated function testFprintlnRawTemplateWithTrueWithStdout() {
    boolean val = true;
    string expectedOutput = "The respective boolean value is true\n";
    fprintln(stdout, `The respective boolean value is ${val}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithTrueWithStdout]}
isolated function testFprintlnRawTemplateWithFalseWithStdout() {
    boolean val = false;
    string expectedOutput = "The respective boolean value is false\n";
    fprintln(stdout, `The respective boolean ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithFalseWithStdout]}
isolated function testFprintlnRawTemplateWithIntWithStdout() {
    int val = 1050;
    string expectedOutput = "The respective int value is 1050\n";
    fprintln(stdout, `The respective int ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithIntWithStdout]}
isolated function testFprintlnRawTemplateWithDecimalWithStdout() {
    decimal val = 1050.0967;
    string expectedOutput = "The respective decimal value is 1050.0967\n";
    fprintln(stdout, `The respective decimal ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithDecimalWithStdout]}
isolated function testFprintlnRawTemplateWithStringWithStdout() {
    string val = "My String";
    string expectedOutput = "The respective string value is My String\n";
    fprintln(stdout, `The respective string ${`value is ${val}`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithStringWithStdout]}
isolated function testFprintlnRawTemplateWithStringAndQuotesWithStdout() {
    string val = "My String";
    string expectedOutput = "The respective string value is 'My String'\n";
    fprintln(stdout, `The respective string ${`value is '${val}'`}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithStringAndQuotesWithStdout]}
isolated function testFprintlnRawTemplateNestedWithStdout() {
    string s1 = "S1";
    string s2 = "S2";
    string s3 = "S3";
    string s4 = "S4";
    string s5 = "S5";
    string expectedOutput = "string 01: S1; string 02: S2; string 03: S3; string 04: S4; string 05: S5\n";

    fprintln(stdout, `${`${`${`${`string 01: ${s1}`}; string 02: ${s2}`}; string 03: ${s3}`}; string 04: ${s4}`}; string 05: ${s5}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateNestedWithStdout]}
isolated function testFprintlnRawTemplateMultipleWithStdout() {
    string name1 = "James";
    string name2 = "Lily";
    string expectedOutput = "Hello James!!!. After long time. Why Lily didn't come?\n";
    fprintln(stdout, `Hello ${name1}!!!.`, " ", "After long time.", " ", `Why ${name2} didn't come?`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateMultipleWithStdout]}
isolated function testFprintlnErrorMessageWithStdout() {
    error e = error("sample error");
    string expectedOutput = "it's an error: sample error\n";
    fprintln(stdout, `it's an error: ${e.message()}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnErrorMessageWithStdout]}
isolated function testFprintlnErrorInTemplateWithStdout() {
    error e = error("sample error");
    string expectedOutput = "it's an error: error(\"sample error\")\n";
    fprintln(stdout, `it's an error: ${e}`);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnErrorInTemplateWithStdout]}
isolated function testFprintlnErrorWithStdout() {
    error e = error("sample error");
    string expectedOutput = "error(\"sample error\")\n";
    fprintln(stdout, e);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnErrorWithStdout]}
isolated function testFprintlnNilWithStdout() {
    fprintln(stdout, ());
    test:assertEquals(readOutputStream(), "\n");
}

// io:fprint with stderr

@test:Config {}
isolated function testFprintStringWithStderr() {
    string s = "A Greeting from Ballerina...!!!";
    fprint(stderr, s);
    test:assertEquals(readErrorStream(), s);
}

@test:Config {dependsOn: [testFprintStringWithStderr]}
isolated function testFprintIntWithStderr() {
    int v = 1000;
    fprint(stderr, v);
    test:assertEquals(readErrorStream(), "1000");
}

@test:Config {dependsOn: [testFprintIntWithStderr]}
isolated function testFprintFloatWithStderr() {
    float v = 1000;
    fprint(stderr, v);
    test:assertEquals(readErrorStream(), "1000.0");
}

@test:Config {dependsOn: [testFprintFloatWithStderr]}
isolated function testFprintBooleanWithStderr() {
    boolean b = false;
    fprint(stderr, b);
    test:assertEquals(readErrorStream(), "false");
}

@test:Config {dependsOn: [testFprintBooleanWithStderr]}
isolated function testFprintConnectorWithStderr() {
    Foo f = new Foo();
    fprint(stderr, f);
    test:assertEquals(readErrorStream(), "object io:Foo");
}

@test:Config {dependsOn: [testFprintConnectorWithStderr]}
isolated function testFprintFunctionPointerWithStderr() {
    function (int, int) returns (int) addFunction = func1;
    fprint(stderr, addFunction);
    test:assertEquals(readErrorStream(), "function isolated function (int,int) returns (int)");
}

@test:Config {dependsOn: [testFprintFunctionPointerWithStderr]}
isolated function testFprintVarargsWithStderr() {
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string s3 = "Adios";
    string expectedOutput = s1 + s2 + s3;
    fprint(stderr, s1, s2, s3);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintVarargsWithStderr]}
isolated function testFprintMixVarargsWithStderr() {
    string s1 = "Hello World...!!!";
    int i1 = 123456789;
    float f1 = 123456789.123456789;
    boolean b1 = true;
    string expectedOutput = "Hello World...!!!1234567891.2345678912345679E8true";
    fprint(stderr, s1, i1, f1, b1);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintMixVarargsWithStderr]}
isolated function testFprintNewlineWithStderr() {
    string expectedOutput = "hello\n";
    fprint(stderr, "hello\n");
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintNewlineWithStderr]}
isolated function testFprintRawTemplateWithTrueWithStderr() {
    boolean val = true;
    string expectedOutput = "The respective boolean value is true";
    fprint(stderr, `The respective boolean value is ${val}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithTrueWithStderr]}
isolated function testFprintRawTemplateWithFalseWithStderr() {
    boolean val = false;
    string expectedOutput = "The respective boolean value is false";
    fprint(stderr, `The respective boolean ${`value is ${val}`}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithFalseWithStderr]}
isolated function testFprintRawTemplateWithIntWithStderr() {
    int val = 1050;
    string expectedOutput = "The respective int value is 1050";
    fprint(stderr, `The respective int ${`value is ${val}`}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithIntWithStderr]}
isolated function testFprintRawTemplateWithDecimalWithStderr() {
    decimal val = 1050.0967;
    string expectedOutput = "The respective decimal value is 1050.0967";
    fprint(stderr, `The respective decimal ${`value is ${val}`}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithDecimalWithStderr]}
isolated function testFprintRawTemplateWithStringWithStderr() {
    string val = "My String";
    string expectedOutput = "The respective string value is My String";
    fprint(stderr, `The respective string ${`value is ${val}`}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithStringWithStderr]}
isolated function testFprintRawTemplateWithStringAndQuotesWithStderr() {
    string val = "My String";
    string expectedOutput = "The respective string value is 'My String'";
    fprint(stderr, `The respective string ${`value is '${val}'`}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateWithStringAndQuotesWithStderr]}
isolated function testFprintRawTemplateNestedWithStderr() {
    string s1 = "S1";
    string s2 = "S2";
    string s3 = "S3";
    string s4 = "S4";
    string s5 = "S5";
    string expectedOutput = "string 01: S1; string 02: S2; string 03: S3; string 04: S4; string 05: S5";

    fprint(stderr, `${`${`${`${`string 01: ${s1}`}; string 02: ${s2}`}; string 03: ${s3}`}; string 04: ${s4}`}; string 05: ${s5}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateNestedWithStderr]}
isolated function testFprintRawTemplateMultipleWithStderr() {
    string name1 = "James";
    string name2 = "Lily";
    string expectedOutput = "Hello James!!!. After long time. Why Lily didn't come?";
    fprint(stderr, `Hello ${name1}!!!.`, " ", "After long time.", " ", `Why ${name2} didn't come?`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintRawTemplateMultipleWithStderr]}
isolated function testFprintErrorMessageWithStderr() {
    error e = error("sample error");
    string expectedOutput = "it's an error: sample error";
    fprint(stderr, `it's an error: ${e.message()}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintErrorMessageWithStderr]}
isolated function testFprintErrorInTemplateWithStderr() {
    error e = error("sample error");
    string expectedOutput = "it's an error: error(\"sample error\")";
    fprint(stderr, `it's an error: ${e}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintErrorInTemplateWithStderr]}
isolated function testFprintErrorWithStderr() {
    error e = error("sample error");
    string expectedOutput = "error(\"sample error\")";
    fprint(stderr, e);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintErrorWithStderr]}
isolated function testFprintNilWithStderr() {
    fprint(stderr, ());
    test:assertEquals(readErrorStream(), "");
}

// io:fprintln with stderr

@test:Config {dependsOn: [testFprintNilWithStderr]}
isolated function testFprintlnStringWithStderr() {
    string s = "A Greeting from Ballerina...!!!";
    string expectedOutput = s + "\n";
    fprintln(stderr, s);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnStringWithStderr]}
isolated function testFprintlnIntWithStderr() {
    int v = 1000;
    fprintln(stderr, v);
    test:assertEquals(readErrorStream(), "1000\n");
}

@test:Config {dependsOn: [testFprintlnIntWithStderr]}
isolated function testFprintlnFloatWithStderr() {
    float v = 1000;
    fprintln(stderr, v);
    test:assertEquals(readErrorStream(), "1000.0\n");
}

@test:Config {dependsOn: [testFprintlnFloatWithStderr]}
isolated function testFprintlnBooleanWithStderr() {
    boolean b = false;
    fprintln(stderr, b);
    test:assertEquals(readErrorStream(), "false\n");
}

@test:Config {dependsOn: [testFprintlnBooleanWithStderr]}
isolated function testFprintlnConnectorWithStderr() {
    Foo f = new Foo();
    fprintln(stderr, f);
    test:assertEquals(readErrorStream(), "object io:Foo\n");
}

@test:Config {dependsOn: [testFprintlnConnectorWithStderr]}
isolated function testFprintlnFunctionPointerWithStderr() {
    function (int, int) returns (int) addFunction = func1;
    fprintln(stderr, addFunction);
    test:assertEquals(readErrorStream(), "function isolated function (int,int) returns (int)\n");
}

@test:Config {dependsOn: [testFprintlnFunctionPointerWithStderr]}
isolated function testFprintlnVarargsWithStderr() {
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string s3 = "Adios";
    string expectedOutput = s1 + s2 + s3 + "\n";
    fprintln(stderr, s1, s2, s3);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnVarargsWithStderr]}
isolated function testFprintlnMixVarargsWithStderr() {
    string s1 = "Hello World...!!!";
    int i1 = 123456789;
    float f1 = 123456789.123456789;
    boolean b1 = true;
    string expectedOutput = "Hello World...!!!1234567891.2345678912345679E8true\n";
    fprintln(stderr, s1, i1, f1, b1);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnMixVarargsWithStderr]}
isolated function testFprintlnNewlineWithStderr() {
    string expectedOutput = "hello\n\n";
    fprintln(stderr, "hello\n");
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnNewlineWithStderr]}
isolated function testFprintlnRawTemplateWithTrueWithStderr() {
    boolean val = true;
    string expectedOutput = "The respective boolean value is true\n";
    fprintln(stderr, `The respective boolean value is ${val}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithTrueWithStderr]}
isolated function testFprintlnRawTemplateWithFalseWithStderr() {
    boolean val = false;
    string expectedOutput = "The respective boolean value is false\n";
    fprintln(stderr, `The respective boolean ${`value is ${val}`}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithFalseWithStderr]}
isolated function testFprintlnRawTemplateWithIntWithStderr() {
    int val = 1050;
    string expectedOutput = "The respective int value is 1050\n";
    fprintln(stderr, `The respective int ${`value is ${val}`}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithIntWithStderr]}
isolated function testFprintlnRawTemplateWithDecimalWithStderr() {
    decimal val = 1050.0967;
    string expectedOutput = "The respective decimal value is 1050.0967\n";
    fprintln(stderr, `The respective decimal ${`value is ${val}`}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithDecimalWithStderr]}
isolated function testFprintlnRawTemplateWithStringWithStderr() {
    string val = "My String";
    string expectedOutput = "The respective string value is My String\n";
    fprintln(stderr, `The respective string ${`value is ${val}`}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithStringWithStderr]}
isolated function testFprintlnRawTemplateWithStringAndQuotesWithStderr() {
    string val = "My String";
    string expectedOutput = "The respective string value is 'My String'\n";
    fprintln(stderr, `The respective string ${`value is '${val}'`}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateWithStringAndQuotesWithStderr]}
isolated function testFprintlnRawTemplateNestedWithStderr() {
    string s1 = "S1";
    string s2 = "S2";
    string s3 = "S3";
    string s4 = "S4";
    string s5 = "S5";
    string expectedOutput = "string 01: S1; string 02: S2; string 03: S3; string 04: S4; string 05: S5\n";

    fprintln(stderr, `${`${`${`${`string 01: ${s1}`}; string 02: ${s2}`}; string 03: ${s3}`}; string 04: ${s4}`}; string 05: ${s5}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateNestedWithStderr]}
isolated function testFprintlnRawTemplateMultipleWithStderr() {
    string name1 = "James";
    string name2 = "Lily";
    string expectedOutput = "Hello James!!!. After long time. Why Lily didn't come?\n";
    fprintln(stderr, `Hello ${name1}!!!.`, " ", "After long time.", " ", `Why ${name2} didn't come?`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnRawTemplateMultipleWithStderr]}
isolated function testFprintlnErrorMessageWithStderr() {
    error e = error("sample error");
    string expectedOutput = "it's an error: sample error\n";
    fprintln(stderr, `it's an error: ${e.message()}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnErrorMessageWithStderr]}
isolated function testFprintlnErrorInTemplateWithStderr() {
    error e = error("sample error");
    string expectedOutput = "it's an error: error(\"sample error\")\n";
    fprintln(stderr, `it's an error: ${e}`);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnErrorInTemplateWithStderr]}
isolated function testFprintlnErrorWithStderr() {
    error e = error("sample error");
    string expectedOutput = "error(\"sample error\")\n";
    fprintln(stderr, e);
    test:assertEquals(readErrorStream(), expectedOutput);
}

@test:Config {dependsOn: [testFprintlnErrorWithStderr]}
isolated function testFprintlnNilWithStderr() {
    fprintln(stderr, ());
    test:assertEquals(readErrorStream(), "\n");
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

public isolated function initErrorStream() = @java:Method {
    name: "initErrorStream",
    'class: "org.ballerinalang.stdlib.io.testutils.PrintTestUtils"
} external;

public isolated function readErrorStream() returns string = @java:Method {
    name: "readErrorStream",
    'class: "org.ballerinalang.stdlib.io.testutils.PrintTestUtils"
} external;

public isolated function resetErrorStream() = @java:Method {
    name: "resetErrorStream",
    'class: "org.ballerinalang.stdlib.io.testutils.PrintTestUtils"
} external;
