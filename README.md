# Build and publish PowerShell modules to Azure DevOps feeds
How to build and publish a PowerShell NuGet to an Azure DevOps feed.  
## Installing a package from an Azure DevOps feed
``` powershell
$token = "<PersonalAccessToken>"

# Pwsh doesn't support v3 as of writing
$feed = "https://pkgs.dev.azure.com/callofthevoid/_packaging/Powershell/nuget/v2"
$source = "CotvPowerShell"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$credential = New-Object System.Management.Automation.PSCredential("whatever", 
    ($token | ConvertTo-SecureString -AsPlainText -Force))

Register-PackageSource -Name $source `
                       -ProviderName PowerShellGet `
                       -Location $feed `
                       -Trusted `
                       -Credential $credential `
                       -Force

Install-Module -Name "<NameOfPackage>" `
               -Repository $source `
               -Force `
               -Credential $credential
```
