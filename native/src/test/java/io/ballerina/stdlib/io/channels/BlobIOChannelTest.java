/*
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.io.channels;

import io.ballerina.stdlib.io.util.TestUtil;
import org.testng.Assert;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.channels.ByteChannel;
import java.nio.channels.ReadableByteChannel;

/**
 * The unit test of the BlobIOChannel class.
 */
public class BlobIOChannelTest {

    private String currentDirectoryPath = "/tmp/";

    @BeforeSuite
    public void setup() {

        currentDirectoryPath = System.getProperty("user.dir") + "/build/";
    }

    @Test(expectedExceptions = UnsupportedOperationException.class)
    public void transfer() throws IOException, URISyntaxException {

        String resourceFilePath = "datafiles/io/text/charfile.txt";
        String destinationFilePath = currentDirectoryPath + "blobIoChannel1.txt";
        ByteChannel readByteChannel = TestUtil.openForReading(resourceFilePath);
        ByteChannel writeByteChannel = TestUtil.openForReadingAndWriting(destinationFilePath);
        BlobIOChannel blobIoChannel = new BlobIOChannel(new BlobChannel((ReadableByteChannel) readByteChannel));

        blobIoChannel.transfer(0, 5, writeByteChannel);
    }

    @Test(expectedExceptions = UnsupportedOperationException.class)
    public void getChannel() throws IOException, URISyntaxException {

        String resourceFilePath = "datafiles/io/text/charfile.txt";
        ByteChannel readByteChannel = TestUtil.openForReading(resourceFilePath);
        BlobIOChannel blobIoChannel = new BlobIOChannel(new BlobChannel((ReadableByteChannel) readByteChannel));
        blobIoChannel.getChannel();
    }

    @Test(description = "Test remaining API of BlobIOChannelTest")
    public void remaining() throws IOException, URISyntaxException {

        String resourceFilePath = "datafiles/io/text/charfile.txt";
        ByteChannel readByteChannel = TestUtil.openForReading(resourceFilePath);
        BlobIOChannel blobIoChannel = new BlobIOChannel(new BlobChannel((ReadableByteChannel) readByteChannel));
        Assert.assertFalse(blobIoChannel.remaining());
    }

}
