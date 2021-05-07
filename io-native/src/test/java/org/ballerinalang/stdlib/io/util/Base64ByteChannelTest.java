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
import org.testng.Assert;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * The unit test of the Base64ByteChannel class.
 */
public class Base64ByteChannelTest {

    private String currentDirectoryPath = "/tmp/";

    @BeforeSuite
    public void setup() {

        currentDirectoryPath = System.getProperty("user.dir") + "/build/";
    }

    @Test(description = "Test creation and deletion of Base64ByteChannelTest")
    public void write() throws IOException, URISyntaxException {

        Path resourceFilePath = Paths.get(currentDirectoryPath + "base64File1.txt");
        Files.write(resourceFilePath, "123456".getBytes(StandardCharsets.UTF_8));
        Base64ByteChannel base64ByteChannel = new Base64ByteChannel(Files.newInputStream(resourceFilePath));
        ByteBuffer byteBuffer =  ByteBuffer.allocate(10);
        Assert.assertEquals(base64ByteChannel.read(byteBuffer), 6);
        Assert.assertEquals(base64ByteChannel.write(byteBuffer), 0);
        base64ByteChannel.close();
    }

}
