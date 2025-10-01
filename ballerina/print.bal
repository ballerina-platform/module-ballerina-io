// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/jballerina.java;

# Defines all the printable types.
# 1. any typed value
# 2. errors
# 3. `io:PrintableRawTemplate` - an raw templated value
public type Printable any|error|PrintableRawTemplate;

# Defines the output streaming types.
# 1. `stdout` - standard output stream
# 2. `stderr` - standard error stream
public type FileOutputStream stdout|stderr;

# Represents raw templates.
# e.g: `The respective int value is ${val}`
# + strings - String values of the template as an array
# + insertions - Parameterized values/expressions after evaluations as an array
public type PrintableRawTemplate object {
    public string[] & readonly strings;
    public Printable[] insertions;
};

# Prints `any`, `error`, or string template value(s) to the standard output stream.
# ```ballerina
# io:print("Start processing the CSV file from ", srcFileName);
# ```
#
# + values - The value(s) to be printed
public isolated function print(Printable... values) {
    PrintableClassImpl[] printables = [];
    foreach int i in 0 ..< (values.length()) {
        printables[i] = new PrintableClassImpl(values[i]);
    }
    externPrint(stdout, ...printables);
}

# Prints `any`, `error` or string templates value(s) to the standard output stream and terminates the line.
# ```ballerina
# io:println("Start processing the CSV file from ", srcFileName);
# ```
#
# + values - The value(s) to be printed
public isolated function println(Printable... values) {
    PrintableClassImpl[] printables = [];
    foreach int i in 0 ..< (values.length()) {
        printables[i] = new PrintableClassImpl(values[i]);
    }
    externPrintln(stdout, ...printables);
}

# Prints `any`, `error`, or string templates value(s) to a given stream(STDOUT or STDERR).
# ```ballerina
# io:fprint(io:stderr, "Unexpected error occurred");
# ```
# + fileOutputStream - The output stream (`io:stdout` or `io:stderr`) content needs to be printed
# + values - The value(s) to be printed
public isolated function fprint(FileOutputStream fileOutputStream, Printable... values) {
    PrintableClassImpl[] printables = [];
    foreach int i in 0 ..< (values.length()) {
        printables[i] = new PrintableClassImpl(values[i]);
    }
    externPrint(fileOutputStream, ...printables);
}

# Prints `any`, `error`, or string templates value(s) to a given stream(STDOUT or STDERR) and terminates the line.
# ```ballerina
# io:fprintln(io:stderr, "Unexpected error occurred");
# ```
# + fileOutputStream - The output stream (`io:stdout` or `io:stderr`) content needs to be printed
# + values - The value(s) to be printed
public isolated function fprintln(FileOutputStream fileOutputStream, Printable... values) {
    PrintableClassImpl[] printables = [];
    foreach int i in 0 ..< (values.length()) {
        printables[i] = new PrintableClassImpl(values[i]);
    }
    externPrintln(fileOutputStream, ...printables);
}

class PrintableClassImpl {
    Printable printable;

    public isolated function init(Printable printable) {
        self.printable = printable;
    }
    public isolated function toString() returns string {
        Printable printable = self.printable;
        if printable is PrintableRawTemplate {
            return new PrintableRawTemplateImpl(printable).toString();
        } else if printable is error {
            return printable.toString();
        } else {
            return printable.toString();
        }
    }
}

class PrintableRawTemplateImpl {
    *object:RawTemplate;
    public Printable[] insertions;

    public isolated function init(PrintableRawTemplate printableRawTemplate) {
        self.strings = printableRawTemplate.strings;
        self.insertions = printableRawTemplate.insertions;
    }
    public isolated function toString() returns string {
        Printable[] templeteInsertions = self.insertions;
        string[] templeteStrings = self.strings;
        string templatedString = templeteStrings[0];
        foreach int i in 1 ..< (templeteStrings.length()) {
            Printable templateInsert = templeteInsertions[i - 1];
            if templateInsert is PrintableRawTemplate {
                templatedString += new PrintableRawTemplateImpl(templateInsert).toString() + templeteStrings[i];
            } else if templateInsert is error {
                templatedString += templateInsert.toString() + templeteStrings[i];
            } else {
                templatedString += templateInsert.toString() + templeteStrings[i];
            }
        }
        return templatedString;
    }
}

isolated function externPrint(int filePrintOption, PrintableClassImpl... values) = @java:Method {
    name: "print",
    'class: "io.ballerina.stdlib.io.nativeimpl.PrintUtils"
} external;

isolated function externPrintln(int filePrintOption, PrintableClassImpl... values) = @java:Method {
    name: "println",
    'class: "io.ballerina.stdlib.io.nativeimpl.PrintUtils"
} external;
