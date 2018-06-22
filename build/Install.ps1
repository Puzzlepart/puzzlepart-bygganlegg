<#

.SYNOPSIS
This script will install module Bygg or Anlegg  to a site collection - ProjectType can be set to Bygg, Anlegg or Prosjektportalen

.DESCRIPTION
Use the required -Url param to specify the target site collection. You can also install assets and default data to other site collections. The script will provision all the necessary lists, files and settings necessary for Prosjektportalen to work.

.EXAMPLE
./Install.ps1 -Url https://puzzlepart.sharepoint.com/sites/bygg -ProjectType Bygg

.LINK
https://github.com/Puzzlepart/prosjektportalen-bygganlegg

#>

Param(
    [Parameter(Mandatory = $true, HelpMessage = "Where do you want to install the Bygg & Anlegg customizations?")]
    [string]$Url,
    [Parameter(Mandatory = $true, HelpMessage = "Which project type do you want to install?")]
    [ValidateSet('Bygg', 'Anlegg')]
    [string]$ProjectType,
    [Parameter(Mandatory = $false, HelpMessage = "Stored credential from Windows Credential Manager")]
    [SecureString]$GenericCredential,
    [Parameter(Mandatory = $false, HelpMessage = "Use Web Login to connect to SharePoint. Useful for e.g. ADFS environments.")]
    [switch]$UseWebLogin,
    [Parameter(Mandatory = $false, HelpMessage = "Use the credentials of the current user to connect to SharePoint. Useful e.g. if you install directly from the server.")]
    [switch]$CurrentCredentials,
    [Parameter(Mandatory = $false, HelpMessage = "Use this flag if you're upgrading an installation.")]
    [switch]$Upgrade,
    [Parameter(Mandatory = $false, HelpMessage = "PowerShell credential to authenticate with")]
    [System.Management.Automation.PSCredential]$PSCredential,
    [Parameter(Mandatory = $false, HelpMessage = "Do you want to skip default config?")]
    [switch]$SkipDefaultConfig,
    [Parameter(Mandatory = $false, HelpMessage = "Do you want to skip adding data for stakeholders, standard documents, tasks and phase checklist?")]
    [switch]$SkipData,
    [Parameter(Mandatory = $false)]
    [ValidateSet('None', 'File', 'Host')]
    [string]$Logging = "File"
)

. ./SharedFunctions.ps1

#Handling credentials
if ($PSCredential -ne $null) {
    $Credential = $PSCredential
}
elseif ($GenericCredential -ne $null -and $GenericCredential -ne "") {
    $Credential = Get-PnPStoredCredential -Name $GenericCredential -Type PSCredential 
}
elseif ($Credential -eq $null -and -not $UseWebLogin.IsPresent -and -not $CurrentCredentials.IsPresent) {
    $Credential = (Get-Credential -Message "Please enter your username and password")
}

# Start installation
function Start-Install() {
    Connect-SharePoint $Url 
    $CurrentPPVersion = ParseVersion -VersionString (Get-PnPPropertyBag -Key pp_version)
    if (-not $CurrentPPVersion) {
        $CurrentPPVersion = "N/A"

        if ($ProjectPortalReleasePath -eq $null) {
            Write-Host "Project Portal is not installed on the specified URL. You need to specify ProjectPortalReleasePath to install Project Portal first." -ForegroundColor Red
            exit 1 
        }
    }

    # Prints header
    Write-Host "############################################################################" -ForegroundColor Green
    Write-Host "" -ForegroundColor Green
    Write-Host "Installing $($ProjectType) v{package-version}" -ForegroundColor Green
    Write-Host "" -ForegroundColor Green
    Write-Host "Installation URL:`t`t[$Url]" -ForegroundColor Green
    Write-Host "Environment:`t`t`t[$Environment]" -ForegroundColor Green
    Write-Host "Project Portal Version:`t`t[$CurrentPPVersion]" -ForegroundColor Green
    Write-Host "" -ForegroundColor Green
    Write-Host "############################################################################" -ForegroundColor Green

    # Starts stop watch
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $ErrorActionPreference = "Stop"

    # Sets up PnP trace log
    if ($Logging -eq "File") {
        $execDateTime = Get-Date -Format "yyyyMMdd_HHmmss"
        Set-PnPTraceLog -On -Level Debug -LogFile "pplog-$execDateTime.txt"
    }
    elseif ($Logging -eq "Host") {
        Set-PnPTraceLog -On -Level Debug
    }
    else {
        Set-PnPTraceLog -Off
    }

    # Apply bygg shared-config template 
    
    
    # Apply bygg shared-config template 
    try {     
        Connect-SharePoint $Url 
        Write-Host "Deploying shared-config with fields, content types and lists..." -ForegroundColor Green -NoNewLine
        Apply-Template -Template "shared-config" -ExcludeHandlers PropertyBagEntries
        Write-Host "`tDONE" -ForegroundColor Green
        Disconnect-PnPOnline
    }
    catch {
        Write-Host
        Write-Host "Error installing shared-config to $Url" -ForegroundColor Red
        Write-Host $error[0] -ForegroundColor Red
        exit 1 
    }
    # Installing config package
    if (-not $SkipData.IsPresent) {
        try {     
            Connect-SharePoint $Url 
            Write-Host "Deploying shared-data with lists..." -ForegroundColor Green -NoNewLine
            Apply-Template -Template "shared-data" -ExcludeHandlers PropertyBagEntries
            Write-Host "`tDONE" -ForegroundColor Green
            Disconnect-PnPOnline
        }
        catch {
            Write-Host
            Write-Host "Error installing shared-data to $Url" -ForegroundColor Red
            Write-Host $error[0] -ForegroundColor Red
            exit 1 
        }
    }
    switch ( $ProjectType ) {
        Bygg { 
           
            # Apply bygg-config template 
            try {     
                Connect-SharePoint $Url 
                Write-Host "Deploying bygg-config with fields, contentypes and lists ..." -ForegroundColor Green -NoNewLine
                Apply-Template -Template "bygg-config" -ExcludeHandlers PropertyBagEntries
                Write-Host "`tDONE" -ForegroundColor Green
                Disconnect-PnPOnline
            }
            catch {
                Write-Host
                Write-Host "Error installing bygg-config to $Url" -ForegroundColor Red
                Write-Host $error[0] -ForegroundColor Red
                exit 1 
            }

            # Apply bygg-data template 
            if (-not $SkipData.IsPresent) {
                try {     
                    Connect-SharePoint $Url 
                    Write-Host "Deploying bygg-data with lists..." -ForegroundColor Green -NoNewLine
                    Apply-Template -Template "bygg-data" -ExcludeHandlers PropertyBagEntries
                    Write-Host "`tDONE" -ForegroundColor Green
                    Disconnect-PnPOnline
                }
                catch {
                    Write-Host
                    Write-Host "Error installing bygg-data to $Url" -ForegroundColor Red
                    Write-Host $error[0] -ForegroundColor Red
                    exit 1 
                }
            }
        }
        Anlegg {
            # Apply anlegg template 
            try {     
                Connect-SharePoint $Url 
                Write-Host "Deploying anlegg-config with fields, contentypes and lists..." -ForegroundColor Green -NoNewLine
                Apply-Template -Template "anlegg-config" -ExcludeHandlers PropertyBagEntries
                Write-Host "`tDONE" -ForegroundColor Green
                Disconnect-PnPOnline
            }
            catch {
                Write-Host
                Write-Host "Error installing anlegg-config to $Url" -ForegroundColor Red
                Write-Host $error[0] -ForegroundColor Red
                exit 1 
            }
            # Apply anlegg template 
            if (-not $SkipData.IsPresent) {
                try {     
                    Connect-SharePoint $Url 
                    Write-Host "Deploying anlegg-data with lists..." -ForegroundColor Green -NoNewLine
                    Apply-Template -Template "anlegg-data" -ExcludeHandlers PropertyBagEntries
                    Write-Host "`tDONE" -ForegroundColor Green
                    Disconnect-PnPOnline
                }
                catch {
                    Write-Host
                    Write-Host "Error installing anlegg-data to $Url" -ForegroundColor Red
                    Write-Host $error[0] -ForegroundColor Red
                    exit 1 
                }
            }
        }
    }

    $sw.Stop()
    Write-Host "Installation completed in [$($sw.Elapsed)]" -ForegroundColor Green
}

Start-Install
