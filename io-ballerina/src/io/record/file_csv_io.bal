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

# Read file content as a CSV.
# ```ballerina
# string[][]|io:Error content = io:fileReadCsv("./resources/myfile.csv");
# ```
# + path - File path
# + fieldSeparator - Field separator (this could be a regex)
# + skipHeaders - Number of headers, which should be skipped prior to reading records
# + return - Either an array of string arrays or `io:Error`
public function fileReadCsv(@untainted string path,
                        Separator fieldSeparator = ",",
                        int skipHeaders = 0) returns @tainted readonly & string[][]|Error {
	
	var csvFileOpenResult = openReadableCsvFile(path, fieldSeparator, DEFAULT_ENCODING, skipHeaders);
	if (csvFileOpenResult is ReadableCSVChannel) {
	    string[][] results = [];
	    int i = 0;
	    
	    while (csvFileOpenResult.hasNext()) {
	        var records = csvFileOpenResult.getNext();
	        if (records is string[]) {
	            results[i] = records;
	            i += 1;
	        } else if (records is Error) {
	            var fileClosingResult = csvFileOpenResult.close();
                return records;
	        }
	    }
	    var fileClosingResult = csvFileOpenResult.close();
	    if (fileClosingResult is Error) {
	        return fileClosingResult;
	    }
	    return <readonly & string[][]> results.cloneReadOnly();
	} else {
	    return csvFileOpenResult;
	}
}

# Write CSV content to a file.
# ```ballerina
# string[][] content = [["Anne", "Johnson", "SE"], ["John", "Cameron", "QA"]];
# io:Error? result = io:fileWriteCsv("./resources/myfile.csv", content);
# ```
# + path - File path
# + content - CSV content as an array of string arrays
# + fieldSeparator - CSV record separator (i.e., comma or tab)
# + skipHeaders - Number of headers, which should be skipped
# + return - `io:Error` or else `()`
public function fileWriteCsv(@untainted string path,
                         string[][] content,
                         Separator fieldSeparator = ",",
                         int skipHeaders = 0) returns Error? {
	var csvFileOpenResult = openWritableCsvFile(path, fieldSeparator, DEFAULT_ENCODING, skipHeaders);
	if (csvFileOpenResult is WritableCSVChannel) {
        foreach string[] r in content {
            var writeResult = csvFileOpenResult.write(r);
            if (writeResult is Error) {
                var fileClosingResult = csvFileOpenResult.close();
                return writeResult;
            }
        }
        var fileClosingResult = csvFileOpenResult.close();
        if (fileClosingResult is Error) {
            return fileClosingResult;
        }
    } else {
        return csvFileOpenResult;
    }
}
