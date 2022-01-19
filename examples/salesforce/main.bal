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

import ballerinax/salesforce;
import ballerinax/salesforce.bulk as sbulk;
import ballerina/log;
import ballerina/io;

json accountRecord = {
    Name: "WSO2",
    BillingCity: "Colombo 00300"
};

configurable string BASE_URL = ?;
configurable string SF_TOKEN = ?;

public function main() returns error? {
    salesforce:ConnectionConfig sfConfig = {
        baseUrl: BASE_URL,
        clientConfig: {
            token: SF_TOKEN
        }
    };
    stream<string[], io:Error?> csvStream = check io:fileReadCsvAsStream("resources/data.csv");
    sbulk:Client baseClient = check new (sfConfig);
    sbulk:BulkJob queryJob = check baseClient->createJob("insert", "Contact", "CSV");

    do {
        sbulk:BatchInfo batch = check baseClient->addBatch(queryJob, csvStream);
        string batchId = batch.id;

        // Get batch info
        sbulk:BatchInfo batchInfo = check baseClient->getBatchInfo(queryJob, batchId);
        io:println("Batch Info");
        io:println(batchInfo);

        // Get batch result
        sbulk:Result[] batchResult = <sbulk:Result[]>check baseClient->getBatchResult(queryJob, batchId);
        foreach sbulk:Result res in batchResult {
            if (!res.success) {
                log:printError("Failed result, res=" + (res.errors is string ? <string>res.errors : ""));
            }
        }

        // Close the job
        _ = check baseClient->closeJob(queryJob);
    } on fail error err {
        log:printError(err.message());
        _ = check baseClient->closeJob(queryJob);
    }
}
