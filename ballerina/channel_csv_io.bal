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
import ballerina/lang.'value;

isolated function channelReadCsv(ReadableChannel readableChannel, int skipHeaders = 0) returns string[][]|
Error {
    ReadableCSVChannel csvChannel = check getReadableCSVChannel(readableChannel, skipHeaders);
    string[][] results = [];
    int i = 0;

    while csvChannel.hasNext() {
        var records = csvChannel.getNext();
        if records is string[] {
            results[i] = records;
            i += 1;
        } else if records is Error {
            check csvChannel.close();
            return records;
        }
    }
    check csvChannel.close();
    return results;
}

isolated function channelReadCsvAsStream(ReadableChannel readableChannel) returns stream<string[], Error?>|
Error {
    return (check getReadableCSVChannel(readableChannel, 0)).csvStream();
}

isolated function channelWriteCsv(string path, FileWriteOption option, string[][]|map<anydata>[] contentToWrite) returns Error? {
    if contentToWrite is string[][] {
        check writeStringArrayToCsvFile(path, contentToWrite, option);
    } else if contentToWrite is map<anydata>[] {
        string[] headers = [];
        if contentToWrite.length() == 0 {
            return;
        }
        headers = contentToWrite[0].keys();
        if option == APPEND {
            string[] headersFromCSV = check readHeadersFromCsvFile(path);
            headersFromCSV = check validateCsvHeaders(headersFromCSV, headers);
            return headersFromCSV.length() > 0 ? writeRecordsToCsvFile(path, contentToWrite, headersFromCSV, option, true)
                : writeRecordsToCsvFile(path, contentToWrite, headers, option, false);
        }
        check writeRecordsToCsvFile(path, contentToWrite, headers, option, false);
    }
    return;
}

isolated function channelWriteCsvFromStream(string path, FileWriteOption option, stream<string[]|map<anydata>, Error?> csvStreamToWrite) returns
Error? {
    if csvStreamToWrite is stream<string[], Error?> {
        WritableCSVChannel csvChannel = check getWritableCSVChannel(check openWritableCsvFile(path, option = option));
        do {
            record {|string[] value;|}|Error? csvRecordString = check csvStreamToWrite.next();
            while csvRecordString is record {|string[] value;|} {
                check csvChannel.write(csvRecordString.value);
                csvRecordString = csvStreamToWrite.next();
            }
        } on fail Error err {
            check csvStreamToWrite.close();
            check csvChannel.close();
            return err;
        }
        check csvChannel.close();
    } else if csvStreamToWrite is stream<map<anydata>, Error?> {
        boolean skipHeaders = false;
        string[] headersFromStream;
        record {|map<anydata> value;|}|Error? csvRecordMap = csvStreamToWrite.next();
        if (csvRecordMap is record {|map<anydata> value;|}) {
            headersFromStream = csvRecordMap["value"].keys();
        } else {
            check csvStreamToWrite.close();
            return;
        }
        if option == APPEND {
            string[] headersFromCSV = check readHeadersFromCsvFile(path);
            headersFromCSV = check validateCsvHeaders(headersFromCSV, headersFromStream);
            if headersFromCSV.length() != 0 {
                skipHeaders = true;
                headersFromStream = headersFromCSV;
            }
        }
        WritableCSVChannel csvChannel = check getWritableCSVChannel(check openWritableCsvFile(path, option = option));
        do {
            if !skipHeaders {
                check csvChannel.write(headersFromStream);
            }
            while csvRecordMap is record {|map<anydata> value;|} {
                string[] sValues = [];
                foreach string header in headersFromStream {
                    sValues.push(csvRecordMap["value"].get(header).toString());
                }
                check csvChannel.write(sValues);
                csvRecordMap = check csvStreamToWrite.next();
            }
        } on fail Error err {
            check csvChannel.close();
            check csvStreamToWrite.close();
            return err;
        }
        check csvChannel.close();
    }
    check csvStreamToWrite.close();
    return;
}

isolated function getReadableCSVChannel(ReadableChannel readableChannel, int skipHeaders) returns ReadableCSVChannel|
Error {
    ReadableCSVChannel readableCSVChannel;

    if readableChannel is ReadableByteChannel {
        ReadableCharacterChannel readableCharacterChannel = new (readableChannel, DEFAULT_ENCODING);
        readableCSVChannel = new ReadableCSVChannel(readableCharacterChannel, COMMA, skipHeaders);
    } else if readableChannel is ReadableCharacterChannel {
        readableCSVChannel = new ReadableCSVChannel(readableChannel, COMMA, skipHeaders);
    } else if readableChannel is ReadableCSVChannel {
        readableCSVChannel = readableChannel;
    } else {
        TypeMismatchError e = error TypeMismatchError("Expected ReadableByteChannel/ReadableCharacterChannel/ReadableCSVChannel but found a " +
        'value:toString(typeof readableChannel));
        return e;
    }
    return readableCSVChannel;
}

isolated function getWritableCSVChannel(WritableChannel writableChannel) returns WritableCSVChannel|Error {
    WritableCSVChannel writableCSVChannel;

    if writableChannel is WritableByteChannel {
        WritableCharacterChannel writableCharacterChannel = new (writableChannel, DEFAULT_ENCODING);
        writableCSVChannel = new WritableCSVChannel(writableCharacterChannel);
    } else if writableChannel is WritableCharacterChannel {
        writableCSVChannel = new WritableCSVChannel(writableChannel);
    } else if writableChannel is WritableCSVChannel {
        writableCSVChannel = writableChannel;
    } else {
        TypeMismatchError e = error TypeMismatchError("Expected WritableByteChannel/WritableCharacterChannel/WritableCSVChannel but found a " +
        'value:toString(typeof writableChannel));
        return e;
    }
    return writableCSVChannel;
}

isolated function readHeadersFromCsvFile(string path) returns string[]|Error {
    stream<string[], Error?>|Error csvContent = fileReadCsvAsStream(path);
    if csvContent is Error {
        if csvContent is FileNotFoundError {
            return [];
        } else {
            return error GenericError("Error while reading the headers from the CSV file. " + csvContent.message());
        }
    } else {
        do {
            var csvLine = check csvContent.next();
            return csvLine == () ? [] : csvLine["value"];
        } on fail Error err {
            check csvContent.close();
            return error GenericError("Error while reading the headers from the CSV file. " + err.message());
        }
    }
}

isolated function validateCsvHeaders(string[] headersFromCSV, string[] headers) returns string[]|Error {
    if headersFromCSV.length() == 0 { //this is a valid scenario and we need to override the content
        return [];
    } else if headers.length() != headersFromCSV.length() {
        return error GenericError(string `The CSV file content header count(${headersFromCSV.length()}) doesn't match with ballerina record field count(${headers.length().toString()}). `);
    }
    foreach string header in headers {
        int|Error? key = headersFromCSV.indexOf(header.trim());
        if key is Error || key is () {
            return error GenericError(string `The CSV file does not contain the header - ${header.trim()}. `);
        }
    }
    return headersFromCSV;
}

isolated function writeRecordsToCsvFile(string path, map<anydata>[] contentToWrite, string[] headers, FileWriteOption option, boolean skipHeaders) returns Error? {
    WritableCSVChannel csvChannel = check getWritableCSVChannel(check openWritableCsvFile(path, option = option));
    if !skipHeaders {
        Error? headerWriteResult = csvChannel.write(headers);
        if headerWriteResult is Error {
            check csvChannel.close();
            return headerWriteResult;
        }
    }
    foreach map<anydata> row in contentToWrite {
        string[] sValues = [];
        foreach string header in headers {
            sValues.push(row.get(header).toString());
        }
        Error? writeResult = csvChannel.write(sValues);
        if writeResult is Error {
            check csvChannel.close();
            return writeResult;
        }
    }
    check csvChannel.close();
}

isolated function writeStringArrayToCsvFile(string path, string[][] contentToWrite, FileWriteOption option) returns Error? {
    WritableCSVChannel csvChannel = check getWritableCSVChannel(check openWritableCsvFile(path, option = option));
    foreach string[] r in contentToWrite {
        Error? writeResult = csvChannel.write(r);
        if writeResult is Error {
            check csvChannel.close();
            return writeResult;
        }
    }
    check csvChannel.close();
}
