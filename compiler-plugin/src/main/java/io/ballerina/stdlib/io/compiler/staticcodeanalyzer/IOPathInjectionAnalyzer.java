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
import io.ballerina.compiler.syntax.tree.ImportOrgNameNode;
import io.ballerina.compiler.syntax.tree.ImportPrefixNode;
import io.ballerina.compiler.syntax.tree.ModulePartNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeList;
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

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static io.ballerina.stdlib.io.compiler.Constants.BALLERINA_ORG;
import static io.ballerina.stdlib.io.compiler.Constants.IO;
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

        Document document = getDocument(context);
        List<String> importPrefix = new ArrayList<>();
        if (document.syntaxTree().rootNode() instanceof ModulePartNode modulePartNode) {
            importPrefix = modulePartNode.imports().stream()
                    .filter(importDeclarationNode -> {
                        ImportOrgNameNode importOrgNameNode = importDeclarationNode.orgName().orElse(null);
                        return importOrgNameNode != null && BALLERINA_ORG.equals(importOrgNameNode.orgName().text());
                    })
                    .filter(importDeclarationNode -> importDeclarationNode.moduleName().stream().anyMatch(
                            moduleNameNode -> IO.equals(moduleNameNode.text())))
                    .map(importDeclarationNode -> {
                        ImportPrefixNode importPrefixNode = importDeclarationNode.prefix().orElse(null);
                        return importPrefixNode != null ? importPrefixNode.prefix().text() : IO;
                    }).toList();
        }

        if (functionName instanceof QualifiedNameReferenceNode qualifiedName) {
            String moduleName = qualifiedName.modulePrefix().text();
            String functionNameStr = qualifiedName.identifier().text();

            if (importPrefix.contains(moduleName) &&
                    IO_FUNCTIONS.contains(functionNameStr) && !isSafePath(functionCall)) {
                Location location = functionCall.location();
                this.reporter.reportIssue(getDocument(context), location, AVOID_PATH_TRAVERSAL.getId());
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

    public static Document getDocument(SyntaxNodeAnalysisContext context) {
        return context.currentPackage().module(context.moduleId()).document(context.documentId());
    }
}
