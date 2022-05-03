param (
    [Parameter(Mandatory=$true)]
    [string] $version,

    [Parameter(Mandatory=$true)]
    [string] $publish
)

$name = "Example"
$author = "<Name of author>"
$company = "<Name of company>"
$description = "Module contains functions for generating random gibberish."

$rootDir = "./modules/$($name)"
$definition = "$rootDir/$($name).psd1"
$module = "$($name).psm1"
$functions = (Get-Childitem -Path "./modules/$($name)/Public" -Filter "*.ps1").BaseName

$repository = "build-repo"
$publishFeed = $publish
$publish = "$((Get-Location).Path.Replace('\','/'))/packages/$($name)"

Write-Host "Version set to '$version'"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Installing Nuget packageprovider if not present"

if ($null -eq (Get-Packageprovider -Name NuGet)) 
{
    Write-Host "Nuget packageprovider not present"
    Install-Packageprovider -name nuget -PackageManagementProvider Nuget -force
}

Write-Host "Creating directory $publish"
New-Item -Path $publish -ItemType directory -Force | Out-Null

Write-Host "Listing Repositories"
Get-psrepository | Where-Object {$_.Name -eq $repository -or $_.SourceLocation -eq $publish} | Unregister-PSRepository

Write-Host "Registering Repository $Repository"
Register-PSRepository -Name $repository `
                      -SourceLocation $publish `
                      -PublishLocation $publish `
                      -InstallationPolicy Untrusted

Write-Host "Generating Module Manifest for $definition"
New-ModuleManifest -Path $definition `
                   -Author $author `
                   -CompanyName $company `
                   -RootModule $module `
                   -Description $description `
                   -ModuleVersion $version `
                   -FunctionsToExport $functions

Write-Host "Publishing Module"
Publish-Module -Name $rootDir -Repository $repository -Confirm:$False -Force

Write-Host "Copy .nupkg to artifact staging directory"
New-Item $publishFeed -Type Directory -Force
Copy-Item -Path "$($publish)/$($name).$($version).nupkg" -Destination "$($publishFeed)/$($name).$($version).nupkg" -Force -Verbose
