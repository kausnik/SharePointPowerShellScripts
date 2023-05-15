#this script connects to a SharePoint Online site, retrieves files from a source library, and copies them to a destination library, handling errors that may occur during the process.

# Parameters
$SiteURL = "https://zsdzr.sharepoint.com/sites/TestSitePowershell"
$SourceLibraryName = "TestPowershell"
$DestinationLibraryName = "Staging"


try {
    # Connect to SharePoint Online site
    Connect-PnPOnline -Url $SiteURL -UseWebLogin

    # Get source and destination document libraries
    $SourceLibrary = Get-PnPList -Identity $SourceLibraryName
    $DestinationLibrary = Get-PnPList -Identity $DestinationLibraryName

    # Get all files from the source library
    $Files = Get-PnPListItem -List $SourceLibraryName -Fields "FileRef"

    # Move each file to the destination library
    foreach ($File in $Files) {
        $FileRef = $File["FileRef"]
        $FileName = $FileRef.Substring($FileRef.LastIndexOf("/") + 1)
        
		 # Read the file contents from the source library
       

		
        try {
            # Copy the file
            Copy-PnPFile -SiteRelativeUrl $FileRef -TargetUrl "$($DestinationLibrary.RootFolder.ServerRelativeUrl)/$FileName" -Force -OverwriteIfAlreadyExists
            Write-Host "File '$FileName' copied successfully."
        }
        catch {
            Write-Host "Error copyin file '$FileName': $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-Host "All files moved successfully!"
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

