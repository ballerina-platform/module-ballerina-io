// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Represents IO module related errors.
public type Error distinct error;

# This will return when connection timed out happen when try to connect to a remote host.
public type ConnectionTimedOutError distinct Error;

# Represents generic IO error. The detail record contains the information related to the error.
public type GenericError distinct Error;

# This will get returned due to file permission issues.
public type AccessDeniedError distinct Error;

# This will get returned if the file is not available in the given file path.
public type FileNotFoundError distinct Error;

# This will get returned when there is an mismatch of given type and the expected type.
public type TypeMismatchError distinct Error;

# This will get returned if read operations are performed on a channel after it closed.
public type EofError distinct Error;

# This will get returned if there is an invalid configuration.
public type ConfigurationError distinct Error;


