# Build and publish PowerShell modules
## Installing a package from an Azure DevOps feed
PowerShell doesn't support v3 as of writing.
``` powershell
$token = "<PersonalAccessToken>"

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
## Creating a personal access token(PAT)
To create a personal access token go to your organization at this link.<br/>
https://dev.azure.com/myorganization/_usersSettings/tokens.<br/>

Just replace the organization with the name of your own. Click on `+ New token` and give it the scope `Packaging: Read`.
