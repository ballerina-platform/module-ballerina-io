// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

ReadableTextRecordChannel? recordReadCh = ();
WritableTextRecordChannel? recordWriteCh = ();

function initReadableRecordChannel(string filePath, string encoding, string recordSeparator,
                                    string fieldSeparator) returns error? {
    var byteChannel = openReadableFile(filePath);
    if (byteChannel is error) {
        return byteChannel;
    } else {
        ReadableCharacterChannel charChannel = new ReadableCharacterChannel(byteChannel, encoding);
        recordReadCh = <ReadableTextRecordChannel> new ReadableTextRecordChannel(charChannel, fieldSeparator, recordSeparator);
    }
}

function initWritableRecordChannel(string filePath, string encoding, string recordSeparator,
                             string fieldSeparator) returns Error? {
    WritableByteChannel byteChannel = check openWritableFile(filePath);
    WritableCharacterChannel charChannel = new WritableCharacterChannel(byteChannel, encoding);
    recordWriteCh = <WritableTextRecordChannel> new WritableTextRecordChannel(charChannel, fieldSeparator, recordSeparator);
}


function nextTextRecord() returns @tainted string[]|error {
    var cha = recordReadCh;
    if(cha is io:ReadableTextRecordChannel) {
        var result = cha.getNext();
        if (result is string[]) {
            return result;
        } else {
            return result;
        }
    }
    return io:GenericError("Record channel not initialized properly");
}

function writeTextRecord(string[] fields) {
    var cha = recordWriteCh;
    if(cha is io:WritableTextRecordChannel){
        var result = cha.write(fields);
    }
}

function closeReadableRecordChannel() {
    var cha = recordReadCh;
    if(cha is ReadableTextRecordChannel) {
        var err = cha.close();
    }
}

function closeWritableRecordChannel() {
    var cha = recordWriteCh;
    if(cha is WritableTextRecordChannel) {
        var err = cha.close();
    }
}


function hasNextTextRecord() returns boolean? {
    var cha = recordReadCh;
    if(cha is ReadableTextRecordChannel) {
        return cha.hasNext();
    }
}
