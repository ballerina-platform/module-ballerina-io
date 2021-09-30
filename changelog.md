# Change Log
This file contains all the notable changes done to the Ballerina I/O package through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- [Introduce fprint and fprintln APIs](https://github.com/ballerina-platform/ballerina-standard-library/issues/1394)
- [Introduce toTable API](https://github.com/ballerina-platform/ballerina-standard-library/issues/1871)
- [Add support for reading quoted fields in fileReadCsvAsStream API](https://github.com/ballerina-platform/ballerina-standard-library/issues/1890)

## [v0.6.0-beta.1] - 2021-06-02
### Fixed
- [Fixes the unexpected error return](https://github.com/ballerina-platform/ballerina-standard-library/issues/1316)
- [Fixes the included and default parameter order in `io:fileWriteXml` API](https://github.com/ballerina-platform/ballerina-standard-library/issues/1346)

## [0.6.0-alpha6] - 2021-04-02
### Added
- [Improve the print APIs to support raw templates](https://github.com/ballerina-platform/ballerina-standard-library/issues/1050).
    ```ballerina
    string val = "John";
    io:println(`Hello ${val}!!!`);
    io:print(`Hello ${val}!!!`);
    ```
### Changed
- [Introduce nil completion to the I/O streams(lines, blocks, and CSV)](https://github.com/ballerina-platform/ballerina-standard-library/issues/1181). 
