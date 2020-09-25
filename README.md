Ballerina IO Library
===================

  [![Build](https://github.com/ballerina-platform/module-ballerina-io/workflows/Build/badge.svg)](https://github.com/ballerina-platform/module-ballerina-io/actions?query=workflow%3ABuild)
  [![Daily build](https://github.com/ballerina-platform/module-ballerina-io/workflows/Daily%20build/badge.svg)](https://github.com/ballerina-platform/module-ballerina-io/actions?query=workflow%3A%22Daily+build%22)
  [![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerina-io.svg)](https://github.com/ballerina-platform/module-ballerina-io/commits/master)
  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The IO library is one of the standard library modules of the<a target="_blank" href="https://ballerina.io/"> Ballerina</a> language.

For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/byte-io.html).

## Building from the Source

### Setting Up the Prerequisites

* Download and install Java SE Development Kit (JDK) version 8 (from one of the following locations).

   * [Oracle](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
   
   * [OpenJDK](http://openjdk.java.net/install/index.html)
   
        > **Note:** Set the JAVA_HOME environment variable to the path name of the directory into which you installed JDK.

### Building the Source

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
## Contributing to Ballerina

As an open source project, Ballerina welcomes contributions from the community. 

You can also check for [open issues](https://github.com/ballerina-platform/module-ballerina-io/issues) that interest you. We look forward to receiving your contributions.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of Conduct

All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful Links

* Discuss about code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
* Chat live with us via our [Slack channel](https://ballerina.io/community/slack/).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
