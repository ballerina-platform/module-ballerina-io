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

# Reads a line of input from the standard input (STDIN).
# If an argument is provided, it will be printed as a prompt before reading the input.
# ```ballerina
# string choice = io:readln("Enter choice 1 - 5: ");
# string choice = io:readln();
# ```
#
# + a - An optional value to be printed before reading the input
# + return - Input read from the STDIN
public function readln(any? a = ()) returns string = @java:Method {
    name: "readln",
    'class: "io.ballerina.stdlib.io.nativeimpl.ReadlnAny"
} external;
