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

package io.ballerina.stdlib.io.testutils;

import io.ballerina.runtime.api.values.BString;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * This class holds test utility APIs related to file API test cases.
 *
 */
public class FileTestUtils {
    
    private FileTestUtils() {
    }

    public static void createDirectory(BString path) {
        Path directoryPath = Paths.get(path.getValue());
        if (!Files.exists(directoryPath)) {
            try {
                Files.createDirectory(directoryPath);
            } catch (IOException e) {
                //Removed logs from here
            }
        }
    }
}
