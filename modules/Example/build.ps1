param (
    [Parameter(Mandatory=$true)]
    [string] $Version,

    [Parameter(Mandatory=$true)]
    [string] $Publish
)

$Author = "<Name of author>"
$Company = "<Name of company>"
$Description = "Module contains functions for generating random gibberish."

$Name = "Example"

$RootDir = "./modules/$($Name)"
$Definition = "$RootDir/$($Name).psd1"
$Module = "$($Name).psm1"
$Functions = (Get-Childitem -Path "./modules/$($Name)/Public" -Filter "*.ps1").BaseName

$Repository = "build-repo"
$PublishFeed = $Publish
$Publish = "$((Get-Location).Path.Replace('\','/'))/packages/$($Name)"

Write-Host "Version set to '$Version'"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Installing Nuget packageprovider if not present"

if ($null -eq (Get-Packageprovider -Name NuGet)) 
{
    Write-Host "Nuget packageprovider not present"
    Install-Packageprovider -name nuget -PackageManagementProvider Nuget -force
}

Write-Host "Creating directory $Publish"
New-Item -Path $Publish -ItemType directory -Force | Out-Null

Write-Host "Listing Repositories"
Get-psrepository | Where-Object {$_.Name -eq $Repository -or $_.SourceLocation -eq $Publish} | Unregister-PSRepository

Write-Host "Registering Repository $Repository"
Register-PSRepository -Name $Repository `
                      -SourceLocation $Publish `
                      -PublishLocation $Publish `
                      -InstallationPolicy Untrusted

Write-Host "Generating Module Manifest for $Definition"
New-ModuleManifest -Path $Definition `
                   -Author $Author `
                   -CompanyName $Company `
                   -RootModule $Module `
                   -Description $Description `
                   -ModuleVersion $Version `
                   -FunctionsToExport $Functions

Write-Host "Publishing Module"
Publish-Module -Name $RootDir -Repository $Repository -Confirm:$False -Force

Write-Host "Copy .nupkg to artifact staging directory"
New-Item $PublishFeed -Type Directory -Force
Copy-Item -Path "$($Publish)/$($Name).$($Version).nupkg" -Destination "$($PublishFeed)/$($Name).$($Version).nupkg" -Force -Verbose