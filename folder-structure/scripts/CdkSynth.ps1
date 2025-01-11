param(
    [string]$AwsProfile    # Optional: AWS Profile.
)
$CurrentLocation = Get-Location

# Check if directory is a valid CDK app
$IsCdkInit = Test-Path ([System.IO.Path]::Join($CurrentLocation, "cdk.json"))
if (-not $IsCdkInit) {
    Write-Host "Current directory '$CurrentLocation' is not a valid CDK app. Exiting script." -ForegroundColor Red
    Exit 110814
}

$env:TMP = "C:\tmp"
if ([string]::IsNullOrWhiteSpace($AwsProfile)) {
    cdk synth
} else {
    cdk synth --profile $AwsProfile
}
