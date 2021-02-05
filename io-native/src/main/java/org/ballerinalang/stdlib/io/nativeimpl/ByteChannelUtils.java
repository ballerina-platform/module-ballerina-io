/*
 * Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import org.ballerinalang.stdlib.io.channels.AbstractNativeChannel;
import org.ballerinalang.stdlib.io.channels.BlobChannel;
import org.ballerinalang.stdlib.io.channels.BlobIOChannel;
import org.ballerinalang.stdlib.io.channels.FileIOChannel;
import org.ballerinalang.stdlib.io.channels.base.Channel;
import org.ballerinalang.stdlib.io.utils.BallerinaIOException;
import org.ballerinalang.stdlib.io.utils.IOConstants;
import org.ballerinalang.stdlib.io.utils.IOUtils;
import org.ballerinalang.stdlib.io.utils.Utils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ClosedChannelException;
import java.nio.channels.FileChannel;
import java.nio.channels.ReadableByteChannel;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import static org.ballerinalang.stdlib.io.utils.IOConstants.BYTE_CHANNEL_NAME;

/**
 * This class hold Java inter-ops bridging functions for io# *ByteChannels.
 *
 * @since 1.1.0
 */
public class ByteChannelUtils extends AbstractNativeChannel {

    private static final Logger log = LoggerFactory.getLogger(ByteChannelUtils.class);
    private static final String STREAM_BLOCK_ENTRY = "value";

    private ByteChannelUtils() {
    }

    public static Object read(BObject channel, long nBytes) {
        int arraySize = nBytes <= 0 ? IOConstants.CHANNEL_BUFFER_SIZE : (int) nBytes;
        Channel byteChannel = (Channel) channel.getNativeData(BYTE_CHANNEL_NAME);
        ByteBuffer content = ByteBuffer.wrap(new byte[arraySize]);
        if (byteChannel.hasReachedEnd()) {
            return IOUtils.createEoFError();
        } else {
            try {
                byteChannel.read(content);
                return ValueCreator.createArrayValue(getContentData(content));
            } catch (Exception e) {
                String msg = "error occurred while reading bytes from the channel. " + e.getMessage();
                log.error(msg, e);
                return IOUtils.createError(msg);
            }
        }
    }

    public static Object readAll(BObject channel) {
        try {
            BufferedInputStream bufferedInputStream = getBufferedInputStream(channel);
            if (bufferedInputStream != null) {
                return ValueCreator.createArrayValue(bufferedInputStream.readAllBytes());
            }
            return IOUtils.createError("BufferedInputStream is not initialized");
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
    }

    public static Object readBlock(BObject channel, long blockSize) {
        int blockSizeInt = (int) blockSize;
        byte[] buffer = new byte[blockSizeInt];
        try {
            BufferedInputStream bufferedInputStream = getBufferedInputStream(channel);
            if (bufferedInputStream != null) {
                int n = bufferedInputStream.read(buffer, 0, blockSizeInt);
                if (n == -1) {
                    bufferedInputStream.close();
                    return IOUtils.createEoFError();
                }
                Map<String, Object> map = new HashMap<>();
                map.put(STREAM_BLOCK_ENTRY, ValueCreator.createArrayValue(buffer));
                return ValueCreator.createArrayValue(buffer);
            }
            return IOUtils.createError("BufferedInputStream is not initialized");
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
    }

    private static byte[] getContentData(final ByteBuffer contentBuffer) {
        int bufferSize = contentBuffer.limit();
        int readPosition = contentBuffer.position();
        byte[] content = contentBuffer.array();
        final int startPosition = 0;
        if (readPosition == bufferSize) {
            return content;
        }
        return Arrays.copyOfRange(content, startPosition, readPosition);
    }

    public static Object base64Encode(BObject channel) {
        return Utils.encodeByteChannel(channel, false);
    }

    public static Object base64Decode(BObject channel) {
        return Utils.decodeByteChannel(channel, false);
    }

    public static Object closeByteChannel(BObject channel) {
        Channel byteChannel = (Channel) channel.getNativeData(BYTE_CHANNEL_NAME);
        try {
            BufferedInputStream bufferedInputStream = getBufferedInputStream(channel);
            if (bufferedInputStream != null) {
                bufferedInputStream.close();
            }
            byteChannel.close();
        } catch (ClosedChannelException e) {
            return IOUtils.createError("channel already closed.");
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
        return null;
    }

    public static Object closeInputStream(BObject channel) {
        try {
            BufferedInputStream bufferedInputStream = getBufferedInputStream(channel);
            if (bufferedInputStream != null) {
                bufferedInputStream.close();
            }
            return null;
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
    }

    public static Object write(BObject channel, BArray content, long offset) {
        Channel byteChannel = (Channel) channel.getNativeData(BYTE_CHANNEL_NAME);
        ByteBuffer writeBuffer = ByteBuffer.wrap(content.getBytes());
        writeBuffer.position((int) offset);
        try {
            return byteChannel.write(writeBuffer);
        } catch (IOException e) {
            log.error("Error occurred while writing to the channel.", e);
            return IOUtils.createError(e);
        }
    }

    public static Object openReadableFile(BString pathUrl) {
        BObject readableByteChannel;
        try {
            readableByteChannel = createChannel(inFlow(pathUrl.getValue(), IOConstants.FileOpenOption.READ));
            Channel channel = (Channel) readableByteChannel.getNativeData(IOConstants.BYTE_CHANNEL_NAME);
            BufferedInputStream bufferedInputStream = new BufferedInputStream(channel.getInputStream());
            readableByteChannel.addNativeData(
                    IOConstants.BUFFERED_INPUT_STREAM_ENTRY,
                    bufferedInputStream
            );
        } catch (BallerinaIOException | IOException e) {
            return IOUtils.createError(e);
        } catch (BError e) {
            return e;
        }
        return readableByteChannel;
    }

    public static Object openWritableFile(BString pathUrl, BString option) {
        try {
            if (IOConstants.FileOpenOption.OVERWRITE.name().equals(option.getValue())) {
                return createChannel(inFlow(pathUrl.getValue(), IOConstants.FileOpenOption.OVERWRITE));
            } else {
                return createChannel(inFlow(pathUrl.getValue(), IOConstants.FileOpenOption.APPEND));
            }
        } catch (BallerinaIOException e) {
            return IOUtils.createError(e);
        } catch (BError e) {
            return e;
        }
    }

    public static Object createReadableChannel(BArray content) {
        try {
            Channel channel = inFlow(content);
            return createChannel(channel);
        } catch (Exception e) {
            return IOUtils.createError(e);
        }
    }

    private static Channel inFlow(String pathUrl, IOConstants.FileOpenOption option) throws BallerinaIOException {
        Path path = Paths.get(pathUrl);
        FileChannel fileChannel;
        Channel channel;
        if (option.equals(IOConstants.FileOpenOption.READ)) {
            fileChannel = IOUtils.openFileChannelExtended(path, option);
            channel = new FileIOChannel(fileChannel);
            channel.setReadable(true);
        } else {
            fileChannel = IOUtils.openFileChannelExtended(path, option);
            channel = new FileIOChannel(fileChannel);
        }
        return channel;
    }

    private static Channel inFlow(BArray contentArr) {
        byte[] content = shrink(contentArr);
        ByteArrayInputStream contentStream = new ByteArrayInputStream(content);
        ReadableByteChannel readableByteChannel = Channels.newChannel(contentStream);
        return new BlobIOChannel(new BlobChannel(readableByteChannel));
    }

    private static byte[] shrink(BArray array) {
        int contentLength = array.size();
        byte[] content = new byte[contentLength];
        System.arraycopy(array.getBytes(), 0, content, 0, contentLength);
        return content;
    }

    private static BufferedInputStream getBufferedInputStream(BObject channel) throws IOException {
        if (channel.getNativeData(IOConstants.BUFFERED_INPUT_STREAM_ENTRY) != null) {
            return (BufferedInputStream) channel.getNativeData(IOConstants.BUFFERED_INPUT_STREAM_ENTRY);
        } else {
            Channel byteChannel = (Channel) channel.getNativeData(BYTE_CHANNEL_NAME);
            BufferedInputStream bufferedInputStream = new BufferedInputStream(byteChannel.getInputStream());
            channel.addNativeData(
                    IOConstants.BUFFERED_INPUT_STREAM_ENTRY,
                    bufferedInputStream
            );
            return bufferedInputStream;
        }
    }
}
