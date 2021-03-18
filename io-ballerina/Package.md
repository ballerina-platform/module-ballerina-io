## Package Overview

The following diagram depicts the overview architecture of the I/O package.

![architecture](./resources/package-architecture.svg)

The I/O package allows you to read from the console or a file. 
Further, the file I/O operations can be categorized based on serialization and deserialization types such as:
- Bytes I/O
- Strings I/O
- CSV I/O
- JSON I/O
- XML I/O


### Console I/O
The console I/O APIs, which help the user to read from the console as well as write to the console are as follows.
- print
- println
- readln

### Bytes I/O
The bytes I/O APIs provide the reading and writing APIs in both streaming and non-streaming ways. Those APIs are,
- `io:fileReadBytes`
- `io:fileReadBlocksAsStream`
- `io:fileWriteBytes`
- `io:fileWriteBlocksFromStream`

To learn how to use bytes read and write APIs, see the [Read/Write Bytes example](https://ballerina.io/learn/by-example/bytes-io.html).

### Strings I/O
The strings I/O APIs provide the reading and writing APIs in 3 different ways:
1. Read the whole file content as a string and write a given string to a file
1. Read the whole file content as a set of lines and write a given set of lines to a file
1. Read the whole file content as a stream of lines and write a given stream of lines to a file

The strings I/O APIs are as follows:
- `io:fileReadString`
- `io:fileReadLines`
- `io:fileReadLinesAsStream`
- `io:fileWriteLines`
- `io:fileWriteLinesFromStream`

To learn how to use strings read and write APIs, see the  [Read/Write Strings example](https://ballerina.io/learn/by-example/strings-io.html).

### CSV I/O
The CSV I/O APIs provide the reading and writing APIs in both streaming and non-streaming ways. Those APIs are,
- `io:fileReadCsv`
- `io:fileReadCsvAsStream`
- `io:fileWriteCsv`
- `io:fileWriteCsvFromStream`

To learn how to use CSV read and write APIs, see the [Read/Write CSV example](https://ballerina.io/learn/by-example/csv-io.html).

### JSON I/O
The JSON I/O APIs provide the reading and writing APIs for JSON content. Those APIs are,
- `io:fileReadJson`
- `io:fileWriteJson`

To learn how to use JSON read and write APIs, see the [Read/Write JSON example](https://ballerina.io/learn/by-example/json-io.html).

### XML I/O
The XML I/O APIs provide the reading and writing APIs for XML content. Those APIs are,
- `io:fileReadXml`
- `io:fileWriteXml`

To learn how to use XML read and write APIs, see the [Read/Write XML example](https://ballerina.io/learn/by-example/json-io.html).
