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
function testPrintAndPrintlnString() {
    // output is equal to s1\ns2
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string expectedOutput = s1 + "\n" + s2;
    println(s1);
    print(s2);
    test:assertEquals(readOutputStream(), expectedOutput, "Found unexpected output");
}

@test:Config{
    dependsOn: ["testPrintAndPrintlnString"]
}
function testPrintAndPrintlnInt() {
    // output is equal to v1\nv2
    int v1 = 1000;
    int v2 = 1;
    string expectedOutput = v1.toString() + "\n" + v2.toString();
    println(v1);
    print(v2);
    test:assertEquals(readOutputStream(), expectedOutput, "Found unexpected output");
}

@test:Config{
    dependsOn: ["testPrintAndPrintlnInt"]
}
function testPrintAndPrintlnFloat() {
    // output is equal to v1\nv2
    float v1 = 1000;
    float v2 = 1;
    string expectedOutput = v1.toString() + "\n" + v2.toString();
    println(v1);
    print(v2);
    test:assertEquals(readOutputStream(), expectedOutput, "Found unexpected output");
}

@test:Config{
    dependsOn: ["testPrintAndPrintlnFloat"]
}
function testPrintAndPrintlnBoolean() {
    // output is equal to v1\nv2
    boolean v1 = false;
    boolean v2 = true;
    string expectedOutput = v1.toString() + "\n" + v2.toString();
    println(v1);
    print(v2);
    test:assertEquals(readOutputStream(), expectedOutput, "Found unexpected output");
}

@test:Config{
    dependsOn: ["testPrintAndPrintlnBoolean"]
}
function testPrintAndPrintlnConnector() {
    string expectedOutput = "object io:Foo\nobject io:Foo";
    Foo f1 = new Foo();
    Foo f2 = new Foo();
    println(f1);
    print(f2);
    test:assertEquals(readOutputStream(), expectedOutput, "Found unexpected output");

}

@test:Config{
    dependsOn: ["testPrintAndPrintlnConnector"]
}
function testPrintAndPrintlnFunctionPointer() {
    string expectedOutput = "function function (int,int) returns (int)\n" +
                        "function function (int,int) returns (int)";
    function (int, int) returns (int) addFunction = func1;
    println(addFunction);
    print(addFunction);
    test:assertEquals(readOutputStream(), expectedOutput, "Found unexpected output");
}

@test:Config{
    dependsOn: ["testPrintAndPrintlnFunctionPointer"]
}
function testPrintVarargs() {
    string s1 = "Hello World...!!!";
    string s2 = "A Greeting from Ballerina...!!!";
    string s3 = "Adios";
    string expectedOutput = s1 + s2 + s3;
    print(s1, s2, s3);
    test:assertEquals(readOutputStream(), expectedOutput, "Found unexpected output");
}

@test:Config{
    dependsOn: ["testPrintVarargs"]
}
function testPrintMixVarargs() {
    string s1 = "Hello World...!!!";
    int i1 = 123456789;
    float f1 = 123456789.123456789;
    boolean b1 = true;
    string expectedOutput = s1 + i1.toString() + f1.toString() + b1.toString();
    print(s1, i1, f1, b1);
    test:assertEquals(readOutputStream(), expectedOutput, "Found unexpected output");
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
    test:assertEquals(readOutputStream(), expectedOutput, "Found unexpected output");
}

@test:Config{
    dependsOn: ["testPrintlnVarargs"]
}
function testPrintNewline() {
    string expectedOutput = "hello\n";
    print("hello\n");
    test:assertEquals(readOutputStream(), expectedOutput, "Found unexpected output");
}

@test:Config{
    dependsOn: ["testPrintNewline"]
}
function testSprintfTrue() {
    string fmtStr = "%b";
    boolean b = true;
    string output = sprintf(fmtStr, b);
    test:assertEquals(output, "true", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfTrue"]
}
function testSprintfFalse() {
    string fmtStr = "%b";
    boolean b = false;
    string output = sprintf(fmtStr, b);
    test:assertEquals(output, "false", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfFalse"]
}
function testSprintfInt() {
    string fmtStr = "%d";
    int i = 65;
    string output = sprintf(fmtStr, i);
    test:assertEquals(output, "65", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfInt"]
}
function testSprintfFloat() {
    string fmtStr = "%f";
    float f = 3.25;
    string output = sprintf(fmtStr, f);
    test:assertEquals(output, "3.250000", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfFloat"]
}
function testSprintfString() {
    string fmtStr = "%s";
    string s = "John";
    string output = sprintf(fmtStr, s);
    test:assertEquals(output, "John", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfString"]
}
function testSprintfHex() {
    string fmtStr = "%x";
    int i = 57005;
    string output = sprintf(fmtStr, i);
    test:assertEquals(output, "dead", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfHex"]
}
function testSprintfArray() {
    string fmtStr = "%s";
    int[] arr = [111, 222, 333];
    string output = sprintf(fmtStr, arr);
    test:assertEquals(output, "111 222 333", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfArray"]
}
function testSprintfLiteralPercentChar() {
    string fmtStr = "%% %s";
    string s = "test";
    string output = sprintf(fmtStr, s);
    test:assertEquals(output, "% test", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfArray"]
}
function testSprintfStringWithPadding() {
    string fmtStr = "%9.2s";
    string s = "Hello Ballerina";
    string output = sprintf(fmtStr, s);
    test:assertEquals(output, "       He", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfArray"]
}
function testSprintfFloatWithPadding() {
    string fmtStr = "%5.4f";
    float f = 123456789.9876543;
    string output = sprintf(fmtStr, f);
    test:assertEquals(output, "123456789.9877", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfFloatWithPadding"]
}
function testSprintfDecimalWithPadding() {
    string fmtStr = "%15d";
    int i = 12345;
    string output = sprintf(fmtStr, i);
    test:assertEquals(output, "          12345", "Found unexpected output");
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
        test:assertEquals(output.message(), expectedErrorMsg, "Found unexpected output");
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
    test:assertEquals(output, expectedOutput, "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfMix"]
}
function testSprintfNilString() {
    string output = sprintf("%s", ());
    test:assertEquals(output, "", "Found unexpected output");
}

@test:Config{
    dependsOn: ["testSprintfNilString"]
}
function testSprintfNilFloat() {
    string|error output = trap sprintf("%f", ());

    if (output is error) {
        string expectedErrorMsg = "illegal format conversion 'f != ()'";
        test:assertEquals(output.message(), expectedErrorMsg, "Found unexpected output");
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
