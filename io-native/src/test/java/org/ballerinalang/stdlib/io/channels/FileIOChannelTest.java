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

package org.ballerinalang.stdlib.io.channels;

import org.ballerinalang.stdlib.io.util.TestUtil;
import org.testng.Assert;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.channels.ByteChannel;
import java.nio.channels.FileChannel;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * The unit test of the FileIOChannel class.
 */
public class FileIOChannelTest {

    private String currentDirectoryPath = "/tmp/";

    @BeforeSuite
    public void setup() {

        currentDirectoryPath = System.getProperty("user.dir") + "/build/";
    }

    @Test(description = "Test data transferring of FileIOChannelTest")
    public void transfer() throws IOException, URISyntaxException {

        String resourceFilePath = "datafiles/io/text/charfile.txt";
        String destinationFilePath = currentDirectoryPath + "fileIOChannel1.txt";
        ByteChannel readByteChannel = TestUtil.openForReading(resourceFilePath);
        ByteChannel writeByteChannel = TestUtil.openForReadingAndWriting(destinationFilePath);
        FileIOChannel fileIOChannel = new FileIOChannel((FileChannel) readByteChannel);

        fileIOChannel.transfer(0, 5, writeByteChannel);
        String content = Files.readString(Paths.get(destinationFilePath), StandardCharsets.UTF_8);
        Assert.assertEquals(content, "12345");
    }

    @Test(expectedExceptions = UnsupportedOperationException.class)
    public void getChannel() throws IOException, URISyntaxException {

        String resourceFilePath = "datafiles/io/text/charfile.txt";
        ByteChannel readByteChannel = TestUtil.openForReading(resourceFilePath);
        FileIOChannel fileIOChannel = new FileIOChannel((FileChannel) readByteChannel);
        fileIOChannel.getChannel();
    }

    @Test(description = "Test remaining API of FileIOChannelTest")
    public void remaining() throws IOException, URISyntaxException {

        String resourceFilePath = "datafiles/io/text/charfile.txt";
        ByteChannel readByteChannel = TestUtil.openForReading(resourceFilePath);
        FileIOChannel fileIOChannel = new FileIOChannel((FileChannel) readByteChannel);
        Assert.assertFalse(fileIOChannel.remaining());
    }

}
