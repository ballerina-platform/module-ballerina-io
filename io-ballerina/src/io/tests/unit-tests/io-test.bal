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

function testPrintAndPrintlnString(string s1, string s2) {
    println(s1);
    print(s2);
    // output is equal to s1\ns2
}

function testPrintAndPrintlnInt(int v1, int v2) {
    println(v1);
    print(v2);
    // output is equal to v1\nv2
}

function testPrintAndPrintlnFloat(float v1, float v2) {
    println(v1);
    print(v2);
    // output is equal to v1\nv2
}

function testPrintAndPrintlnBoolean(boolean v1, boolean v2) {
    println(v1);
    print(v2);
    // output is equal to v1\nv2
}

function testPrintAndPrintlnConnector() {
    Foo f1 = new Foo();
    Foo f2 = new Foo();
    println(f1);
    print(f2);
}

function testPrintAndPrintlnFunctionPointer() {
    function (int, int) returns (int) addFunction = func1;
    println(addFunction);
    print(addFunction);
}

function testSprintf(string fmtStr, any... fmtArgs) returns (string) {
    return sprintf(fmtStr, ...fmtArgs);
}

function testSprintfNilString() returns string {
    return sprintf("%s", ());
}

function testSprintfNilFloat() returns string {
    return sprintf("%f", ());
}

function testSprintfMix(string fmtStr, string s1, string s2, int i1) returns (string) {
    return sprintf(fmtStr, s1, s2, i1);
}

function printNewline() {
    print("hello\n");
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

function testPrintMixVarargs(string s1, int i1, float f1, boolean b1) {
    print(s1, i1, f1, b1);
}

function testPrintVarargs(string s1, string s2, string s3) {
    print(s1, s2, s3);
}

function testPrintlnVarargs(string s1, string s2, string s3) {
    println(s1, s2, s3);
}
