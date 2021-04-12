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

# Define all the printable types.
# 1. any typed value
# 2. errors
# 3. `io:PrintableRawTemplate` - an raw templated value
public type Printable any|error|PrintableRawTemplate;

# Represents raw templates.
# e.g: `The respective int value is ${val}`
# + strings - string values of the template as an array
# + insertions - parameterized values/expressions after evaluations as an array
public type PrintableRawTemplate object {
    public string[] & readonly strings;
    public Printable[] insertions;
};

# Prints `any`, `error`, or string templates(such as `The respective int value is ${val}`) value(s) to the STDOUT.
#```ballerina
#io:print("Start processing the CSV file from ", srcFileName);
#```
#
# + values - The value(s) to be printed
public isolated function print(Printable... values) {
    PrintableClassImpl[] printables = [];
    foreach int i in 0 ..< (values.length()) {
        printables[i] = new PrintableClassImpl(values[i]);
    }
    externPrint(...printables);
}

# Prints `any`, `error` or string templates(such as `The respective int value is ${val}`) value(s) to the STDOUT
# followed by a new line.
#```ballerina
# io:println("Start processing the CSV file from ", srcFileName);
#```
#
# + values - The value(s) to be printed
public isolated function println(Printable... values) {
    PrintableClassImpl[] printables = [];
    foreach int i in 0 ..< (values.length()) {
        printables[i] = new PrintableClassImpl(values[i]);
    }
    externPrintln(...printables);
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
            if (templateInsert is PrintableRawTemplate) {
                templatedString += new PrintableRawTemplateImpl(templateInsert).toString() + templeteStrings[i];
            } else if (templateInsert is error) {
                templatedString += templateInsert.toString() + templeteStrings[i];
            } else {
                templatedString += templateInsert.toString() + templeteStrings[i];
            }
        }
        return templatedString;
    }
}

isolated function externPrint(PrintableClassImpl... values) = @java:Method {
    name: "print",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.PrintUtils"
} external;

isolated function externPrintln(PrintableClassImpl... values) = @java:Method {
    name: "println",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.PrintUtils"
} external;
