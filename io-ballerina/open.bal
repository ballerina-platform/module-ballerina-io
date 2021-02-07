// Copyright (c) 2017 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Represents a file opening options for writing.
#
# + OVERWRITE - Overriwrite(truncate the existing content)
# + APPEND - Append to the existing content
public enum FileWriteOption {
    OVERWRITE,
    APPEND
}

# Represents the XML content type that need to be written.
#
# + DOCUMENT - An XML document with a single root node
# + EXTERNAL_PARSED_ENTITY - Externally parsed well-formed XML entity
public enum XmlContentType {
    DOCUMENT,
    EXTERNAL_PARSED_ENTITY
}

# The writing options of an XML.
#
# + xmlContentType - Content type of the XML input(default value is `DOCUMENT`)
# + docType - XML DOCTYPE value(default value is null)
# + fileWriteOption - file writing option(default value is `OVERWRITE`)
public type XmlWriteOptions record {|
    XmlContentType xmlContentType = DOCUMENT;
    string? docType = ();
    FileWriteOption fileWriteOption = OVERWRITE;
|};

public function openReadableFile(@untainted string path) returns ReadableByteChannel|Error = @java:Method {
    name: "openReadableFile",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteChannelUtils"
} external;

public function openWritableFile(@untainted string path, FileWriteOption option = OVERWRITE)
    returns WritableByteChannel|Error = @java:Method {
    name: "openWritableFile",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteChannelUtils"
} external;

public function createReadableChannel(byte[] content) returns ReadableByteChannel|Error = @java:Method {
    name: "createReadableChannel",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.ByteChannelUtils"
} external;

public function openReadableCsvFile(@untainted string path,
                                    @untainted Separator fieldSeparator = ",",
                                    @untainted string charset = "UTF-8",
                                    @untainted int skipHeaders = 0) returns ReadableCSVChannel|Error {
    ReadableByteChannel byteChannel = check openReadableFile(path);
    ReadableCharacterChannel charChannel = new(byteChannel, charset);
    return new ReadableCSVChannel(charChannel, fieldSeparator, skipHeaders);
}

public function openWritableCsvFile(@untainted string path,
                                    @untainted Separator fieldSeparator = ",",
                                    @untainted string charset = "UTF-8",
                                    @untainted int skipHeaders = 0,
                                    FileWriteOption option = OVERWRITE) returns WritableCSVChannel|Error {
    WritableByteChannel byteChannel = check openWritableFile(path, option);
    WritableCharacterChannel charChannel = new(byteChannel, charset);
    return new WritableCSVChannel(charChannel, fieldSeparator);
}
