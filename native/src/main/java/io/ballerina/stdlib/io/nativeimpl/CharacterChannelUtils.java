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

package io.ballerina.stdlib.io.nativeimpl;

import io.ballerina.runtime.api.utils.JsonUtils;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.XmlUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BXml;
import io.ballerina.stdlib.io.channels.base.Channel;
import io.ballerina.stdlib.io.channels.base.CharacterChannel;
import io.ballerina.stdlib.io.readers.CharacterChannelReader;
import io.ballerina.stdlib.io.utils.BallerinaIOException;
import io.ballerina.stdlib.io.utils.IOConstants;
import io.ballerina.stdlib.io.utils.IOUtils;
import io.ballerina.stdlib.io.utils.PropertyUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.channels.ClosedChannelException;
import java.nio.charset.UnsupportedCharsetException;
import java.util.StringJoiner;

import static io.ballerina.stdlib.io.utils.IOConstants.CHARACTER_CHANNEL_NAME;

/**
 * This class hold Java inter-ops bridging functions for io# *CharacterChannels.
 *
 * @since 1.1.0
 */
public class CharacterChannelUtils {

    private static final String BUFFERED_READER_ENTRY = "bufferedReader";
    private static final String NEW_LINE = "\n";
    private static final String IS_CLOSED = "isClosed";

    private CharacterChannelUtils() {

    }

    public static void initCharacterChannel(BObject characterChannel, BObject byteChannelInfo,
                                            BString encoding) {

        try {
            Channel byteChannel = (Channel) byteChannelInfo.getNativeData(IOConstants.BYTE_CHANNEL_NAME);
            CharacterChannel bCharacterChannel = new CharacterChannel(byteChannel, encoding.getValue());
            BufferedReader bufferedReader = new BufferedReader(new CharacterChannelReader(bCharacterChannel));
            characterChannel.addNativeData(CHARACTER_CHANNEL_NAME, bCharacterChannel);
            characterChannel.addNativeData(BUFFERED_READER_ENTRY, bufferedReader);
            characterChannel.addNativeData(IS_CLOSED, false);
        } catch (UnsupportedCharsetException e) {
            throw IOUtils.createError("Unsupported encoding type " + encoding.getValue());
        } catch (Exception e) {
            String message = "error occurred while converting byte channel to character channel: " + e.getMessage();
            throw IOUtils.createError(message);
        }
    }

    public static Object read(BObject channel, long numberOfCharacters) {

        CharacterChannel characterChannel = (CharacterChannel) channel.getNativeData(CHARACTER_CHANNEL_NAME);
        if (isChannelClosed(channel)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        if (characterChannel.hasReachedEnd()) {
            return IOUtils.createEoFError();
        } else {
            try {
                return StringUtils.fromString(characterChannel.read((int) numberOfCharacters));
            } catch (BallerinaIOException e) {
                return IOUtils.createError(e);
            }
        }
    }

    public static Object readLine(BObject channel) {

        if (isChannelClosed(channel)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        BufferedReader bufferedReader = (BufferedReader)
                channel.getNativeData(BUFFERED_READER_ENTRY);
        try {
            String line = bufferedReader.readLine();
            if (line == null) {
                bufferedReader.close();
                return IOUtils.createEoFError();
            }
            return StringUtils.fromString(line);
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
    }

    public static Object readAllLines(BObject channel) {

        if (isChannelClosed(channel)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        try {
            BufferedReader bufferedReader = (BufferedReader)
                    channel.getNativeData(BUFFERED_READER_ENTRY);
            String[] lines = bufferedReader.lines().toArray(String[]::new);
            return StringUtils.fromStringArray(lines);
        } catch (UncheckedIOException | BError e) {
            return IOUtils.createError(e);
        }

    }

    public static Object readString(BObject channel) {

        if (isChannelClosed(channel)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        try {
            BufferedReader bufferedReader = (BufferedReader)
                    channel.getNativeData(BUFFERED_READER_ENTRY);
            String[] lines = bufferedReader.lines().toArray(String[]::new);
            StringJoiner joiner = new StringJoiner(System.lineSeparator());
            for (int i = 0; i < lines.length; i++) {
                joiner.add(lines[i]);
            }
            return StringUtils.fromString(joiner.toString()
                    .replaceAll(System.lineSeparator(), "\n"));
        } catch (UncheckedIOException | BError e) {
            return IOUtils.createError(e);
        }
    }

    public static Object readJson(BObject channel) {

        if (isChannelClosed(channel)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        CharacterChannel charChannel = (CharacterChannel) channel.getNativeData(CHARACTER_CHANNEL_NAME);
        CharacterChannelReader reader = new CharacterChannelReader(charChannel);
        try {
            Object returnValue = JsonUtils.parse(reader,
                    JsonUtils.NonStringValueProcessingMode.FROM_JSON_STRING);
            if (returnValue instanceof String) {

                return StringUtils.fromString((String) returnValue);
            }
            return returnValue;
        } catch (BError e) {
            return IOUtils.createError(e);
        }
    }

    public static Object readXml(BObject channel) {

        if (isChannelClosed(channel)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        CharacterChannel charChannel = (CharacterChannel) channel.getNativeData(CHARACTER_CHANNEL_NAME);
        CharacterChannelReader reader = new CharacterChannelReader(charChannel);
        try {
            return XmlUtils.parse(reader);
        } catch (BError e) {
            return IOUtils.createError(e);
        }
    }

    public static Object readProperty(BObject channel, BString key, BString defaultValue) {

        if (isChannelClosed(channel)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        CharacterChannel charChannel = (CharacterChannel) channel.getNativeData(CHARACTER_CHANNEL_NAME);
        CharacterChannelReader reader = new CharacterChannelReader(charChannel);
        try {
            return PropertyUtils.readProperty(reader, key, defaultValue, Integer.toString(charChannel.id()));
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
    }

    public static Object readAllProperties(BObject channel) {

        if (isChannelClosed(channel)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        CharacterChannel charChannel = (CharacterChannel) channel.getNativeData(CHARACTER_CHANNEL_NAME);
        CharacterChannelReader reader = new CharacterChannelReader(charChannel);
        try {
            return PropertyUtils.readAllProperties(reader, Integer.toString(charChannel.id()));
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
    }

    public static Object close(BObject channel) {

        if (isChannelClosed(channel)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        CharacterChannel charChannel = (CharacterChannel) channel.getNativeData(CHARACTER_CHANNEL_NAME);
        try {
            BufferedReader bufferedReader = (BufferedReader)
                    channel.getNativeData(BUFFERED_READER_ENTRY);
            bufferedReader.close();
            charChannel.close();
            channel.addNativeData(IS_CLOSED, true);
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
        return null;
    }

    public static Object closeBufferedReader(BObject channel) {

        try {
            BufferedReader bufferedReader = (BufferedReader)
                    channel.getNativeData(BUFFERED_READER_ENTRY);
            bufferedReader.close();
        } catch (ClosedChannelException e) {
            return IOUtils.createError("Character channel is already closed.");
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
        return null;
    }

    public static Object write(BObject channel, BString content, long startOffset) {

        if (isChannelClosed(channel)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        CharacterChannel characterChannel = (CharacterChannel) channel.getNativeData(CHARACTER_CHANNEL_NAME);
        try {
            return characterChannel.write(content.getValue(), (int) startOffset);
        } catch (ClosedChannelException e) {
            return IOUtils.createError(IOConstants.ErrorCode.GenericError,
                    "WritableCharacterChannel is already closed");
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
    }

    public static Object writeJson(BObject characterChannelObj, Object content) {

        if (isChannelClosed(characterChannelObj)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        try {
            CharacterChannel characterChannel = (CharacterChannel) characterChannelObj
                    .getNativeData(CHARACTER_CHANNEL_NAME);
            IOUtils.writeFull(characterChannel, StringUtils.getJsonString(content));
        } catch (BallerinaIOException e) {
            return IOUtils.createError(e);
        }
        return null;
    }

    public static Object writeXml(BObject characterChannelObj, BXml content, BString doctype) {

        if (isChannelClosed(characterChannelObj)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        try {
            CharacterChannel characterChannel = (CharacterChannel) characterChannelObj
                    .getNativeData(CHARACTER_CHANNEL_NAME);
            String writeContent = "";
            if (doctype.getValue().isBlank()) {
                writeContent = content.toString();
            } else {
                writeContent = doctype.getValue() + NEW_LINE + content.toString();
            }
            IOUtils.writeFull(characterChannel, writeContent);
        } catch (BallerinaIOException e) {
            return IOUtils.createError(e);
        }
        return null;
    }

    public static Object writeProperties(BObject characterChannelObj,
                                         BMap<BString, BString> propertyMap, BString comment) {

        if (isChannelClosed(characterChannelObj)) {
            return IOUtils.createError("Character channel is already closed.");
        }
        try {
            CharacterChannel characterChannel = (CharacterChannel) characterChannelObj
                    .getNativeData(CHARACTER_CHANNEL_NAME);
            PropertyUtils.writePropertyContent(characterChannel, propertyMap, comment);
        } catch (IOException e) {
            return IOUtils.createError(e);
        }
        return null;
    }

    private static boolean isChannelClosed(BObject channel) {
        if (channel.getNativeData(IS_CLOSED) != null) {
            return (boolean) channel.getNativeData(IS_CLOSED);
        }
        return false;
    }
}
