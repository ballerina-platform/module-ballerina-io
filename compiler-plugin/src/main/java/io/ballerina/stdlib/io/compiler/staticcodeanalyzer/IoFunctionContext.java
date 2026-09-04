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
import io.ballerina.compiler.api.symbols.Symbol;
import io.ballerina.compiler.api.symbols.VariableSymbol;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.FunctionArgumentNode;
import io.ballerina.compiler.syntax.tree.FunctionCallExpressionNode;
import io.ballerina.compiler.syntax.tree.NamedArgumentNode;
import io.ballerina.compiler.syntax.tree.PositionalArgumentNode;
import io.ballerina.projects.Document;
import io.ballerina.scan.Reporter;
import io.ballerina.tools.diagnostics.Location;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Represents the context of an IO module function call being analyzed.
 */
public class IoFunctionContext {

    private static final String CONFIGURABLE_QUALIFIER = "CONFIGURABLE";

    private final Reporter reporter;
    private final Document document;
    private final List<SemanticModel> semanticModels;
    private final String functionName;
    private final Location functionLocation;
    private final List<ExpressionNode> positionalArguments;
    private final Map<String, ExpressionNode> namedArguments;

    /**
     * Creates a context for the given IO module function call.
     *
     * @param reporter       the static code analysis reporter
     * @param document       the document containing the call
     * @param semanticModels the semantic models of every module in the package
     * @param functionName   the simple name of the IO function being called
     * @param functionCall   the call being analyzed
     */
    public IoFunctionContext(Reporter reporter, Document document, List<SemanticModel> semanticModels,
                             String functionName, FunctionCallExpressionNode functionCall) {
        this.reporter = reporter;
        this.document = document;
        this.semanticModels = List.copyOf(semanticModels);
        this.functionName = functionName;
        this.functionLocation = functionCall.location();
        this.positionalArguments = collectPositionalArguments(functionCall);
        this.namedArguments = collectNamedArguments(functionCall);
    }

    private static List<ExpressionNode> collectPositionalArguments(FunctionCallExpressionNode functionCall) {
        List<ExpressionNode> collected = new ArrayList<>();
        for (FunctionArgumentNode argument : functionCall.arguments()) {
            if (argument instanceof PositionalArgumentNode positionalArgument) {
                collected.add(positionalArgument.expression());
            }
        }
        return List.copyOf(collected);
    }

    private static Map<String, ExpressionNode> collectNamedArguments(FunctionCallExpressionNode functionCall) {
        Map<String, ExpressionNode> collected = new LinkedHashMap<>();
        for (FunctionArgumentNode argument : functionCall.arguments()) {
            if (argument instanceof NamedArgumentNode namedArgument) {
                collected.put(namedArgument.argumentName().name().text(), namedArgument.expression());
            }
        }
        return Map.copyOf(collected);
    }

    /**
     * The simple name of the IO function that was called, such as {@code println}.
     *
     * @return the called function's name
     */
    public String getFunctionName() {
        return this.functionName;
    }

    /**
     * The location of the whole call.
     *
     * @return the location of the function call
     */
    public Location getFunctionLocation() {
        return this.functionLocation;
    }

    /**
     * Get an argument by position or by name.
     * <p>
     * Named arguments may appear in any order, so a rule that read them positionally would inspect whichever
     * argument happened to be written first. Resolving by parameter name keeps the rule looking at the parameter
     * it means.
     *
     * @param position      the zero-based position of the parameter
     * @param parameterName the parameter's name
     * @return the argument expression if supplied, empty otherwise
     */
    public Optional<ExpressionNode> getArgument(int position, String parameterName) {
        ExpressionNode named = this.namedArguments.get(parameterName);
        if (named != null) {
            return Optional.of(named);
        }
        return getPositionalArgument(position);
    }

    /**
     * Get a positional argument by its index.
     *
     * @param position the zero-based argument position
     * @return the argument expression if supplied, empty otherwise
     */
    public Optional<ExpressionNode> getPositionalArgument(int position) {
        return position >= 0 && position < this.positionalArguments.size()
                ? Optional.of(this.positionalArguments.get(position)) : Optional.empty();
    }

    /**
     * The number of positional arguments supplied at the call site.
     *
     * @return the positional argument count
     */
    public int getPositionalArgumentCount() {
        return this.positionalArguments.size();
    }

    /**
     * Check whether an expression names a {@code configurable} variable.
     * <p>
     * A configurable may be declared in any module of the package, so every module's semantic model is consulted.
     *
     * @param expression the expression to check
     * @return true if the expression names a configurable variable
     */
    public boolean isConfigurable(ExpressionNode expression) {
        return this.semanticModels.stream()
                .map(semanticModel -> semanticModel.symbol(expression).orElse(null))
                .filter(VariableSymbol.class::isInstance)
                .map(VariableSymbol.class::cast)
                .anyMatch(variableSymbol -> variableSymbol.qualifiers().stream()
                        .anyMatch(qualifier -> CONFIGURABLE_QUALIFIER.equals(qualifier.toString())));
    }

    /**
     * Report an issue against this call.
     *
     * @param location the location to report at
     * @param ruleId   the rule reporting the issue
     */
    public void reportIssue(Location location, int ruleId) {
        this.reporter.reportIssue(this.document, location, ruleId);
    }

    /**
     * Resolve a symbol for the given expression from any module in the package.
     *
     * @param expression the expression to resolve
     * @return the symbol if it can be resolved, empty otherwise
     */
    public Optional<Symbol> resolveSymbol(ExpressionNode expression) {
        return this.semanticModels.stream()
                .map(semanticModel -> semanticModel.symbol(expression))
                .filter(Optional::isPresent)
                .map(Optional::get)
                .findFirst();
    }
}
