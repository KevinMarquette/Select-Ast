
function Select-AST
{
    <#
    .SYNOPSIS
    Selects object in the AST
    
    .DESCRIPTION
    Selects language objects inside a Abstract Syntax Tree of a script block
    
    .PARAMETER Ast
    A raw Abstract Syntax Tree object to search
    
    .PARAMETER AstScriptBlock
    A scriptblock to search
    
    .PARAMETER AstScriptText
    Raw powershell txt to search

    .PARAMETER Path
    The path to a ps1 file to search
    
    .PARAMETER Type
    The type of System.Management.Automation.Language to select
    
    .PARAMETER FilterScript
    A scriptblock that will be used to filter the results.
    
    .EXAMPLE
    $script = {
        $var = 1
        function test-function {
            param($string = 'generic message')
            Write-Output -InputObject $string
        }

        function other-function {
            test-function -string 'new message'
        }
    }
    
    $script | Select-AST -Type FunctionDefinitionAst {
        $_.Name -like 'other-*'
    }

    .NOTES
    General notes
    #>
    [cmdletbinding(DefaultParameterSetName = 'AST')]
    param(
        [parameter(
            ValueFromPipeline,
            Mandatory,
            ParameterSetName = 'AST'
        )]
        [System.Management.Automation.Language.Ast[]]
        $Ast,

        [parameter(
            ValueFromPipeline,
            ParameterSetName = 'ScriptBlock'
        )]
        [ScriptBlock]
        $AstScriptBlock,
        
        [parameter(
            ValueFromPipeline,
            ParameterSetName = 'ScriptText'
        )]
        [String]
        $AstScriptText,
        
        [parameter(
            ParameterSetName = 'Path'
        )]
        [String]
        $Path,

        [ValidateSet('ErrorStatementAst', 'ErrorExpressionAst', 'ScriptBlockAst', 'ParamBlockAst', 'NamedBlockAst', 'NamedAttributeArgumentAst', 'AttributeBaseAst', 'AttributeAst', 'TypeConstraintAst', 'ParameterAst', 'StatementBlockAst', 'StatementAst', 'TypeDefinitionAst', 'UsingStatementAst', 'MemberAst', 'PropertyMemberAst', 'FunctionMemberAst', 'FunctionDefinitionAst', 'IfStatementAst', 'DataStatementAst', 'LabeledStatementAst', 'LoopStatementAst', 'ForEachStatementAst', 'ForStatementAst', 'DoWhileStatementAst', 'DoUntilStatementAst', 'WhileStatementAst', 'SwitchStatementAst', 'CatchClauseAst', 'TryStatementAst', 'TrapStatementAst', 'BreakStatementAst', 'ContinueStatementAst', 'ReturnStatementAst', 'ExitStatementAst', 'ThrowStatementAst', 'PipelineBaseAst', 'PipelineAst', 'CommandElementAst', 'CommandParameterAst', 'CommandBaseAst', 'CommandAst', 'CommandExpressionAst', 'RedirectionAst', 'MergingRedirectionAst', 'FileRedirectionAst', 'AssignmentStatementAst', 'ConfigurationDefinitionAst', 'DynamicKeywordStatementAst', 'ExpressionAst', 'BinaryExpressionAst', 'UnaryExpressionAst', 'BlockStatementAst', 'AttributedExpressionAst', 'ConvertExpressionAst', 'MemberExpressionAst', 'InvokeMemberExpressionAst', 'BaseCtorInvokeMemberExpressionAst', 'TypeExpressionAst', 'VariableExpressionAst', 'ConstantExpressionAst', 'StringConstantExpressionAst', 'ExpandableStringExpressionAst', 'ScriptBlockExpressionAst', 'ArrayLiteralAst', 'HashtableAst', 'ArrayExpressionAst', 'ParenExpressionAst', 'SubExpressionAst', 'UsingExpressionAst', 'IndexExpressionAst', 'DefaultCustomAstVisitor2', 'AstVisitor2', 'NumberToken', 'ParameterToken', 'VariableToken', 'StringToken', 'StringLiteralToken', 'StringExpandableToken', 'LabelToken', 'RedirectionToken', 'InputRedirectionToken', 'MergingRedirectionToken', 'FileRedirectionToken', 'DynamicKeywordParameter')]
        [string]
        $Type = 'AST',

        [Parameter(position = 0)]
        [scriptblock]
        $FilterScript
    )

    process
    {
        if (![string]::IsNullOrWhiteSpace($Path))
        {
            $AstScriptText = Get-Content -Path $Path -Raw -ErrorAction Stop
        }
        
        if (![string]::IsNullOrWhiteSpace($AstScriptText))
        {
            $AstScriptBlock = [scriptblock]::Create($AstScriptText)
        }

        if ($null -ne $AstScriptBlock)
        {
            $Ast = $AstScriptBlock.Ast
        }

        if ($Type)
        {
            $typeMatch = 'System.Management.Automation.Language.{0}' -f $Type
            $Ast = $Ast.FindAll( {$args[0] -is $typeMatch}, $TRUE)
        }

        if ($FilterScript)
        {
            $Ast = $Ast | Where-Object -FilterScript $FilterScript
        }

        $Ast
    }
}
