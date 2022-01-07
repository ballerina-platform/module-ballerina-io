// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/lang.array;
import ballerina/regex;

public function main() returns error? {
    // Read lines as a stream
    stream<string, io:Error?> lineStream = check io:fileReadLinesAsStream("./resources/data.txt");

    // Generating the bag-of-word (BoW) model
    map<int> bow = {};
    check lineStream.forEach(function(string line) {
        string[] tokens = regex:split(line, "\\s+");
        foreach string token in tokens {
            if token != "" {
                string lowerCaseToken = token.toLowerAscii();
                int? frequency = bow[lowerCaseToken];
                bow[lowerCaseToken] = frequency is int ? frequency + 1 : 1;
            }
        }
    });

    // Finding the most frequent number of words based on a given input
    int threshold = check 'int:fromString(io:readln("Enter the number of most frequent words to retrieve: "));
    int[] vocabEntries = bow.toArray();
    if threshold > vocabEntries.length() {
        threshold = vocabEntries.length();
    }
    int thresholdBoundry = bow.toArray().sort(array:DESCENDING)[threshold - 1];
    map<int> frequentWords = bow.filter(function(int f) returns boolean {
        return f >= thresholdBoundry;
    });

    io:println(`Most frequent ${threshold} words are:`);
    io:println(frequentWords);
}
