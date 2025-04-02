Set-StrictMode -Off

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$downloadUrl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
$zipFilePath = "platform-tools.zip"
$platformToolsPath = "$env:LOCALAPPDATA\Android\platform-tools"

clear

Write-Output "Easy ADB and fastboot installer"
Write-Output "by youmu1948"

try {
    if (-not (Test-Path -Path $platformToolsPath)) {
        New-Item -ItemType Directory -Path $platformToolsPath
        Write-Output "Successfully created directory: $platformToolsPath"
    } else {
        Write-Output "Directory already exists: $platformToolsPath"
    }
} catch {
    Write-Error "Failed to create directory: $($_.Exception.Message)"
    Read-Host -Prompt "`nPress enter key to exit this script.."
    Exit 1
}

try {
    Write-Output "Downloading Platform-tools..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFilePath
    Write-Output "Platform-tools successfully downloaded."
} catch {
    Write-Error "Download failed: $($_.Exception.Message). Please check your internet connection and try again."
    Read-Host -Prompt "`nPress enter key to exit this script.."
    Exit 1
}

try {
    Write-Output "Unzipping Platform-tools..."
    Expand-Archive -Path $zipFilePath -DestinationPath $platformToolsPath -Force
    Write-Output "Platform-tools successfully unzipped."
} catch {
    Write-Error "Failed to unzip Platform-tools: $($_.Exception.Message)"
    Read-Host -Prompt "`nPress enter key to exit this script.."
    Exit 1
}

try {
    if (Test-Path -Path $zipFilePath) {
        Remove-Item -Path $zipFilePath
        Write-Output "Downloaded zip file deleted."
    }
} catch {
    Write-Warning "Failed to delete downloaded zip file: $($_.Exception.Message)"
}

$pathChoice = Read-Host "`nAre you sure you want to set PATH? (Y/N)"

if ($pathChoice -eq "y") {
    try {
        Write-Output "Setting PATH..."
        $env:PATH += ";$platformToolsPath\platform-tools"
        [Environment]::SetEnvironmentVariable("PATH", $env:PATH, "User")
        Write-Output "PATH successfully set."

        if ($env:PATH -match [regex]::Escape($platformToolsPath)) {
            Write-Output "PATH environment variable has been updated successfully"
            $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "User")
        } else {
            Write-Warning "PATH environment variable update may have failed."
        }
    } catch {
        Write-Error "Failed to set PATH: $($_.Exception.Message)"
        Read-Host -Prompt "`nPress enter key to exit this script.."
        Exit 1
    }
} elseif ($pathChoice -eq "n") {
    Write-Output "PATH setting canceled."
} else {
    Write-Output "Invalid input."
}

Write-Output "`nSuccessfully installed ADB and fastboot."
Write-Output "`nTo execute ADB and fastboot command, please install Google USB driver."
Write-Output "`nDownload: https://developer.android.com/studio/run/win-usb"
Read-Host -Prompt "`nPress enter key to continue.."
Exit 0