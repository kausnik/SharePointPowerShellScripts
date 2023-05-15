# this script connects to a SharePoint site, retrieves files from a source library, creates corresponding folders in a destination library based on a specified metadata value, and copies the files to the destination library while preserving the folder structure. It handles exceptions and provides feedback on the success or failure of each file operation.
$SiteURL = "https://zsdzr.sharepoint.com/sites/TestSitePowershell"
$SourceLibraryName = "TestPowershell"
$DestinationLibraryName = "Staging"


try {
   #Connect to PnP Online
    Connect-PnPOnline -Url $SiteURL -UseWebLogin
    $Web = Get-PnPWeb
 
    #Get the Destination Document Library and its site relative URL
    $Library = Get-PnPList -Identity $DestinationLibraryName -Includes RootFolder
    If($Web.ServerRelativeUrl -eq "/")
    {
        $LibrarySiteRelativeURL = $Library.RootFolder.ServerRelativeUrl
    }
    else
    {
        $LibrarySiteRelativeURL = $Library.RootFolder.ServerRelativeUrl.Replace($Web.ServerRelativeUrl,'')
    }
 
    
	# Get all files from the source library
    $Files = Get-PnPListItem -List $SourceLibraryName -Fields "FileRef", "TestMD"
	

    # Copy each file to the destination library
    foreach ($File in $Files) {
        $FileRef = $File["FileRef"]
        $FileName = $FileRef.Substring($FileRef.LastIndexOf("/") + 1)
        
		$FolderName = $File["TestMD"]
		#Replace Invalid Characters from Folder Name, If any
        $FolderName = [RegEx]::Replace($FolderName, "[{0}]" -f ([RegEx]::Escape([String]'\"*:<>?/\|')), '_')
		#Frame the Folder Name
        $FolderURL = $LibrarySiteRelativeURL+"/"+$FolderName
		#Create Folder if it doesn't exist
		
        try {
			#Create Folder if it doesn't exist
            Resolve-PnPFolder -SiteRelativePath $FolderURL | Out-Null
		    Write-host "Created Folder:"$FolderName -f Green
            # Copy the file
            Copy-PnPFile -SiteRelativeUrl $FileRef -TargetUrl "$($Library.RootFolder.ServerRelativeUrl)/$FolderName/$FileName" -Force -OverwriteIfAlreadyExists
            Write-Host "File '$FileName' copied successfully." -f Blue
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

