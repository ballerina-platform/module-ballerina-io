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

import io.ballerina.compiler.api.SemanticModel;
import io.ballerina.compiler.syntax.tree.FunctionCallExpressionNode;
import io.ballerina.compiler.syntax.tree.ImportDeclarationNode;
import io.ballerina.compiler.syntax.tree.ImportOrgNameNode;
import io.ballerina.compiler.syntax.tree.ModulePartNode;
import io.ballerina.compiler.syntax.tree.QualifiedNameReferenceNode;
import io.ballerina.projects.Document;
import io.ballerina.projects.plugins.AnalysisTask;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.scan.Reporter;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static io.ballerina.stdlib.io.compiler.Constants.BALLERINA_ORG;
import static io.ballerina.stdlib.io.compiler.Constants.IO;

/**
 * Analyzes calls into the {@code ballerina/io} module.
 */
public class IoFunctionCallAnalyzer implements AnalysisTask<SyntaxNodeAnalysisContext> {

    private final Reporter reporter;
    private final IoFunctionRulesEngine rulesEngine;
    private final List<SemanticModel> semanticModels = new ArrayList<>();

    public IoFunctionCallAnalyzer(Reporter reporter) {
        this.reporter = reporter;
        this.rulesEngine = new IoFunctionRulesEngine();
    }

    @Override
    public void perform(SyntaxNodeAnalysisContext context) {
        if (!(context.node() instanceof FunctionCallExpressionNode functionCall)) {
            return;
        }
        // A configurable may be declared in any module of the package, so every module's model is needed
        if (semanticModels.isEmpty()) {
            context.currentPackage().modules()
                    .forEach(module -> semanticModels.add(module.getCompilation().getSemanticModel()));
        }

        Document document = getDocument(context);
        Optional<String> functionName = getIoFunctionName(functionCall, collectIoPrefixes(document));
        if (functionName.isEmpty()) {
            return;
        }
        rulesEngine.executeRules(new IoFunctionContext(reporter, document, semanticModels, functionName.get(),
                functionCall));
    }

    private Optional<String> getIoFunctionName(FunctionCallExpressionNode functionCall, Set<String> ioPrefixes) {
        if (!(functionCall.functionName() instanceof QualifiedNameReferenceNode qualifiedName)) {
            return Optional.empty();
        }
        if (!ioPrefixes.contains(qualifiedName.modulePrefix().text())) {
            return Optional.empty();
        }
        return Optional.of(qualifiedName.identifier().text());
    }

    /**
     * Collect every prefix the {@code ballerina/io} module is imported under in the document being analyzed.
     */
    private Set<String> collectIoPrefixes(Document document) {
        Set<String> prefixes = new HashSet<>();
        if (!(document.syntaxTree().rootNode() instanceof ModulePartNode modulePart)) {
            return prefixes;
        }
        for (ImportDeclarationNode importDeclaration : modulePart.imports()) {
            Optional<ImportOrgNameNode> orgName = importDeclaration.orgName();
            boolean isIoImport = orgName.isPresent() && BALLERINA_ORG.equals(orgName.get().orgName().text())
                    && importDeclaration.moduleName().stream().anyMatch(name -> IO.equals(name.text()));
            if (isIoImport) {
                prefixes.add(importDeclaration.prefix().map(prefix -> prefix.prefix().text()).orElse(IO));
            }
        }
        return prefixes;
    }

    private static Document getDocument(SyntaxNodeAnalysisContext context) {
        return context.currentPackage().module(context.moduleId()).document(context.documentId());
    }
}
