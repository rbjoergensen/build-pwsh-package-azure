# Build and publish PowerShell modules
## Build and Publish using the Azure DevOps template
In this example I'm using the template from an external source on GitHub instead of the one local to the repository.
I'm specifying the name I want the package to have and the feed in my current organization that i want to publish to.
<br/><br/>
The path to the module is expected to have file called `RootModule.psm1` with the same content as in the example and a folder called `Public`.
The public folder should contain a file for each function named exactly after the function inside. 
This is so that the build script can automatically include each function in the manifest.
``` yaml
trigger:
  branches:
    include:
      - main
  paths:
    include:
      - modules/Example/**

resources:
  repositories:
  - repository: templates
    type: github
    name: rbjoergensen/azure-devops-templates

stages:
- template: /powershell/build.yml@templates
  parameters:
    name: MyTestPackage
    path: $(System.DefaultWorkingDirectory)/modules/Example
    feed: PowerShell
    author: github.com/rbjoergensen
    company: CallOfTheVoid
    descritpion: An example module
```
## Installing a package from an Azure DevOps feed
PowerShell doesn't support v3 as of writing.
``` powershell
$token = "<PersonalAccessToken>"

$feed = "https://pkgs.dev.azure.com/callofthevoid/_packaging/Powershell/nuget/v2"
$source = "CotvPowerShell"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$credential = New-Object System.Management.Automation.PSCredential("whatever", 
    ($token | ConvertTo-SecureString -AsPlainText -Force))

Register-PackageSource `
    -Name $source `
    -ProviderName PowerShellGet `
    -Location $feed `
    -Trusted `
    -Credential $credential `
    -Force

Install-Module `
    -Name "<NameOfPackage>" `
    -Repository $source `
    -Force `
    -Credential $credential
```
## Creating a personal access token(PAT)
To create a personal access token go to your organization at this link.<br/>
https://dev.azure.com/myorganization/_usersSettings/tokens.<br/>

Just replace the organization with the name of your own. Click on `+ New token` and give it the scope `Packaging: Read`.
