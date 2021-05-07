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

package org.ballerinalang.stdlib.io.util;

import org.ballerinalang.stdlib.io.utils.Base64ByteChannel;
import org.ballerinalang.stdlib.io.utils.Base64Wrapper;
import org.testng.Assert;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.channels.ByteChannel;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * The unit test of the Base64Wrapper class.
 */
public class Base64WrapperTest {

    private String currentDirectoryPath = "/tmp/";

    @BeforeSuite
    public void setup() {

        currentDirectoryPath = System.getProperty("user.dir") + "/build/";
    }

    @Test(expectedExceptions = UnsupportedOperationException.class)
    public void transfer() throws IOException, URISyntaxException {

        String resourceFile = currentDirectoryPath + "base64File2.txt";
        Path resourceFilePath = Paths.get(resourceFile);
        Files.write(resourceFilePath, "123456".getBytes(StandardCharsets.UTF_8));
        ByteChannel byteChannel = TestUtil.openForReadingAndWriting(resourceFile);
        Base64ByteChannel base64ByteChannel = new Base64ByteChannel(Files.newInputStream(resourceFilePath));
        Base64Wrapper base64Wrapper = new Base64Wrapper(base64ByteChannel);
        base64Wrapper.transfer(0, 1, byteChannel);
    }

    @Test(expectedExceptions = UnsupportedOperationException.class)
    public void getChannel() throws IOException, URISyntaxException {

        String resourceFile = currentDirectoryPath + "base64File2.txt";
        Path resourceFilePath = Paths.get(resourceFile);
        Files.write(resourceFilePath, "123456".getBytes(StandardCharsets.UTF_8));
        Base64ByteChannel base64ByteChannel = new Base64ByteChannel(Files.newInputStream(resourceFilePath));
        Base64Wrapper base64Wrapper = new Base64Wrapper(base64ByteChannel);
        base64Wrapper.getChannel();
    }

    @Test(description = "Test remaining API of BlobIOChannelTest")
    public void remaining() throws IOException, URISyntaxException {

        String resourceFile = currentDirectoryPath + "base64File2.txt";
        Path resourceFilePath = Paths.get(resourceFile);
        Files.write(resourceFilePath, "123456".getBytes(StandardCharsets.UTF_8));
        Base64ByteChannel base64ByteChannel = new Base64ByteChannel(Files.newInputStream(resourceFilePath));
        Base64Wrapper base64Wrapper = new Base64Wrapper(base64ByteChannel);
        Assert.assertFalse(base64Wrapper.remaining());
    }

}
