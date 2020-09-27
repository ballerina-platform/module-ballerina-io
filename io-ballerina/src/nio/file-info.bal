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

import ballerina/time;

# Stat record contains metadata information of a file.
# This record is returned by getFileInfo function in file module.
# + name - Name of the file
# + size - Size of the file(in bytes)
# + modifiedTime - The last modified time of the file
# + dir - Whether the file is a directory or not
# + absPath -  Absolute path of the file
public type Stat record {|
    string name;
    int size;
    time:Time modifiedTime;
    boolean dir;
    string absPath;
|}
