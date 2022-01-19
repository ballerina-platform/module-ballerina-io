// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/io;
import ballerina/lang.'float;

public function main() returns error? {

    stream<string[], io:Error?> performanceDataStream = check io:fileReadCsvAsStream("resources/grpc_performance_output.csv");
    _ = check performanceDataStream.next(); // Skip the header

    float totalRunningTime = 0.0;
    int numberOfEntries = 0;
    int successCases = 0;
    int failureCases = 0;

    _ = check from string[] entry in performanceDataStream
        do {
            if entry.length() >= 2 {
                float|error duration = 'float:fromString(entry[0]);
                totalRunningTime += duration is float ? duration : 0.0;
                numberOfEntries += 1;

                if "OK".equalsIgnoreCaseAscii(entry[1]) {
                    successCases += 1;
                } else {
                    failureCases += 1;
                }
            }
        };

    io:println(`Average running time : ${totalRunningTime / <float>numberOfEntries}`);
    io:println(`No. of success cases: ${successCases}`);
    io:println(`No. of failure cases: ${failureCases}`);
}
