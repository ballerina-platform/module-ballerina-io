# Change Log
This file contains all the notable changes done to the Ballerina I/O package through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
## [Unreleased]
### Changed
- [Fixed the issue related to maintaining order in writing CSV records](https://github.com/ballerina-platform/ballerina-standard-library/issues/3399)
- [Fixed the fileReadCsv and fileReadCsvAsStream APIs to maintain the order while reading CSV records](https://github.com/ballerina-platform/ballerina-standard-library/issues/3780)
- [Fixed the issue related to expected type in CSV data mapping](https://github.com/ballerina-platform/ballerina-standard-library/issues/3669)
- [Make some of the Java classes proper utility classes](https://github.com/ballerina-platform/ballerina-standard-library/issues/4901)
- [Remove Error logger in module-ballerina-io](https://github.com/ballerina-platform/ballerina-standard-library/issues/3083)

## [1.3.1] - 2022-11-29
### Changed
- [API docs updated](https://github.com/ballerina-platform/ballerina-standard-library/issues/3463)

## [1.3.0] - 2022-09-08
### Added
-[Add support for Data Mapping in CSV read/write operations](https://github.com/ballerina-platform/ballerina-standard-library/issues/2871)

### Fixed
- [Add decimal suuport to toTable API](https://github.com/ballerina-platform/ballerina-standard-library/issues/2884)


## [1.0.0] - 2021-10-08
### Added
- [Add support for reading quoted fields in fileReadCsvAsStream API](https://github.com/ballerina-platform/ballerina-standard-library/issues/1890)

### Fixed
- [Introduce toTable API](https://github.com/ballerina-platform/ballerina-standard-library/issues/1871)


## [0.6.0-beta.2] - 2021-07-06
### Added
- [Introduce fprint and fprintln APIs](https://github.com/ballerina-platform/ballerina-standard-library/issues/1394)

## [0.6.0-beta.1] - 2021-06-02
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
