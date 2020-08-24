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

import ballerina/test;

ReadableByteChannel? bytesReadCh = ();
WritableByteChannel? bytesWriteCh = ();

function testReadBytes() {
    Error? initResult = initReadableChannel("../io-native/src/test/resources/datafiles/io/text/6charfile.txt");
    if (initResult is Error) {
        test:assertFail(msg = initResult.message());
    }
}

function initReadableBytesChannel(string filePath) returns Error? {
    var result = openReadableFile(filePath);
    if (result is ReadableByteChannel) {
        bytesReadCh = result;
    } else {
        return result;
    }
}

function initWritableBytesChannel(string filePath) {
    bytesWriteCh = <WritableByteChannel> openWritableFile(filePath);
}

function readBytes(int numberOfBytes) returns @tainted byte[]|Error {
    ReadableByteChannel? rChannel = bytesReadCh;
    if (rChannel is ReadableByteChannel) {
        return rChannel.read(numberOfBytes);
    } else {
        GenericError e = GenericError("ReadableByteChannel not initialized");
        return e;
    }
}

function writeBytes(byte[] content, int startOffset) returns int|Error {
    int empty = -1;
    WritableByteChannel? wChannel = bytesWriteCh;
    if (wChannel is WritableByteChannel) {
        var result = wChannel.write(content, startOffset);
        if (result is int) {
            return result;
        } else {
            return result;
        }
    } else {
       GenericError e = GenericError("WritableByteChannel not initialized");
       return e;
    }
}

function closeReadableBytesChannel() {
    ReadableByteChannel? rChannel = bytesReadCh;
    if rChannel is ReadableByteChannel {
        var result = rChannel.close();
    }
}

function closeWritableBytesChannel() {
    WritableByteChannel? wChannel = bytesWriteCh;
    if wChannel is WritableByteChannel {
        var result = wChannel.close();
    }
}

function testBase64EncodeByteChannel(ReadableByteChannel contentToBeEncoded) returns ReadableByteChannel|Error {
    return contentToBeEncoded.base64Encode();
}

function testBase64DecodeByteChannel(ReadableByteChannel contentToBeDecoded) returns ReadableByteChannel|Error {
    return contentToBeDecoded.base64Decode();
}
