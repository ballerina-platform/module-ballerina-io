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

import io.ballerina.compiler.syntax.tree.BinaryExpressionNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.InterpolationNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
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
        for (int position = 0; position < context.getPositionalArgumentCount(); position++) {
            context.getPositionalArgument(position)
                    .ifPresent(argument -> reportConfigurableValues(context, argument));
        }
    }

    /**
     * Report a configurable reached directly, through a string template interpolation, or through concatenation.
     */
    private void reportConfigurableValues(IoFunctionContext context, ExpressionNode argument) {
        if (argument instanceof TemplateExpressionNode template) {
            for (Node content : template.content()) {
                if (content instanceof InterpolationNode interpolation) {
                    reportConfigurableValues(context, interpolation.expression());
                }
            }
            return;
        }
        if (argument instanceof BinaryExpressionNode binaryExpression
                && binaryExpression.operator().kind() == SyntaxKind.PLUS_TOKEN) {
            // String concatenation builds the printed value from both operands, so each is checked in turn;
            // this also unwinds a chain such as "a" + b + c, since its left operand is itself a BinaryExpressionNode.
            reportConfigurableOperand(context, binaryExpression.lhsExpr());
            reportConfigurableOperand(context, binaryExpression.rhsExpr());
            return;
        }
        // Any other expression is offered to the symbol lookup as it stands, so a reference qualified with a
        // module prefix is read the same way as a plain one.
        reportIfConfigurable(context, argument);
    }

    private void reportConfigurableOperand(IoFunctionContext context, Node operand) {
        if (operand instanceof ExpressionNode expression) {
            reportConfigurableValues(context, expression);
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
