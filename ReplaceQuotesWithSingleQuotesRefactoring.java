/*******************************************************************************
 * Copyright (c) 2021 University of Illinois at Urbana-Champaign and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    UIUC - Initial API and implementation
 *******************************************************************************/
package org.eclipse.photran.internal.core.refactoring;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.OperationCanceledException;
import org.eclipse.ltk.core.refactoring.RefactoringStatus;
import org.eclipse.photran.core.IFortranAST;
import org.eclipse.photran.internal.core.lexer.Terminal;
import org.eclipse.photran.internal.core.lexer.Token;
import org.eclipse.photran.internal.core.parser.GenericASTVisitor;
import org.eclipse.photran.internal.core.refactoring.infrastructure.FortranResourceRefactoring;

/**
 * 
 * @author developer
 */
public class ReplaceQuotesWithSingleQuotesRefactoring extends FortranResourceRefactoring
{
    @Override
    public String getName()
    {
        return Messages.ReplaceQuotesWithSingleQuotesRefactoring_Name;
    }

    /** borrowed from RepObsOpersRefactoring.java */
    @Override
    protected void doCheckInitialConditions(RefactoringStatus status, IProgressMonitor pm) throws PreconditionFailure
    {
        ensureProjectHasRefactoringEnabled(status);
        removeFixedFormFilesFrom(this.selectedFiles, status);
        removeCpreprocessedFilesFrom(this.selectedFiles, status);
    }

    /** borrowed from RepObsOpersRefactoring.java */
    @Override
    protected void doCheckFinalConditions(RefactoringStatus status, IProgressMonitor pm) throws PreconditionFailure
    {
        try
        {
            for (IFile file : selectedFiles)
            {
                IFortranAST ast = vpg.acquirePermanentAST(file);
                if (ast == null)
                    status.addError(Messages.bind(Messages.ReplaceQuotesWithSingleQuotesRefactoring_SelectedFileCannotBeParsed, file.getName()));
                makeChangesTo(file, ast, status, pm);
                vpg.releaseAST(file);
            }
        }
        finally
        {
            vpg.releaseAllASTs();
        }
    }

    /** modeled after RepObsOpersRefactoring.java */
    private void makeChangesTo(IFile file, IFortranAST ast, RefactoringStatus status, IProgressMonitor pm) throws Error
    {
        try
        {
            if (ast == null) return;

            QuoteChangingVisitor replacer = new QuoteChangingVisitor();
            ast.accept(replacer);
            addChangeFromModifiedAST(file, pm);
        }
        catch (Exception e)
        {
            throw new Error(e);
        }
    }

    /** borrowed from RepObsOpersRefactoring.java */
    @Override
    protected void doCreateChange(IProgressMonitor pm) throws CoreException, OperationCanceledException
    {
    }

    private static final class QuoteChangingVisitor extends GenericASTVisitor
    {
        @Override
        public void visitToken(Token node)
        {
            changeQuotesOf(node);
        }

        @SuppressWarnings("nls")
        private void changeQuotesOf(Token node)
        {
            node.findFirstToken().setText(node.getText().replace("\"", "'"));
        }
    }
}

