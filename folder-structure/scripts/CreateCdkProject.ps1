param(
    [string]$ProjectName,           # Required: Name of the project
    [string]$Language = "csharp",   # Optional: Programming language (default is csharp)
    [switch]$Git                    # Optional: Initialize Git (default is false)
)

# Check if a $ProjectName was provided
if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    Write-Host "No -$$ProjectName argument was provided. Exiting script." -ForegroundColor Red
    Exit 1
}

# Create the directory with the $ProjectName
Write-Host "Creating project directory '$ProjectName'..."
New-Item -ItemType Directory -Path $ProjectName -Force | Out-Null

# Navigate into the newly created directory
Set-Location -Path $ProjectName 

# Initialize the CDK
Write-Host "Initializing the CDK app..."
if ($Git) {
    cdk init app --language $Language
} else {
    cdk init app --language $Language --generate-only
}

Write-Host "CDK Project '$ProjectName' initialized successfully!" -ForegroundColor Green
