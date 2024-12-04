## Overview

This module provides file read/write APIs and console print/read APIs. The file APIs allow read and write operations on different kinds of file types such as bytes, text, CSV, JSON, and XML. Further, these file APIs can be categorized as streaming and non-streaming APIs.

The following diagram depicts the overview architecture of the I/O package.

![Architecture Diagram](https://raw.githubusercontent.com/ballerina-platform/module-ballerina-io/master/ballerina/docs/architecture.svg)

The file I/O operations can be categorized further based on the serialization and deserialization types such as:
- Bytes I/O
- Strings I/O
- CSV I/O
- JSON I/O
- XML I/O

### Console I/O
The console I/O APIs, which help you to read from the console as well as write to the console are as follows.
- `io:print`
- `io:println`
- `io:readln`

### Bytes I/O
The bytes I/O APIs provide the reading and writing APIs in both streaming and non-streaming ways. Those APIs are,
- `io:fileReadBytes`
- `io:fileReadBlocksAsStream`
- `io:fileWriteBytes`
- `io:fileWriteBlocksFromStream`

### Strings I/O
The strings I/O APIs provide the reading and writing APIs in 3 different ways:
1. Read the complete file content as a string and write a given string to a file
2. Read the complete file content as a set of lines and write a given set of lines to a file
3. Read the complete file content as a stream of lines and write a given stream of lines to a file

The strings I/O APIs are as follows:
- `io:fileReadString`
- `io:fileReadLines`
- `io:fileReadLinesAsStream`
- `io:fileWriteLines`
- `io:fileWriteLinesFromStream`

### CSV I/O
The CSV I/O APIs provide the reading and writing APIs in both streaming and non-streaming ways. Those APIs are:
- `io:fileReadCsv`
- `io:fileReadCsvAsStream`
- `io:fileWriteCsv`
- `io:fileWriteCsvFromStream`

### JSON I/O
The JSON I/O APIs provide the reading and writing APIs for JSON content. Those APIs are:
- `io:fileReadJson`
- `io:fileWriteJson`

### XML I/O
The XML I/O APIs provide the reading and writing APIs for XML content. Those APIs are:
- `io:fileReadXml`
- `io:fileWriteXml`
