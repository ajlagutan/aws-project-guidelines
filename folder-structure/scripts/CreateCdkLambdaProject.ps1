param(
    [string]$ModuleName,    # Required: Name of the module.
    [string]$FunctionName,  # Required: Name of the lambda function.
    [switch]$TopLevel       # Optional: Uses the lambda.EmptyTopLevelFunction template instead. (default is false)
)
$CurrentLocation = Get-Location
$CurrentProjectName = (Get-Item $CurrentLocation).Name

# Check if directory is a valid CDK app
$IsCdkInit = Test-Path ([System.IO.Path]::Join($CurrentLocation, "cdk.json"))
if (-not $IsCdkInit) {
    Write-Host "Current directory '$CurrentLocation' is not a valid CDK app. Exiting script." -ForegroundColor Red
    Exit 110814
}

# Check if a $ModuleName was provided
if ([string]::IsNullOrWhiteSpace($ModuleName)) {
    Write-Host "No -ModuleName argument was provided. Exiting script."
    Exit 110817 
}

# # Check if a $Template was provided
# if (-not [string]::IsNullOrWhiteSpace($Template)) {
#     if ($Template.Contains("C")) {
#         $FunctionName = [string]::Concat($ModuleName, "Create")
#         CreateCdkLambdaProject -ModuleName $ModuleName -FunctionName $FunctionName
#     }
#     if ($Template.Contains("R")) {
#         $FunctionName = [string]::Concat($ModuleName, "Get")
#         CreateCdkLambdaProject -ModuleName $ModuleName -FunctionName $FunctionName
#     }
#     if ($Template.Contains("L")) {
#         $FunctionName = [string]::Concat($ModuleName, "GetList")
#         CreateCdkLambdaProject -ModuleName $ModuleName -FunctionName $FunctionName
#     }
#     if ($Template.Contains("U")) {
#         $FunctionName = [string]::Concat($ModuleName, "Update")
#         CreateCdkLambdaProject -ModuleName $ModuleName -FunctionName $FunctionName
#     }
#     if ($Template.Contains("D")) {
#         $FunctionName = [string]::Concat($ModuleName, "Delete")
#         CreateCdkLambdaProject -ModuleName $ModuleName -FunctionName $FunctionName
#     }
#     Exit 0
# }

# Check if a $FunctionName was provided
if ([string]::IsNullOrWhiteSpace($FunctionName)) {
    Write-Host "No -FunctionName argument was provided. Exiting script."
    Exit 110821
}

# Configure the $LambdaTemplate based on the -TopLevel switch
$LambdaTemplate = "lambda.EmptyFunction"
if ($TopLevel) {
    # $LambdaTemplate = "lambda.EmptyTopLevelFunction"

    Write-Host "Parameter -TopLevel is not implemented on the current version." -ForegroundColor Red
    Exit 110908
}
$LambdaSrc = [System.IO.Path]::Join($CurrentLocation, "src", $ModuleName, "src", $FunctionName, "$FunctionName.csproj")
$LambdaTest = [System.IO.Path]::Join($CurrentLocation, "src", $ModuleName, "test", "$FunctionName.Tests", "$FunctionName.Tests.csproj")

$Overwrite = $false
if (Test-Path $LambdaSrc) {
    $MustOverwrite = Read-Host "Function '$FunctionName' on module '$ModuleName' already exists. Do you want to overwrite the project? (y/n)"
    if ($MustOverwrite -eq "y") {
        $Overwrite = $true
    } else {
        Write-Host "Exiting script."
        Exit 110916
    }
}

if ($Overwrite) {
    Write-Host "Overwriting lambda function '$FunctionName'..."
    dotnet new $LambdaTemplate --name $FunctionName --output "src/$ModuleName" --force
} else {
    Write-Host "Creating lambda function '$FunctionName'..."
    dotnet new $LambdaTemplate --name $FunctionName --output "src/$ModuleName"
}
if (-not (Test-Path $LambdaSrc) -or -not (Test-Path $LambdaTest)) {
    Write-Host "Creating lambda function '$FunctionName' failed." -ForegroundColor Red
    Exit 110910
}

$SolutionFile = [System.IO.Path]::Join($CurrentLocation, "src", "$CurrentProjectName.sln")
if (Test-Path $SolutionFile) {
    Write-Host "Updating CDK project solution file."
    dotnet sln "$SolutionFile" add "$LambdaSrc" "$LambdaTest"
}
