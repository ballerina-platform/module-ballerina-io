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
import java.nio.ByteBuffer;
import java.nio.channels.ByteChannel;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;

/**
 * The unit test of the BlobChannel class.
 */
public class BlobChannelTest {

    private String currentDirectoryPath = "/tmp/";

    @BeforeSuite
    public void setup() {

        currentDirectoryPath = System.getProperty("user.dir") + "/build/";
    }

    @Test(description = "Test read and write operations of the BlobChannel")
    public void readAndWrite() throws IOException, URISyntaxException {

        ByteChannel readByteChannel = TestUtil.openForReading("datafiles/io/text/charfile.txt");
        BlobChannel readBlobChannel = new BlobChannel((ReadableByteChannel) readByteChannel);
        ByteChannel writeByteChannel = TestUtil.openForReadingAndWriting(currentDirectoryPath + "blobChannel.txt");
        BlobChannel writeBlobChannel = new BlobChannel((WritableByteChannel) writeByteChannel);
        char[] expectedArr = {'1', '2', '3', '4', '5', '6'};
        int i = 0;

        ByteBuffer byteBuffer = ByteBuffer.allocate(30);
        Assert.assertTrue(readBlobChannel.isReadable());
        Assert.assertEquals(readBlobChannel.read(byteBuffer), 6);
        ByteBuffer copyOfByteBuffer = byteBuffer.duplicate();
        copyOfByteBuffer.flip();
        byteBuffer.flip();
        while (copyOfByteBuffer.hasRemaining()) {
            Assert.assertEquals((char) copyOfByteBuffer.get(), expectedArr[i]);
            i++;
        }
        readBlobChannel.close();
        Assert.assertEquals(writeBlobChannel.write(byteBuffer), 6);
        writeBlobChannel.close();
    }

    @Test(expectedExceptions = UnsupportedOperationException.class)
    public void readWithNull() throws IOException {

        BlobChannel blobChannel = new BlobChannel(getReadableByteChannel());
        ByteBuffer byteBuffer = ByteBuffer.allocate(30);
        blobChannel.read(byteBuffer);
    }

    @Test(expectedExceptions = UnsupportedOperationException.class)
    public void writeWithNull() throws IOException {

        BlobChannel blobChannel = new BlobChannel(getWritableByteChannel());
        ByteBuffer byteBuffer = ByteBuffer.allocate(30);
        blobChannel.write(byteBuffer);
    }

    private ReadableByteChannel getReadableByteChannel() {

        return null;
    }

    private WritableByteChannel getWritableByteChannel() {

        return null;
    }
}
