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
import ballerina/java;

@test:BeforeEach
function beforePrint() {
    resetOutputStream();
    initOutputStream();
}

@test:Config {
    dependsOn: ["testReadString"]
}
function testPrintString() {
    string s = "A Greeting from Ballerina...!!!";
    print(s);
    test:assertEquals(readOutputStream(), s);
}

@test:Config {
    dependsOn: ["testPrintString"]
}
function testPrintlnString() {
    string s = "Hello World...!!!";
    string expectedOutput = s + "\n";
    println(s);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config{
    dependsOn: ["testPrintlnString"]
}
function testPrintInt() {
    int v = 1000;
    print(v);
    test:assertEquals(readOutputStream(), "1000");
}

@test:Config{
    dependsOn: ["testPrintInt"]
}
function testPrintlnInt() {
    int v = 1;
    println(v);
    test:assertEquals(readOutputStream(), "1\n");
}

@test:Config{
    dependsOn: ["testPrintlnInt"]
}
function testPrintFloat() {
    float v = 1000;
    print(v);
    test:assertEquals(readOutputStream(), "1000.0");
}

@test:Config{
    dependsOn: ["testPrintFloat"]
}
function testPrintlnFloat() {
    float v = 1;
    println(v);
    test:assertEquals(readOutputStream(), "1.0\n");
}

@test:Config{
    dependsOn: ["testPrintlnFloat"]
}
function testPrintBoolean() {
    boolean b = false;
    print(b);
    test:assertEquals(readOutputStream(), "false");
}

@test:Config{
    dependsOn: ["testPrintBoolean"]
}
function testPrintlnBoolean() {
    boolean b = true;
    println(b);
    test:assertEquals(readOutputStream(), "true\n");
}

@test:Config{
    dependsOn: ["testPrintlnBoolean"]
}
function testPrintConnector() {
    Foo f = new Foo();
    print(f);
    test:assertEquals(readOutputStream(), "object io:Foo");

}

@test:Config{
    dependsOn: ["testPrintConnector"]
}
function testPrintlnConnector() {
    Foo f = new Foo();
    println(f);
    test:assertEquals(readOutputStream(), "object io:Foo\n");

}

@test:Config{
    dependsOn: ["testPrintlnConnector"]
}
function testPrintFunctionPointer() {
    function (int, int) returns (int) addFunction = func1;
    print(addFunction);
    test:assertEquals(readOutputStream(), "function function (int,int) returns (int)");
}

@test:Config{
    dependsOn: ["testPrintFunctionPointer"]
}
function testPrintlnFunctionPointer() {
    function (int, int) returns (int) addFunction = func1;
    println(addFunction);
    test:assertEquals(readOutputStream(), "function function (int,int) returns (int)\n");
}

@test:Config{
    dependsOn: ["testPrintlnFunctionPointer"]
}
function testPrintVarargs() {
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string s3 = "Adios";
    string expectedOutput = s1 + s2 + s3;
    print(s1, s2, s3);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config{
    dependsOn: ["testPrintVarargs"]
}
function testPrintMixVarargs() {
    string s1 = "Hello World...!!!";
    int i1 = 123456789;
    float f1 = 123456789.123456789;
    boolean b1 = true;
    string expectedOutput = "Hello World...!!! 123456789 123456789.123456789 true";
    print(s1, i1, f1, b1);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config{
    dependsOn: ["testPrintMixVarargs"]
}
function testPrintlnVarargs() {
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string s3 = "Adios";
    string expectedOutput = s1 + s2 + s3 + "\n";
    println(s1, s2, s3);
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config{
    dependsOn: ["testPrintlnVarargs"]
}
function testPrintNewline() {
    string expectedOutput = "hello\n";
    print("hello\n");
    test:assertEquals(readOutputStream(), expectedOutput);
}

@test:Config{
    dependsOn: ["testPrintNewline"]
}
function testSprintfTrue() {
    string fmtStr = "%b";
    boolean b = true;
    string output = sprintf(fmtStr, b);
    test:assertEquals(output, "true");
}

@test:Config{
    dependsOn: ["testSprintfTrue"]
}
function testSprintfFalse() {
    string fmtStr = "%b";
    boolean b = false;
    string output = sprintf(fmtStr, b);
    test:assertEquals(output, "false");
}

@test:Config{
    dependsOn: ["testSprintfFalse"]
}
function testSprintfInt() {
    string fmtStr = "%d";
    int i = 65;
    string output = sprintf(fmtStr, i);
    test:assertEquals(output, "65");
}

@test:Config{
    dependsOn: ["testSprintfInt"]
}
function testSprintfFloat() {
    string fmtStr = "%f";
    float f = 3.25;
    string output = sprintf(fmtStr, f);
    test:assertEquals(output, "3.250000");
}

@test:Config{
    dependsOn: ["testSprintfFloat"]
}
function testSprintfString() {
    string fmtStr = "%s";
    string s = "John";
    string output = sprintf(fmtStr, s);
    test:assertEquals(output, "John");
}

@test:Config{
    dependsOn: ["testSprintfString"]
}
function testSprintfHex() {
    string fmtStr = "%x";
    int i = 57005;
    string output = sprintf(fmtStr, i);
    test:assertEquals(output, "dead");
}

@test:Config{
    dependsOn: ["testSprintfHex"]
}
function testSprintfArray() {
    string fmtStr = "%s";
    int[] arr = [111, 222, 333];
    string output = sprintf(fmtStr, arr);
    test:assertEquals(output, "111 222 333");
}

@test:Config{
    dependsOn: ["testSprintfArray"]
}
function testSprintfLiteralPercentChar() {
    string fmtStr = "%% %s";
    string s = "test";
    string output = sprintf(fmtStr, s);
    test:assertEquals(output, "% test");
}

@test:Config{
    dependsOn: ["testSprintfArray"]
}
function testSprintfStringWithPadding() {
    string fmtStr = "%9.2s";
    string s = "Hello Ballerina";
    string output = sprintf(fmtStr, s);
    test:assertEquals(output, "       He");
}

@test:Config{
    dependsOn: ["testSprintfArray"]
}
function testSprintfFloatWithPadding() {
    string fmtStr = "%5.4f";
    float f = 123456789.9876543;
    string output = sprintf(fmtStr, f);
    test:assertEquals(output, "123456789.9877");
}

@test:Config{
    dependsOn: ["testSprintfFloatWithPadding"]
}
function testSprintfDecimalWithPadding() {
    string fmtStr = "%15d";
    int i = 12345;
    string output = sprintf(fmtStr, i);
    test:assertEquals(output, "          12345");
}

@test:Config{
    dependsOn: ["testSprintfDecimalWithPadding"]
}
function testSprintfIllegalFormatConversion() {
    string fmtStr = "%x";
    string s = "John";
    string|error output = trap sprintf(fmtStr, s);

    if (output is error) {
        string expectedErrorMsg = "illegal format conversion 'x != string'";
        test:assertEquals(output.message(), expectedErrorMsg);
    } else {
        test:assertFail(msg = "Unexpected output");
    }

}

@test:Config{
    dependsOn: ["testSprintfIllegalFormatConversion"]
}
function testSprintfMix() {
    string fmtStr = "the %s jumped over the %s, %d times";
    string s1 = "cow";
    string s2 = "moon";
    int i1 = 2;
    string output = sprintf(fmtStr, s1, s2, i1);
    string expectedOutput = "the cow jumped over the moon, 2 times";
    test:assertEquals(output, expectedOutput);
}

@test:Config{
    dependsOn: ["testSprintfMix"]
}
function testSprintfNilString() {
    string output = sprintf("%s", ());
    test:assertEquals(output, "");
}

@test:Config{
    dependsOn: ["testSprintfNilString"]
}
function testSprintfNilFloat() {
    string|error output = trap sprintf("%f", ());

    if (output is error) {
        string expectedErrorMsg = "illegal format conversion 'f != ()'";
        test:assertEquals(output.message(), expectedErrorMsg);
    } else {
        test:assertFail(msg = "Unexpected output");
    }
}

function func1(int a, int b) returns (int) {
    int c = a + b;
    return c;
}

type Foo object {
    function bar() returns (int) {
        return 5;
    }
};

public function initOutputStream() = @java:Method {
    name: "initOutputStream",
    class: "org.ballerinalang.stdlib.io.testutils.PrintTestUtils"
} external;

public function readOutputStream() returns string = @java:Method {
    name: "readOutputStream",
    class: "org.ballerinalang.stdlib.io.testutils.PrintTestUtils"
} external;

public function resetOutputStream() = @java:Method {
    name: "resetOutputStream",
    class: "org.ballerinalang.stdlib.io.testutils.PrintTestUtils"
} external;
