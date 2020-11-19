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

import ballerina/java;

# Prints `any` or `error` value(s) to the STDOUT.
#```ballerina
#io:print("Start processing the CSV file from ", srcFileName);
#```
# 
# + values - The value(s) to be printed
public isolated function print((any|error)... values) = @java:Method {
    name: "print",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.PrintUtils"
} external;

# Prints `any` or `error` value(s) to the STDOUT followed by a new line.
#```ballerina
#io:println("Start processing the CSV file from ", srcFileName);
#```
#  
# + values - The value(s) to be printed
public isolated function println((any|error)... values) = @java:Method {
    name: "println",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.PrintUtils"
} external;

# Returns a formatted string using the specified format string and arguments. Following format specifiers are allowed.
#
# b - boolean
#
# B - boolean (ALL_CAPS)
#
# d - int
#
# f - float
#
# x - hex
#
# X - HEX (ALL_CAPS)
#
# s - string (This specifier is applicable for any of the supported types in Ballerina.
#             These values will be converted to their string representation.)
# 
# ```ballerina
# string s1 = io:sprintf("This is a boolean: %b", false);
# // s1 => This is a boolean: false
# string s2 = io:sprintf("This is a boolean in all caps: %B", true);
# // s2 => This is a boolean in all caps: TRUE
# string s3 = io:sprintf("This is an integer: %d", 8);
# // s3 => This is an integer: 8
# string s4 = io:sprintf("This is a float: %f", 8.504);
# // s4 => This is a float: 8.504000
# string s5 = io:sprintf("This is a float with 2 places after decimal points: %.2f", 8.506);
# // s5 => This is a float with 2 places after decimal points: 8.51
# string s6 = io:sprintf("This is a hexadecimal: %x", 0X3DF);
# // s6 => This is a hexadecimal: 3df
# string s7 = io:sprintf("This is a hexadecimal in all caps: %X", 0X3DF);
# // s7 => This is a hexadecimal in all caps: 3DF
# string s8 = io:sprintf("This is a string: %s", "Ballerina");
# // s8 => This is a string: Ballerina
# string s9 = io:sprintf("This is an int with leading zeros: %09d", 8);
# // s9 => This is an int with leading zeros: 000000008
# ```
#
# + format - The string needs to be formatted
# + args   - Arguments referred by the format specifiers in the format string
# + return - The formatted string
public isolated function sprintf(string format, (any|error)... args) returns string = @java:Method {
    name: "sprintf",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.Sprintf"
} external;
