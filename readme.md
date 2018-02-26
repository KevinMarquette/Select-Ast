# Select-Ast

A PowerShell module for working with the AST

# EXAMPLE

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

## GitPitch PitchMe presentation

* [gitpitch.com/KevinMarquette/Select-Ast](https://gitpitch.com/KevinMarquette/Select-Ast)

## Getting Started

Install from the PSGallery and Import the module

    Install-Module Select-Ast
    Import-Module Select-Ast


## More Information

For more information

* [Select-Ast.readthedocs.io](http://Select-Ast.readthedocs.io)
* [github.com/KevinMarquette/Select-Ast](https://github.com/KevinMarquette/Select-Ast)
* [KevinMarquette.github.io](https://KevinMarquette.github.io)


This project was generated using [Kevin Marquette](http://kevinmarquette.github.io)'s [Full Module Plaster Template](https://github.com/KevinMarquette/PlasterTemplates/tree/master/FullModuleTemplate).
