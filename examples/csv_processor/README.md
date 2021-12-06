# CSV Processor

## Overview

CSV processor is an example that demonstrates the usage of CSV stream in the Ballerina I/O standard library.

## Implementation

This sample implementation reads a large CSV file (with nearly 0.2 million) records and provides summarized results. The dataset is as follows.

```csv
duration (ms),status,error
228.92,OK,
227.24,OK,
229.47,OK,
```

The columns of the dataset are as follows.
1. The first column contains the response time of each request in milliseconds
2. The second column has the response status (e.g., OK, PermissionDenied, or Unavailable etc.)
3. Third column state, if there is an error, the relevant error message

This example uses the output result of Ballerina gRPC performance tests and returns the average running time, number of successful cases, and number of failure cases as the output. The first task of the example is to read the given CSV file as a stream.

```ballerina
stream<string[], io:Error?> performanceDataStream = check io:fileReadCsvAsStream("resources/grpc_performance_output.csv");
```

Then, it iterates through the result stream to read each entry and return the summarized performance results.

## Run the Example

First, clone this repository, and then run the following commands to run the example on your local machine.

```sh
$ cd examples/csv_processor
$ bal run
```
