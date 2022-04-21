Function Get-ExampleMessage {
    param(
        [Parameter(Mandatory=$true)]
        [string] $Name
    )

    $message = "Hello $($Name)!"

    return $message
}