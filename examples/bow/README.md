# Bag of Word Model Generator

## Overview

Bag-of-Word (BoW) is a mechanism used in Natural Language Processing (NLP) to extract features in documents and texts. This example implements a simple BoW model using Ballerina I/O operations.

## Implementation

The input for this program is a raw text file. The program reads the given raw-text file line by line as a stream using the following I/O API.

```ballerina
stream<string, io:Error?> lineStream = check io:fileReadLinesAsStream("./resources/data.txt");
```

Then process each line in the stream to generate the BoW model.

## Run the Example

First, clone this repository, and then run the following commands to run the example on your local machine.

```sh
$ cd examples/bow
$ bal run
```

Then provide the input value. This input value indicates the number of most frequent words users wants to retrieve. For example:

```
> Enter the frequency boundry value: 10
```

Here, the boundary value 10 means it gives the most frequent ten words along with their frequencies as a map.

```sh
Most frequent 10 words are:
{"ballerina":100,"grpc":59,"is":41,"the":176,"to":50,"and":49,"client":41,"service":53,"a":51,"rpc":52}
```
