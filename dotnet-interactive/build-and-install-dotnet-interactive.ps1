Set-StrictMode -version 2.0
$ErrorActionPreference = "Stop"

$toolLocation = ""
$toolVersion = ""
if (Test-Path 'env:DisableArcade') {
    Write-Host dotnet pack "$PSScriptRoot\dotnet-interactive.csproj" /p:Version=0.0.0
    dotnet pack "$PSScriptRoot\dotnet-interactive.csproj" /p:Version=0.0.0
    $script:toolLocation = "$PSScriptRoot\bin\debug"
    $script:toolVersion = "0.0.0"
} else {
    if ($IsLinux -or $IsMacOS) {
        Write-Host (Convert-Path "$PSScriptRoot\..\build.sh")
        & "$PSScriptRoot\..\build.sh" --pack
    } else {
        Write-Host (Convert-Path "$PSScriptRoot\..\eng\build.ps1")
        & "$PSScriptRoot\..\eng\build.ps1" -build -binaryLog -pack
    }

    $script:toolLocation = "$PSScriptRoot\..\artifacts\packages\Debug\Shipping"
    $script:toolVersion = "1.0.44142.42"
}
Write-Host "uninstall and reinstall dotnet-interactive"
dotnet tool uninstall -g dotnet-interactive
dotnet tool uninstall -g Microsoft.dotnet-interactive
dotnet tool install -g --add-source "$toolLocation" --version $toolVersion Microsoft.dotnet-interactive
