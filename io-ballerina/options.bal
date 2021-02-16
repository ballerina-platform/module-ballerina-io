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

# Represents a file opening options for writing.
#
# + OVERWRITE - Overwrite(truncate the existing content)
# + APPEND - Append to the existing content
public enum FileWriteOption {
    OVERWRITE,
    APPEND
}

# Represents the XML entity type that needs to be written.
#
# + DOCUMENT_ENTITY - An XML document with a single root node
# + EXTERNAL_PARSED_ENTITY - Externally parsed well-formed XML entity
public enum XmlEntityType {
    DOCUMENT_ENTITY,
    EXTERNAL_PARSED_ENTITY
}

# Represents the XML DOCTYPE entity.
#
# + system - the system identifier
# + public - the public identifier
# + internalSubset - internal DTD schema
public type XmlDoctype record {|
   string? system = ();
   string? 'public = ();
   string? internalSubset = ();
|};

# The writing options of an XML.
#
# + xmlEntityType - the entity type of the XML input(default value is `DOCUMENT_ENTITY`)
# + doctype - XML DOCTYPE value(default value is null)
public type XmlWriteOptions record {|
    XmlEntityType xmlEntityType = DOCUMENT_ENTITY;
    XmlDoctype? doctype = ();
|};
