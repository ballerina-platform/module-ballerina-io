/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.org)
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
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

package io.ballerina.stdlib.io.compiler.staticcodeanalyzer;

import io.ballerina.stdlib.io.compiler.staticcodeanalyzer.iorules.AvoidPathTraversalRule;
import io.ballerina.stdlib.io.compiler.staticcodeanalyzer.iorules.AvoidPrintingConfigurableVariablesRule;
import io.ballerina.stdlib.io.compiler.staticcodeanalyzer.iorules.IoFunctionRule;

import java.util.ArrayList;
import java.util.List;

/**
 * Engine to execute IO function rules.
 */
public class IoFunctionRulesEngine {

    private final List<IoFunctionRule> rules;

    public IoFunctionRulesEngine() {
        this.rules = new ArrayList<>();
        initializeDefaultRules();
    }

    public void executeRules(IoFunctionContext context) {
        for (IoFunctionRule rule : rules) {
            if (rule.isApplicable(context)) {
                rule.analyze(context);
            }
        }
    }

    public void addRule(IoFunctionRule rule) {
        if (rule != null && !rules.contains(rule)) {
            rules.add(rule);
        }
    }

    private void initializeDefaultRules() {
        addRule(new AvoidPathTraversalRule());
        addRule(new AvoidPrintingConfigurableVariablesRule());
        // Add more default rules here as needed
    }
}
