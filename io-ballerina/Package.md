## Package Overview

The following diagram depicts the overview architecture of the I/O package.

![architecture](./resources/package-architecture.svg)

The I/O package allows users to read from the console or a file. 
Further, the file I/O operations can be categorized based on serialization and deserialization types such as:
- Bytes I/O
- Strings I/O
- CSV I/O
- JSON I/O
- XML I/O


### Console I/O
The console I/O APIs are as follows, which helps the user to read from the console as well as write to the console.
- print
- println
- readln
- sprintf

### Bytes I/O
The bytes I/O APIs provide the reading and writing APIs in both streaming and non-streaming ways. Those APIs are,
- `io:fileReadBytes`
- `io:fileReadBlocksAsStream`
- `io:fileWriteBytes`
- `io:fileWriteBlocksFromStream`

Refer [this example](https://ballerina.io/swan-lake/learn/by-example/byte-io.html) to learn how to use bytes read and write APIs.

### Strings I/O
The strings I/O APIs provide the reading and writing APIs in 3 different ways:
1. read the whole file content as a string and write a given string to a file
1. read the whole file content as a set of lines and write a given set of lines to a file
1. read the whole file content as a stream of lines and write a given stream of lines to a file

The strings I/O APIs are as follows:
- `io:fileReadString`
- `io:fileReadLines`
- `io:fileReadLinesAsStream`
- `io:fileWriteLines`
- `io:fileWriteLinesFromStream`

Refer [this example](https://ballerina.io/swan-lake/learn/by-example/strings-io.html) to learn how to use bytes read and write APIs.

### CSV I/O
The CSV I/O APIs provide the reading and writing APIs in both streaming and non-streaming ways. Those APIs are,
- `io:fileReadCsv`
- `io:fileReadCsvAsStream`
- `io:fileWriteCsv`
- `io:fileWriteCsvFromStream`

Refer [this example](https://ballerina.io/swan-lake/learn/by-example/csv-io.html) to learn how to use CSV read and write APIs.

### JSON I/O
The JSON I/O APIs provide the reading and writing APIs for JSON content. Those APIs are,
- `io:fileReadJson`
- `io:fileWriteJson`

Refer [this example](https://ballerina.io/swan-lake/learn/by-example/json-io.html) to learn how to use JSON read and write APIs.

### XML I/O
The XML I/O APIs provide the reading and writing APIs for XML content. Those APIs are,
- `io:fileReadXml`
- `io:fileWriteXml`

Refer [this example](https://ballerina.io/swan-lake/learn/by-example/json-io.html) to learn how to use XML read and write APIs.
