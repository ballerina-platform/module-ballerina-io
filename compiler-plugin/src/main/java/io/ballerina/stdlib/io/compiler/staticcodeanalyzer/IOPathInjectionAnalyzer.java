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

import io.ballerina.compiler.syntax.tree.BinaryExpressionNode;
import io.ballerina.compiler.syntax.tree.CaptureBindingPatternNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.FunctionArgumentNode;
import io.ballerina.compiler.syntax.tree.FunctionBodyBlockNode;
import io.ballerina.compiler.syntax.tree.FunctionCallExpressionNode;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ParameterNode;
import io.ballerina.compiler.syntax.tree.PositionalArgumentNode;
import io.ballerina.compiler.syntax.tree.QualifiedNameReferenceNode;
import io.ballerina.compiler.syntax.tree.RequiredParameterNode;
import io.ballerina.compiler.syntax.tree.SimpleNameReferenceNode;
import io.ballerina.compiler.syntax.tree.StatementNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.VariableDeclarationNode;
import io.ballerina.projects.Document;
import io.ballerina.projects.plugins.AnalysisTask;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.scan.Reporter;
import io.ballerina.tools.diagnostics.Location;

import java.util.Optional;

import static io.ballerina.stdlib.io.compiler.Constants.IO_FUNCTIONS;
import static io.ballerina.stdlib.io.compiler.staticcodeanalyzer.IORule.AVOID_PATH_TRAVERSAL;

/**
 * Analyzes function calls for potential path traversal vulnerabilities.
 */
public class IOPathInjectionAnalyzer implements AnalysisTask<SyntaxNodeAnalysisContext> {
    private final Reporter reporter;

    public IOPathInjectionAnalyzer(Reporter reporter) {
        this.reporter = reporter;
    }

    @Override
    public void perform(SyntaxNodeAnalysisContext context) {
        if (!(context.node() instanceof FunctionCallExpressionNode functionCall)) {
            return;
        }

        Optional<ExpressionNode> functionNameOpt = Optional.ofNullable(functionCall.functionName());
        if (functionNameOpt.isEmpty()) {
            return;
        }

        ExpressionNode functionName = functionNameOpt.get();

        if (functionName instanceof QualifiedNameReferenceNode qualifiedName) {
            String moduleName = qualifiedName.modulePrefix().text();
            String functionNameStr = qualifiedName.identifier().text();

            if ("io".equals(moduleName) && IO_FUNCTIONS.contains(functionNameStr)) {
                if (!isSafePath(functionCall)) {
                    Location location = functionCall.location();
                    this.reporter.reportIssue(getDocument(context), location, AVOID_PATH_TRAVERSAL.getId());
                }
            }
        }
    }

    private boolean isSafePath(FunctionCallExpressionNode functionCall) {
        NodeList<FunctionArgumentNode> arguments = functionCall.arguments();
        if (arguments.isEmpty()) {
            return true;
        }

        FunctionArgumentNode firstArg = arguments.get(0);
        ExpressionNode argument;

        if (firstArg instanceof PositionalArgumentNode) {
            argument = ((PositionalArgumentNode) firstArg).expression();
        } else {
            return true;
        }

        if (argument instanceof BinaryExpressionNode binaryExpression) {
            if (binaryExpression.operator().kind() == SyntaxKind.PLUS_TOKEN) {
                return false;
            }
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
                for (StatementNode statement : functionBody.statements()) {
                    if (statement instanceof VariableDeclarationNode varDecl) {
                        if (varDecl.typedBindingPattern().bindingPattern() instanceof
                                CaptureBindingPatternNode bindingPattern) {
                            if (bindingPattern.variableName().text().equals(variableName)) {
                                // Check if assigned using concatenation
                                if (varDecl.initializer().orElse(null) instanceof BinaryExpressionNode) {
                                    BinaryExpressionNode binaryExpr = (BinaryExpressionNode)
                                            varDecl.initializer().get();
                                    if (binaryExpr.operator().kind() == SyntaxKind.PLUS_TOKEN) {
                                        return isFunctionParameter(variableRef);
                                    }
                                }
                                // Check if assigned directly from a function parameter
                                if (varDecl.initializer().orElse(null) instanceof SimpleNameReferenceNode) {
                                    SimpleNameReferenceNode initializer = (SimpleNameReferenceNode)
                                            varDecl.initializer().get();
                                    return isFunctionParameter(initializer);
                                }
                                return true;
                            }
                        }
                    }
                }
            }
            currentNode = currentNode.parent();
        }
        return true;
    }

    private boolean isFunctionParameter(SimpleNameReferenceNode variableRef) {
        String paramName = variableRef.name().text();
        Node currentNode = variableRef.parent();
        while (currentNode != null) {
            if (currentNode instanceof FunctionDefinitionNode functionDef) {
                // Iterate over function parameters to check direct reference
                for (ParameterNode param : functionDef.functionSignature().parameters()) {
                    if (param instanceof RequiredParameterNode reqParam) {
                        // Check direct parameter reference
                        if (reqParam.paramName().isPresent() &&
                                reqParam.paramName().get().toString().equals(paramName)) {
                            return false;
                        }
                        // Check indirect reference chain (assignments)
                        if (isIndirectFunctionParameter(variableRef, reqParam)) {
                            return false;
                        }
                    }
                }
            }
            currentNode = currentNode.parent();
        }
        return true;
    }

    private boolean isIndirectFunctionParameter(SimpleNameReferenceNode variableRef, RequiredParameterNode reqParam) {
        Node currentNode = variableRef.parent();
        while (currentNode != null) {
            if (currentNode instanceof FunctionBodyBlockNode functionBody) {
                for (StatementNode statement : functionBody.statements()) {
                    if (statement instanceof VariableDeclarationNode varDecl) {
                        if (varDecl.typedBindingPattern().bindingPattern() instanceof
                                CaptureBindingPatternNode bindingPattern) {
                            if (bindingPattern.variableName().text().equals(variableRef.name().text())) {
                                // Check if the variable is assigned to another variable
                                if (varDecl.initializer().isPresent()) {
                                    ExpressionNode initializer = varDecl.initializer().get();
                                    // If it's a reference to the function parameter, return true
                                    if (initializer instanceof SimpleNameReferenceNode initializerRef) {
                                        if (initializerRef.name().text().equals(reqParam.paramName().get().text())) {
                                            return true;
                                        }
                                    }
                                    // If it's a binary expression, recurse
                                    if (initializer instanceof BinaryExpressionNode binaryExpr) {
                                        if (binaryExpr.operator().kind() == SyntaxKind.PLUS_TOKEN) {
                                            // Recursively check both sides of the binary expression
                                            if (isIndirectFunctionParameterFromBinary(binaryExpr, reqParam)) {
                                                return true;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            currentNode = currentNode.parent();
        }
        return false;
    }

    private boolean isIndirectFunctionParameterFromBinary(BinaryExpressionNode binaryExpr,
                                                          RequiredParameterNode reqParam) {
        // Check both the left and right sides of the binary expression
        if (binaryExpr.lhsExpr() instanceof SimpleNameReferenceNode leftRef) {
            if (leftRef.name().text().equals(reqParam.paramName().get().text())) {
                return true;
            }
        }
        if (binaryExpr.rhsExpr() instanceof SimpleNameReferenceNode rightRef) {
            if (rightRef.name().text().equals(reqParam.paramName().get().text())) {
                return true;
            }
        }
        return false;
    }

    public static Document getDocument(SyntaxNodeAnalysisContext context) {
        return context.currentPackage().module(context.moduleId()).document(context.documentId());
    }
}
