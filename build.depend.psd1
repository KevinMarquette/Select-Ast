@{ 
    PSDependOptions  = @{ 
        Target    = '$DependencyPath/_build-cache/'
        AddToPath = $true
    }
    InvokeBuild      = '5.1.1'
    PSDeploy         = '0.2.3'
    BuildHelpers     = '1.0.0'
    PSScriptAnalyzer = '1.16.1'
    Pester           = @{
        Version = '4.3.1'
    }
}