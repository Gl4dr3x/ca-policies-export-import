@{
    RootModule        = 'ConditionalAccessPolicy.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'd65d18f1-aaaa-bbbb-cccc-ffffffffffff'
    Author            = 'Your Name'
    CompanyName       = 'Your Company'
    Description       = 'PowerShell Module for Exporting and Importing Conditional Access Policies via Microsoft Graph'
    PowerShellVersion = '7.0'
    FunctionsToExport = @(
        'Connect-GraphWithCertificate',
        'Export-ConditionalAccessPolicies',
        'Import-ConditionalAccessPolicy'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
