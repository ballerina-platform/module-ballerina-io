/*
 * Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.io.utils;

import io.ballerina.stdlib.io.channels.base.Channel;

import java.nio.channels.WritableByteChannel;

/**
 * Wrap base64 byte channel stream as a ballerina specific byte channel.
 *
 * @since 0.970.0
 */
public class Base64Wrapper extends Channel {
    public Base64Wrapper(Base64ByteChannel channel) {
        super(channel);
    }

    @Override
    public void transfer(int position, int count, WritableByteChannel dstChannel) {
        //For the time being not applicable
        throw new UnsupportedOperationException();
    }

    @Override
    public Channel getChannel() {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean remaining() {
        return false;
    }
}
