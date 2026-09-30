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
import io.ballerina.compiler.syntax.tree.CaptureBindingPatternNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.FunctionBodyBlockNode;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.RequiredParameterNode;
import io.ballerina.compiler.syntax.tree.SimpleNameReferenceNode;
import io.ballerina.compiler.syntax.tree.StatementNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.VariableDeclarationNode;
import io.ballerina.stdlib.io.compiler.staticcodeanalyzer.IoFunctionContext;

import java.util.Optional;

import static io.ballerina.stdlib.io.compiler.Constants.IO_FUNCTIONS;
import static io.ballerina.stdlib.io.compiler.staticcodeanalyzer.IORule.AVOID_PATH_TRAVERSAL;

/**
 * Rule to detect a file path built from untrusted input.
 * <p>
 * A path assembled from a value the caller controls can be steered outside the directory the code intends, since
 * a segment such as {@code ../} is resolved by the filesystem rather than rejected.
 */
public class AvoidPathTraversalRule implements IoFunctionRule {

    private static final String PATH_PARAM = "path";
    private static final int PATH_POSITION = 0;

    @Override
    public void analyze(IoFunctionContext context) {
        if (!isSafePath(context)) {
            context.reportIssue(context.getFunctionLocation(), getRuleId());
        }
    }

    @Override
    public int getRuleId() {
        return AVOID_PATH_TRAVERSAL.getId();
    }

    @Override
    public boolean isApplicable(IoFunctionContext context) {
        return IO_FUNCTIONS.contains(context.getFunctionName());
    }

    private boolean isSafePath(IoFunctionContext context) {
        Optional<ExpressionNode> firstArgument = context.getArgument(PATH_POSITION, PATH_PARAM);
        if (firstArgument.isEmpty()) {
            return true;
        }
        ExpressionNode argument = firstArgument.get();

        if (argument instanceof BinaryExpressionNode binaryExpression &&
                binaryExpression.operator().kind() == SyntaxKind.PLUS_TOKEN) {
            return false;
        }

        if (argument instanceof SimpleNameReferenceNode variableRef) {
            return isVariableSafe(variableRef);
        }
        return true;
    }

    private boolean isVariableSafe(SimpleNameReferenceNode variableRef) {
        String variableName = variableRef.name().text();
        Node currentNode = variableRef.parent();

        while (currentNode != null) {
            if (currentNode instanceof FunctionBodyBlockNode functionBody) {
                return isVariableDeclaredSafely(functionBody, variableName, variableRef);
            }
            currentNode = currentNode.parent();
        }
        return true;
    }

    private boolean isVariableDeclaredSafely(FunctionBodyBlockNode functionBody, String variableName,
                                             SimpleNameReferenceNode variableRef) {
        for (StatementNode statement : functionBody.statements()) {
            if (statement instanceof VariableDeclarationNode varDecl && isMatchingVariable(varDecl, variableName)) {
                ExpressionNode initializer = varDecl.initializer().orElse(null);
                if (initializer == null || isConcatenationAssignment(initializer)) {
                    return isFunctionParameter(variableRef);
                }
                if (initializer instanceof SimpleNameReferenceNode refNode) {
                    return isFunctionParameter(refNode);
                }
                return true;
            }
        }
        return true;
    }

    private boolean isMatchingVariable(VariableDeclarationNode varDecl, String variableName) {
        return varDecl.typedBindingPattern().bindingPattern() instanceof CaptureBindingPatternNode bindingPattern
                && bindingPattern.variableName().text().equals(variableName);
    }

    private boolean isConcatenationAssignment(ExpressionNode initializer) {
        return initializer instanceof BinaryExpressionNode binaryExpr
                && binaryExpr.operator().kind() == SyntaxKind.PLUS_TOKEN;
    }

    private boolean isFunctionParameter(SimpleNameReferenceNode variableRef) {
        String paramName = variableRef.name().text();
        Node currentNode = variableRef.parent();

        while (currentNode != null) {
            if (currentNode instanceof FunctionDefinitionNode functionDef) {
                return functionDef.functionSignature().parameters().stream()
                        .filter(RequiredParameterNode.class::isInstance)
                        .map(RequiredParameterNode.class::cast)
                        .noneMatch(reqParam -> reqParam.paramName()
                                .map(name -> name.toString().equals(paramName) ||
                                        isIndirectFunctionParameter(variableRef, reqParam))
                                .orElse(false));
            }
            currentNode = currentNode.parent();
        }
        return true;
    }

    private boolean isIndirectFunctionParameter(SimpleNameReferenceNode variableRef, RequiredParameterNode reqParam) {
        Node currentNode = variableRef.parent();

        while (currentNode != null) {
            if (currentNode instanceof FunctionBodyBlockNode functionBody) {
                return functionBody.statements().stream()
                        .filter(VariableDeclarationNode.class::isInstance)
                        .map(VariableDeclarationNode.class::cast)
                        .anyMatch(varDecl ->
                                isAssignedToFunctionParameter(varDecl, variableRef, reqParam));
            }
            currentNode = currentNode.parent();
        }
        return false;
    }

    private boolean isAssignedToFunctionParameter(VariableDeclarationNode varDecl, SimpleNameReferenceNode variableRef,
                                                  RequiredParameterNode reqParam) {
        if (varDecl.typedBindingPattern().bindingPattern() instanceof CaptureBindingPatternNode bindingPattern &&
                bindingPattern.variableName().text().equals(variableRef.name().text())) {

            return varDecl.initializer().map(initializer ->
                            isInitializerAssignedToFunctionParameter(initializer, reqParam))
                    .orElse(false);
        }
        return false;
    }

    private boolean isInitializerAssignedToFunctionParameter(ExpressionNode initializer,
                                                             RequiredParameterNode reqParam) {
        if (initializer instanceof SimpleNameReferenceNode initializerRef) {
            return initializerRef.name().text().equals(reqParam.paramName().get().text());
        } else if (initializer instanceof BinaryExpressionNode binaryExpr &&
                binaryExpr.operator().kind() == SyntaxKind.PLUS_TOKEN) {
            return isIndirectFunctionParameterFromBinary(binaryExpr, reqParam);
        }
        return false;
    }

    private boolean isIndirectFunctionParameterFromBinary(BinaryExpressionNode binaryExpr,
                                                          RequiredParameterNode reqParam) {
        if (binaryExpr.lhsExpr() instanceof SimpleNameReferenceNode leftRef &&
                leftRef.name().text().equals(reqParam.paramName().get().text())) {
            return true;
        }
        return binaryExpr.rhsExpr() instanceof SimpleNameReferenceNode rightRef &&
                rightRef.name().text().equals(reqParam.paramName().get().text());
    }
}
