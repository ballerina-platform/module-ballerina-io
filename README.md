Ballerina I/O Library
===================

  [![Build](https://github.com/ballerina-platform/module-ballerina-io/actions/workflows/build-timestamped-master.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerina-io/actions/workflows/build-timestamped-master.yml)
  [![codecov](https://codecov.io/gh/ballerina-platform/module-ballerina-io/branch/master/graph/badge.svg)](https://codecov.io/gh/ballerina-platform/module-ballerina-io)
  [![Trivy](https://github.com/ballerina-platform/module-ballerina-io/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerina-io/actions/workflows/trivy-scan.yml)
  [![GraalVM Check](https://github.com/ballerina-platform/module-ballerina-io/actions/workflows/build-with-bal-test-native.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerina-io/actions/workflows/build-with-bal-test-native.yml)
  [![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerina-io.svg)](https://github.com/ballerina-platform/module-ballerina-io/commits/master)
  [![Github issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-standard-library/module/io.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-standard-library/labels/module%2Fio)

This I/O library provides file read/write APIs and console print/read APIs. The file APIs allow read and write operations on different kinds of file types such as bytes, text, CSV, JSON, and XML. Further, these file APIs can be categorized as streaming and non-streaming APIs.

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

## Issues and projects 

Issues and Projects tabs are disabled for this repository as this is part of the Ballerina Standard Library. To report bugs, request new features, start new discussions, view project boards, etc. please visit Ballerina Standard Library [parent repository](https://github.com/ballerina-platform/ballerina-standard-library). 

This repository only contains the source code for the module.

## Build from the source

### Set up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 11 (from one of the following locations).

   * [Oracle](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html)
   
   * [OpenJDK](https://adoptium.net/)
   
        > **Note:** Set the JAVA_HOME environment variable to the path name of the directory into which you installed JDK.   
1. Export Github Personal access token with read package permissions as follows,
        
        export packageUser=<Username>
        export packagePAT=<Personal access token>

### Build the source

Execute the commands below to build from source.

1. To build the library:
   ```    
   ./gradlew clean build
   ```

1. To run the integration tests:
   ```
   ./gradlew clean test
   ```
1. To build the module without the tests:
   ```
   ./gradlew clean build -x test
   ```
1. To debug module implementation:
   ```
   ./gradlew clean build -Pdebug=<port>
   ./gradlew clean test -Pdebug=<port>
   ```
1. To debug the module with Ballerina language:
   ```
   ./gradlew clean build -PbalJavaDebug=<port>
   ./gradlew clean test -PbalJavaDebug=<port>
   ```
1. Publish ZIP artifact to the local `.m2` repository:
   ```
   ./gradlew clean build publishToMavenLocal
   ```
1. Publish the generated artifacts to the local Ballerina central repository:
   ```
   ./gradlew clean build -PpublishToLocalCentral=true
   ```
1. Publish the generated artifacts to the Ballerina central repository:
   ```
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open source project, Ballerina welcomes contributions from the community. 

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
* For more information go to [the I/O Package](https://lib.ballerina.io/ballerina/io/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
