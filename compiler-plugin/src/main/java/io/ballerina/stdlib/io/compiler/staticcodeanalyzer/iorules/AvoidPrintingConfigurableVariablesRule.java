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

package io.ballerina.stdlib.io.compiler.staticcodeanalyzer.iorules;

import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.InterpolationNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.SimpleNameReferenceNode;
import io.ballerina.compiler.syntax.tree.TemplateExpressionNode;
import io.ballerina.stdlib.io.compiler.staticcodeanalyzer.IoFunctionContext;

import java.util.Set;

import static io.ballerina.stdlib.io.compiler.staticcodeanalyzer.IORule.AVOID_PRINTING_CONFIGURABLE_VARIABLES;

/**
 * Rule to detect a configurable variable written to the console.
 * <p>
 * Configurable variables carry the values supplied at deployment, which is where credentials and connection secrets
 * live. Standard output is collected by the container runtime and forwarded to whatever log aggregator the platform
 * uses, so printing one puts it in a durable store that far more people can read than can read the deployment
 * configuration. This is the same defect as logging a configurable, at the other output sink.
 */
public class AvoidPrintingConfigurableVariablesRule implements IoFunctionRule {

    private static final Set<String> PRINT_FUNCTIONS = Set.of("print", "println");

    @Override
    public void analyze(IoFunctionContext context) {
        for (int position = 0; position < context.getArgumentCount(); position++) {
            context.getArgument(position).ifPresent(argument -> reportConfigurableValues(context, argument));
        }
    }

    /**
     * Report a configurable reached either directly or through a string template interpolation.
     */
    private void reportConfigurableValues(IoFunctionContext context, ExpressionNode argument) {
        if (argument instanceof SimpleNameReferenceNode) {
            reportIfConfigurable(context, argument);
            return;
        }
        if (argument instanceof TemplateExpressionNode template) {
            for (Node content : template.content()) {
                if (content instanceof InterpolationNode interpolation) {
                    reportIfConfigurable(context, interpolation.expression());
                }
            }
        }
    }

    private void reportIfConfigurable(IoFunctionContext context, ExpressionNode expression) {
        if (context.isConfigurable(expression)) {
            context.reportIssue(expression.location(), getRuleId());
        }
    }

    @Override
    public int getRuleId() {
        return AVOID_PRINTING_CONFIGURABLE_VARIABLES.getId();
    }

    @Override
    public boolean isApplicable(IoFunctionContext context) {
        return PRINT_FUNCTIONS.contains(context.getFunctionName());
    }
}
