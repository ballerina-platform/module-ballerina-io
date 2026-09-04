// Copyright (c) 2025 WSO2 LLC. (http://www.wso2.org)
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

import ballerina/io;

configurable string dbPassword = ?;
configurable string apiToken = ?;
configurable int retryCount = 3;

// A deployment secret written straight to standard output
public function printSecret() {
    io:println(dbPassword);
}

// Reached through a string template interpolation
public function printSecretInTemplate() {
    io:println(string `Connecting with token ${apiToken}`);
}

// print behaves the same as println
public function printSecretWithoutNewline() {
    io:print(dbPassword);
}

// Negative case - an ordinary local variable
public function printLocalValue() {
    string message = "connection established";
    io:println(message);
}

// Negative case - a literal
public function printLiteral() {
    io:println("connection established");
}

// Reported as well: the rule cannot tell which configurables hold secrets, and
// treating every deployment-supplied value as sensitive is the safe direction
public function printRetryCount() {
    io:println(retryCount);
}
