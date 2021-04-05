# Change Log
This file contains all the notable changes done to the Ballerina I/O package through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.0-alpha6] - 2021-04-02

### Added
- Improve the print APIs to support raw templates.
    ```ballerina
    string val = "John";
    io:println(`Hello ${val}!!!`);
    io:print(`Hello ${val}!!!`);
    ```
### Changed
- Introduce nil completion to the I/O streams(lines, blocks, and CSV). 
