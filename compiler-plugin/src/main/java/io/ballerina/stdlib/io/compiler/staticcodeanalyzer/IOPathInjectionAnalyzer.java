package io.ballerina.stdlib.io.compiler.staticcodeanalyzer;

import io.ballerina.projects.plugins.AnalysisTask;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.scan.Reporter;

public class IOPathInjectionAnalyzer implements AnalysisTask<SyntaxNodeAnalysisContext>  {

    private final Reporter reporter;

    public IOPathInjectionAnalyzer(Reporter reporter) {
        this.reporter = reporter;
    }

    @Override
    public void perform(SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {

    }
}
