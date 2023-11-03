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
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.io.testutils;

import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.io.utils.Utils;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.nio.charset.Charset;

/**
 * PrintUtils to read the console and return the output.
 */
public class PrintTestUtils {

    private static final Object outLock = new Object();
    private static final Object errLock = new Object();
    static ByteArrayOutputStream outContent;
    static ByteArrayOutputStream errContent;

    private PrintTestUtils() {
    }

    // Initialize output stream
    public static void initOutputStream() {

        synchronized (outLock) {
            if (outContent == null) {
                outContent = new ByteArrayOutputStream();
                System.setOut(new PrintStream(outContent, false, Charset.defaultCharset()));
            }
        }
    }

    // Initialize error stream
    public static void initErrorStream() {

        synchronized (errLock) {
            if (errContent == null) {
                errContent = new ByteArrayOutputStream();
                System.setErr(new PrintStream(errContent, false, Charset.defaultCharset()));
            }
        }
    }

    // Read output stream and return it as a ballerina string
    public static BString readOutputStream() {

        return StringUtils.fromString(outContent.toString(Charset.defaultCharset()).replace("\r", ""));
    }

    // Read error stream and return it as a ballerina string
    public static BString readErrorStream() {

        return StringUtils.fromString(errContent.toString(Charset.defaultCharset()).replace("\r", ""));
    }

    // Reset output stream
    public static void resetOutputStream() {

        if (outContent != null) {
            outContent.reset();
        }
    }

    // Reset error stream
    public static void resetErrorStream() {

        if (errContent != null) {
            errContent.reset();
        }
    }

    public static Object base64Encode(Object input, BString charset, boolean mimeSpecific) {
        return Utils.encode(input, charset.getValue(), mimeSpecific);
    }
}
