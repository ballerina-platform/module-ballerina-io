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
import ballerina/jballerina.java;

# Represents a readable CSV channel which could be used to read records from CSV file.
public class ReadableCSVChannel {
    private ReadableTextRecordChannel? dc;

    # Initializes a readable CSV channel.
    #
    # + byteChannel - The `io:ReadableCharacterChannel`, which will represent the content in the CSV file
    # + fs - The field separator, which will separate between the records in the CSV file
    # + nHeaders - Number of headers, which should be skipped prior to reading records
    public isolated function init(ReadableCharacterChannel byteChannel, Separator fs = ",", int nHeaders = 0) {
        if fs == TAB {
            self.dc = new ReadableTextRecordChannel(byteChannel, fmt = "TDF");
        } else if fs == COLON {
            self.dc = new ReadableTextRecordChannel(byteChannel, FS_COLON, CSV_RECORD_SEPARATOR);
        } else if fs == COMMA {
            self.dc = new ReadableTextRecordChannel(byteChannel, fmt = "CSV");
        } else {
            self.dc = new ReadableTextRecordChannel(byteChannel, fs, CSV_RECORD_SEPARATOR);
        }
        self.skipHeaders(nHeaders);
    }

    # Skips the given number of headers.
    # ```ballerina
    # readableCSVChannel.skipHeaders(5);
    # ```
    #
    # + nHeaders - The number of headers, which should be skipped
    public isolated function skipHeaders(int nHeaders) {
        int count = MINIMUM_HEADER_COUNT;
        boolean errorOccurred = false;
        while (count < nHeaders) && !errorOccurred {
            string[]|Error? result = self.getNext();
            if result is string[]? {
                count = count + 1;
            } else {
                errorOccurred = true;
            }
        }
    }

    # Checks if there is another record available to be read from the CSV channel.
    # ```ballerina
    # boolean hasNext = readableCSVChannel.hasNext();
    # ```
    #
    # + return - True if there is another record available
    public isolated function hasNext() returns boolean {
        var recordChannel = self.dc;
        if recordChannel is ReadableTextRecordChannel {
            return recordChannel.hasNext();
        } else {
            GenericError e = error GenericError("channel not initialized");
            panic e;
        }
    }

    # Gets the next record from the CSV file.
    # ```ballerina
    # string[]|io:Error? record = readableCSVChannel.getNext();
    # ```
    #
    # + return - List of fields in the CSV or else an `io:Error`
    public isolated function getNext() returns string[]|Error? {
        if self.dc is ReadableTextRecordChannel {
            var result = <ReadableTextRecordChannel>self.dc;
            return result.getNext();
        }
        return;
    }

    # Returns a CSV record stream that can be used to CSV records as a stream.
    # ```ballerina
    # stream<string[], io:Error>|io:Error? record = readableCSVChannel.csvStream();
    # ```
    #
    # + return - A stream of records(string[]) or else an `io:Error`
    public isolated function csvStream() returns stream<string[], Error?>|Error {
        var recordChannel = self.dc;
        if recordChannel is ReadableTextRecordChannel {
            CSVStream csvStream = new (recordChannel);
            return new stream<string[], Error?>(csvStream);
        } else {
            GenericError e = error GenericError("channel not initialized");
            panic e;
        }
    }

    # Closes the readable CSV channel to release any underlying resources.
    # After a channel is closed, any further reading operations will cause an error.
    # ```ballerina
    # io:Error? err = readableCSVChannel.close();
    # ```
    #
    # + return - An `io:Error` if any error occurred
    public isolated function close() returns Error? {
        if self.dc is ReadableTextRecordChannel {
            var result = <ReadableTextRecordChannel>self.dc;
            return result.close();
        }
        return;
    }

    # Returns a table, which corresponds to the CSV records.
    # ```ballerina
    # var tblResult1 = readableCSVChannel.getTable(Employee);
    # var tblResult2 = readableCSVChannel.getTable(Employee, ["id", "name"]);
    # ```
    #
    # + structType - The object in which the CSV records should be deserialized
    # + fieldNames - The names of the fields used as the (composite) key of the table
    # + return - Table, which represents the CSV records or else an `io:Error`
    #
    # # Deprecated
    # This function is deprecated due to the introduction of `ReadableCSVChannel.toTable()`, making 'fieldNames' a mandatory parameter
    @deprecated
    public isolated function getTable(typedesc<record {}> structType, string[] fieldNames = []) returns table<record {}>|
    Error {
        return toTableExtern(self, structType, fieldNames);
    }

    # Returns a table, which corresponds to the CSV records.
    # ```ballerina
    # var tblResult = readableCSVChannel.toTable(Employee, ["id", "name"]);
    # ```
    #
    # + structType - The object in which the CSV records should be deserialized
    # + keyFieldNames - The names of the fields used as the (composite) key of the table
    # + return - Table, which represents the CSV records or else an `io:Error`
    public isolated function toTable(typedesc<record {}> structType, string[] keyFieldNames) returns table<record {}>|
    Error {
        return toTableExtern(self, structType, keyFieldNames);
    }
}

isolated function toTableExtern(ReadableCSVChannel csvChannel, typedesc<record {}> structType, string[] keyFieldNames) returns table<record {}>|
Error = @java:Method {
    name: "toTable",
    'class: "io.ballerina.stdlib.io.nativeimpl.ToTable"
} external;
