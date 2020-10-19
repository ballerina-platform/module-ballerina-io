/*
 * Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.ballerinalang.stdlib.io.nativeimpl;

import org.ballerinalang.jvm.api.BValueCreator;
import org.ballerinalang.jvm.api.values.BObject;
import org.ballerinalang.jvm.api.values.BString;
import org.ballerinalang.stdlib.io.utils.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import static org.ballerinalang.stdlib.io.utils.IOConstants.IO_PACKAGE_ID;

/**
 * This class hold Java inter-ops bridging functions byte streaming APIs.
 *
 */
public class ByteStreamUtils {
    private static final String READ_BYTE_STREAM_CLASS = "ReadableByteStream";
    private static final String BUFFERED_INPUT_STREAM_ENTRY = "bufferedInputSource";
    private static final String BLOCK_SIZE_ENTRY = "blockSize";
    private static final String STREAM_BLOCK_ENTRY = "value";
    private static final Logger log = LoggerFactory.getLogger(ByteStreamUtils.class);

    public static Object openReadableFileBufferedStream(BString filePath, long blockSizeLong) {
        BObject byteStreamObj = BValueCreator.createObjectValue(IO_PACKAGE_ID, ByteStreamUtils.READ_BYTE_STREAM_CLASS);
        int blockSize = (int) blockSizeLong;
        if (blockSize <= 0) {
            return IOUtils.createError("The specified block size is " +
                    blockSize + ". It should be a value greater than zero");
        }
        try {
            FileInputStream fileInputStream = new FileInputStream(filePath.getValue());
            BufferedInputStream bufferedInputStream = new BufferedInputStream(fileInputStream, blockSize);
            byteStreamObj.addNativeData(BUFFERED_INPUT_STREAM_ENTRY, bufferedInputStream);
            byteStreamObj.addNativeData(BLOCK_SIZE_ENTRY, blockSizeLong);
            return byteStreamObj;
        } catch (FileNotFoundException e) {
            log.error(e.toString());
            return IOUtils.createError(e);
        }
    }

    public static Object readBlock(BObject readableByteStreamObj) {
        BufferedInputStream bufferedInputStream = (BufferedInputStream)
                readableByteStreamObj.getNativeData(BUFFERED_INPUT_STREAM_ENTRY);
        long blockSizeLong = (long) readableByteStreamObj.getNativeData(BLOCK_SIZE_ENTRY);
        int blockSize = (int) blockSizeLong;
        byte[] buffer = new byte[blockSize];
        try {
            int n = bufferedInputStream.read(buffer, 0, blockSize);
            if (n == -1) {
                bufferedInputStream.close();
                return IOUtils.createEoFError();
            }
            Map<String, Object> map = new HashMap<>();
            map.put(STREAM_BLOCK_ENTRY, BValueCreator.createArrayValue(buffer));
            return BValueCreator.createArrayValue(buffer);
        } catch (IOException e) {
            log.error(e.toString());
            return IOUtils.createError(e.toString());
        }
    }

}
