<#
.SYNOPSIS
PowerShell Module for Exporting and Importing Conditional Access Policies using Microsoft Graph.

.DESCRIPTION
Provides cmdlets:
- Connect-GraphWithCertificate
- Export-ConditionalAccessPolicies
- Import-ConditionalAccessPolicy

Works with PowerShell 7 and the Microsoft Graph SDK.
#>

function Connect-GraphWithCertificate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string]$ClientId,
        [Parameter(Mandatory)] [string]$TenantId,
        [Parameter(Mandatory)] [string]$CertificateThumbprint
    )
    Import-Module Microsoft.Graph -ErrorAction Stop
    $cert = Get-ChildItem -Path "Cert:\CurrentUser\My\$CertificateThumbprint"
    Connect-MgGraph -ClientId $ClientId -TenantId $TenantId -Certificate $cert
}

function Export-ConditionalAccessPolicies {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string]$OutputPath
    )
    $policies = Get-MgIdentityConditionalAccessPolicy
    $timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm")
    $filename = Join-Path $OutputPath ("CA-Policies_$timestamp.json")
    $policies | ConvertTo-Json -Depth 10 | Out-File $filename -Encoding UTF8
    Write-Host "✅ Exported CA Policies to $filename"
}

function Import-ConditionalAccessPolicy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string]$PolicyFile
    )
    $policyData = Get-Content $PolicyFile | ConvertFrom-Json
    $clean = [PSCustomObject]@{
        DisplayName     = $policyData.displayName
        State           = $policyData.state
        Conditions      = $policyData.conditions
        GrantControls   = $policyData.grantControls
        SessionControls = $policyData.sessionControls
    }

    New-MgIdentityConditionalAccessPolicy -BodyParameter $clean
    Write-Host "✅ Policy imported: $($policyData.displayName)"
}
