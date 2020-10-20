/*
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package org.ballerinalang.stdlib.io.file;

import io.ballerina.runtime.api.StringUtils;
import io.ballerina.runtime.api.ValueCreator;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.values.ArrayValue;
import org.ballerinalang.stdlib.io.utils.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

/**
 * This class holds all the Java File read and write related APIs.
 *
 */
public class FileIO {

    private static final Logger log = LoggerFactory.getLogger(FileIO.class);

    public static Object readBytes(BString path) {
        Path filePath = Paths.get(path.getValue());
        try {
            return ValueCreator.createArrayValue(Files.readAllBytes(filePath));
        } catch (IOException e) {
            log.error("Error occurred while reading the byte content from " + path.getValue(), e);
            return IOUtils.createError(e.getMessage());
        }
    }

    public static Object readString(BString path) {
        Path filePath = Paths.get(path.getValue());
        try {
            return StringUtils.fromString(Files.readString(filePath));
        } catch (IOException e) {
            log.error("Error occurred while reading the byte content from " + path.getValue(), e);
            return IOUtils.createError(e.getMessage());
        }
    }

    public static Object readLines(BString path) {
        Path filePath = Paths.get(path.getValue());
        try {
            List<String> lines = Files.readAllLines(filePath);
            return ValueCreator.createArrayValue(
                    StringUtils.fromStringArray(lines.toArray(String[]::new)));
        } catch (IOException e) {
            log.error("Error occurred while reading the byte content from " + path.getValue(), e);
            return IOUtils.createError(e.getMessage());
        }
    }

    public static Object writeBytes(BString path, ArrayValue content) {
        Path filePath = Paths.get(path.getValue());
        try {
            Files.write(filePath, content.getBytes());
            return null;
        } catch (IOException e) {
            log.error("Error occurred while writing the byte content to " + path.getValue(), e);
            return IOUtils.createError(e.toString());
        }
    }

    public static Object writeString(BString path, BString content) {
        Path filePath = Paths.get(path.getValue());
        try {
            Files.writeString(filePath, content.getValue());
            return null;
        } catch (IOException e) {
            log.error("Error occurred while writing the byte content to " + path.getValue(), e);
            return IOUtils.createError(e.toString());
        }
    }

    public static Object writeLines(BString path, ArrayValue content) {
        Path filePath = Paths.get(path.getValue());
        try {
            Files.write(filePath, Arrays.asList(content.getStringArray()));
            return null;
        } catch (IOException e) {
            log.error("Error occurred while writing the byte content to " + path.getValue(), e);
            return IOUtils.createError(e.toString());
        }
    }
}
