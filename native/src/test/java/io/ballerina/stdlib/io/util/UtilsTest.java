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

package io.ballerina.stdlib.io.util;

import io.ballerina.runtime.api.values.BArray;
import io.ballerina.stdlib.io.utils.Utils;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * The unit test of the Utils class.
 */
public class UtilsTest {

    @Test(description = "Test encode and decode APIs of Utils")
    public void encodeAndDecodeString() throws IOException, URISyntaxException {

        String content = "Ballerina";
        Object encodedContent = Utils.encodeString(content, StandardCharsets.UTF_8.displayName(), false);
        byte[] decodedValue = Base64.getMimeDecoder().decode(encodedContent.toString()
                .getBytes(StandardCharsets.ISO_8859_1));
        Assert.assertEquals(new String(decodedValue, StandardCharsets.UTF_8.displayName()), content);
    }

    @Test(description = "Test encode and decode APIs of Utils with mime specified")
    public void encodeAndDecodeMimeString() throws IOException, URISyntaxException {

        String content = "Ballerina";
        Object encodedContent = Utils.encodeString(content, StandardCharsets.UTF_8.displayName(), true);
        byte[] decodedValue = Base64.getMimeDecoder().decode(encodedContent.toString()
                .getBytes(StandardCharsets.ISO_8859_1));
        Assert.assertEquals(new String(decodedValue, StandardCharsets.UTF_8.displayName()), content);
    }

    @Test(description = "Test encode and decode APIs of Utils")
    public void encodeAndDecodeBlob() throws IOException, URISyntaxException {

        String content = "Ballerina";
        BArray encodedContent = Utils.encodeBlob(content.getBytes(StandardCharsets.UTF_8), false);
        BArray decodedContent = Utils.decodeBlob(encodedContent.getByteArray(), false);
        Assert.assertEquals(new String(decodedContent.getBytes()), content);
    }

    @Test(description = "Test encode and decode APIs of Utils with mime specified")
    public void encodeAndDecodeMimeBlob() throws IOException, URISyntaxException {

        String content = "Ballerina";
        BArray encodedContent = Utils.encodeBlob(content.getBytes(StandardCharsets.UTF_8), true);
        BArray decodedContent = Utils.decodeBlob(encodedContent.getByteArray(), true);
        Assert.assertEquals(new String(decodedContent.getBytes()), content);
    }

}
