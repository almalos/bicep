#*************************************************************************************
#* Author       : Alex Malos                                                         *
#* Version      : v1.0                                                               *
#* Description  : Custom Apps installation for AVD                                            *
#************************************************************************************* 

Write-Host "###### Starting Custom Apps installation script ######"

#region: Variables
    $localPath = 'c:\temp\apps'
    # Assign connection string in a variable and pass the value to the -ConnectionString parameter
    # You need to get the connection string from the Azure portal > Storage account . Access keys
    $connection_string = 'DefaultEndpointsProtocol=https;AccountName=sadevwegitazb;AccountKey=of/Z1X6QxBf1A/Kn305QQvET9YPNnHaCPV5gKZDkS/sJdU3odyas2IDAF9lyJ8ANokYgB9usioIl+AStRoSiVQ==;EndpointSuffix=core.windows.net'  
    $storage_account = New-AzStorageContext -ConnectionString $connection_string  
    # Get the BLOBS in a container
    $container_name = 'apps'  
    $blobs = Get-AzStorageBlob -Container $container_name -Context $storage_account 

    # $outputPath = $localPath + '\' + $osOptFile
#endregion

#region: Create staging directory
    if((Test-Path c:\temp) -eq $false) {
        Write-Host "Creating C:\temp directory"       
        New-Item -Path c:\temp -ItemType Directory
    }
    else {
        Write-Host "C:\temp directory already exists"

    }
    if((Test-Path $localPath) -eq $false) {
        Write-Host "Creating $localPath directory"    
        New-Item -Path $LocalPath -ItemType Directory
    }
    else {
        Write-Host "$localPath directory already exists"

    }
#endregion

# Install Az Powershell module
# PowerShell script execution policy must be set to remote signed or less restrictive.
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Install the Az module for the current user only. This is the recommended installation scope.
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

# Download the Azure Storage BLOBS using Get-AzStorageBlobContent cmdlets
# The required parameters are:
# Container - Specify the name of the container
# Blob - Specify the blob Name
# Destination - Specify the Path where the blob's contents should download
# Context - Specify the context to access the storage BLOBS

$blobs = Get-AzStorageBlob -Container $container_name -Context $storage_account  
foreach ($blob in $blobs)  
{  
   New-Item -ItemType Directory -Force -Path $destination_path  
   Get-AzStorageBlobContent -Container $container_name -Blob $blob.Name -Destination $destination_path -Context $storage_account  
} 

Start-Process -FilePath "C:\temp\npp.8.5.1.Installer.x64.exe" -Wait -ArgumentList "/S /v /qn" -PassThru

# Get-ChildItem -Path "C:\Temp" *.* -Recurse | Remove-Item -Force -Recurse
Remove-Item -Path C:\temp -Recurse -Force
