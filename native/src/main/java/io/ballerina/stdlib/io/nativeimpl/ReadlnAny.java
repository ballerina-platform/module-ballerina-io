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
package io.ballerina.stdlib.io.nativeimpl;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.creators.ErrorCreator;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BString;

import java.io.PrintStream;
import java.nio.charset.Charset;
import java.util.Scanner;
import java.util.concurrent.CompletableFuture;

/**
 * Extern function ballerina/io:readln.
 *
 * @since 0.97
 */
public class ReadlnAny {

    private static final Scanner sc = new Scanner(System.in, Charset.defaultCharset().displayName());
    private static final PrintStream printStream = System.out;

    private ReadlnAny() {}

    public static BString readln(Environment env, Object result) {
        if (result != null) {
            printStream.print(result);
        }
        env.markAsync();
        CompletableFuture<BString> future = new CompletableFuture<>();
        Thread.startVirtualThread(() -> future.complete(StringUtils.fromString(sc.nextLine())));
        try {
            return future.get();
        } catch (Throwable e) {
            throw ErrorCreator.createError(e);
        }
    }
}
