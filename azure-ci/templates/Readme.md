# Templates
## build.yml
Example of how to use the template.  
In this example the template is hosted ín another repository called my-templates in the project called MyProject.  
``` yml
trigger:
  branches:
    include:
      - main

resources:
  repositories:
  - repository: templates
    type: git
    name: MyProject/my-templates

stages:
- template: /templates/build.yml@templates
  parameters:
    name: MyPackageName
    feed: PowerShell
```
