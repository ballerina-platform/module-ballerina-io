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

# Read channel content as an XML.
# ```ballerina
# xml|io:Error content = io:channelReadXml(readableChannel);
# ```
# + channel - Readable channel
# + return - Either a XML or `io:Error`
public function channelReadXml(ReadableChannel channel) returns @tainted readonly & xml|Error {}

# Write XML content to a channel.
# ```ballerina
# xml content = xml `<book>The Lost World</book>`;
# io:Error? result = io:channelWriteXml(writableChannel, content);
# ```
# + channel - Writable channel
# + content - XML content to write
# + return - `io:Error` or else `()`
public function channelWriteXml(WritableChannel channel, xml content) returns Error? {}
