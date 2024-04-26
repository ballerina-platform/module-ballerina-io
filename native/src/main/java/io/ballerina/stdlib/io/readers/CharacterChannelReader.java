/*
 * Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package io.ballerina.stdlib.io.readers;

import io.ballerina.stdlib.io.channels.base.CharacterChannel;
import io.ballerina.stdlib.io.utils.BallerinaIOException;

import java.io.IOException;
import java.io.Reader;

/**
 * This sub class of {@link Reader} use to convert {@link CharacterChannel} to Reader instance.
 */
public class CharacterChannelReader extends Reader {

    private CharacterChannel channel;

    public CharacterChannelReader(CharacterChannel channel) {
        this.channel = channel;
    }

    @Override
    public int read(char[] cbuf, int off, int len) throws IOException {
        if (!channel.hasReachedEnd()) {
            String content;
            try {
                content = channel.read(len);
                if (!content.isEmpty()) {
                    final char[] chars = content.toCharArray();
                    System.arraycopy(chars, 0, cbuf, off, chars.length);
                    return chars.length;
                }
            } catch (BallerinaIOException e) {
                throw new IOException(e);
            }
        }
        return -1;
    }

    @Override
    public void close() throws IOException {
        channel.close();
    }
}
