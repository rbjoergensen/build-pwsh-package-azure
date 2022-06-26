foreach ($file in Get-ChildItem "$PSScriptRoot\Public") {
    . $file.FullName
}