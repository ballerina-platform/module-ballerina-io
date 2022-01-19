# Salesforce Bulk Processing 

## Overview

This example demonstrates the usage of I/O CSV streaming APIs directly with the Ballerina Salesforce connector APIs.

## Implementation

To run this example, you have to first create a Salesforce account and get an authentication token to connect to it. For more information about creating a Salesforce authentication token, refer to [this documentation](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/quickstart_oauth.htm).

Before running the example, you have to set the following Ballerina configurable variables in the `Config.toml` file.
```toml
BASE_URL="<SALESFORCE_BASE_URL>"
SF_TOKEN="<SALESFORCE_AUTH_TOKEN>"
```

This example first reads the given CSV contact details using I/O streaming APIs as follows.

```ballerina
stream<string[], io:Error?> csvStream = check io:fileReadCsvAsStream(csvContactsFilePath);
```

Then, pass these contact details stream to the Salesforce bulk API to create a new set of contacts in Salesforce. 

```ballerina
sbulk:BulkJob queryJob = check baseClient->createJob("insert", "Contact", "CSV");
sbulk:BatchInfo batch = check baseClient->addBatch(queryJob, csvStream);
```

Refer to [this documentation](https://central.ballerina.io/ballerinax/salesforce) to learn more about the Ballerina Salesforce APIs.


## Run the Example

First, clone this repository, and then run the following commands to run the example on your local machine.

```sh
$ cd examples/salesforce
$ bal run
```
