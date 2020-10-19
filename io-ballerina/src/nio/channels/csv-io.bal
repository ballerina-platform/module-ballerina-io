// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Read channel content as a CSV.
# ```ballerina
# string[][]|io:Error content = io:channelReadCsv(readableChannel);
# ```
# + channel - Readable channel
# + nHeaders - Number of headers, which should be skipped prior to reading records
# + return - Either an array of string arrays or `io:Error`
public function channelReadCsv(ReadableChannel channel,
                               int nHeaders = 0) returns @tainted readonly & string[][]|Error {}

# Read channel content as a CSV.
# ```ballerina
# stream<string[]|Error>|io:Error content = io:channelReadCsvAsStream(readableChannel);
# ```
# + channel - Readable channel
# + nHeaders - Number of headers, which should be skipped prior to reading records
# + return - Either a stream of string array or `io:Error`
public function channelReadCsvAsStream(ReadableChannel channel,
                                       int nHeaders = 0) returns @tainted readonly & stream<string[], Error>|Error, {}

# Write CSV content to a channel.
# ```ballerina
# string[][] content = [["Anne", "Johnson", "SE"], ["John", "Cameron", "QA"]];
# io:Error? result = io:channelWriteCsv(writableChannel, content);
# ```
# + channel - Writable channel
# + content - CSV content as an array of string arrays
# + return - `io:Error` or else `()`
public function channelWriteCsv(WritableChannel channel, 
                         string[][] content) returns Error? {}

# Write CSV record stream to a channel.
# ```ballerina
# string[][] content = [["Anne", "Johnson", "SE"], ["John", "Cameron", "QA"]];
# stream<string[], Error> recordStream = content.toStream();
# io:Error? result = io:channelWriteCsv(writableChannel, recordStream);
# ```
# + channel - Writable channel
# + content - A CSV record stream to be written
# + return - `io:Error` or else `()`
public function channelWriteCsvFromStream(WritableChannel channel, 
                         stream<byte[], Error> content) returns Error? {}
