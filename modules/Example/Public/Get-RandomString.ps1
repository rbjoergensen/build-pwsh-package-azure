Function Get-RandomString {
    param(
        [Parameter(Mandatory=$true)]
        [int] $Length
    )

    $string = -join ((33..126) | Get-Random -Count $Length | ForEach-Object {[char]$_})

    return $string
}