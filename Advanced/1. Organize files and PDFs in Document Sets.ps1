#The script enables the creation of document sets based on metadata values for files in a SharePoint document library and moves the files into their respective document sets.

# Parameters
$SiteURL = "https://zsdzr.sharepoint.com/sites/TestSitePowershell"
$LibraryName = "Document_Set_test"
$MetadataField = "TestMD"
$ContentType = "Test_DocumentSetType"


# Start measuring the execution time
$timer = Measure-Command {
# Connect to SharePoint Online
Connect-PnPOnline -Url $SiteURL -UseWebLogin

# Get the document library
$Library = Get-PnPList -Identity $LibraryName -Includes RootFolder
$LibraryURL = $Library.RootFolder.ServerRelativeUrl

# Get all files with the specified metadata field
$Files = Get-PnPListItem -List $LibraryName -Fields "FileRef", $MetadataField

# Iterate through each file
foreach ($File in $Files) {
    $FileURL = $File["FileRef"]
	$FileName=($File.FieldValues.FileLeafRef)
    $MetadataValue = $File[$MetadataField]
    # Replace invalid characters from the metadata value, if any
    $DocumentSetName = [System.Text.RegularExpressions.Regex]::Replace($MetadataValue, "[{0}]" -f ([System.Text.RegularExpressions.Regex]::Escape([String]'\"*:<>?/\|')), '_')
    $DocumentSetName = $DocumentSetName -replace '\\+','\\'
    
    # Check if the document set already exists
    $DocumentSetURL = "$LibraryURL/$DocumentSetName"
	Write-Host "Document set URL  is '$DocumentSetURL'"
    $DocumentSetExists = Get-PnPFolder -Url $DocumentSetURL -ErrorAction SilentlyContinue

	
    if ($DocumentSetExists) {
        Write-Host "Document set '$DocumentSetName' already exists for file '$FileURL'." -ForegroundColor Yellow

        # Move the file to the document set
        try {
            Move-PnPFile -ServerRelativeUrl $FileURL -TargetUrl "$DocumentSetURL/$FileName" -OverwriteIfAlreadyExists -Force
            Write-Host "File '$FileURL' moved to document set '$DocumentSetName'." -ForegroundColor Yellow
        }
        catch {
            Write-Host "Error moving file '$FileURL' to document set '$DocumentSetName': $_.Exception.Message" -ForegroundColor Red
        }
    }
    else {
        try {
            # Create the document set
            Add-PnPDocumentSet -List $LibraryName -Name $DocumentSetName -ContentType $ContentType  -ErrorAction Stop
            Write-Host "Document set '$DocumentSetName' created for file '$FileURL'." -ForegroundColor Blue
			
			
        # Set additional metadata field values as needed
  

            # Move the file to the document set
            try {
               Move-PnPFile -ServerRelativeUrl $FileURL -TargetUrl "$DocumentSetURL/$FileName" -OverwriteIfAlreadyExists -Force
                Write-Host "File '$FileURL' moved to document set '$DocumentSetName'." -ForegroundColor Blue
            }
            catch {
                Write-Host "Error moving file '$FileURL' to document set '$DocumentSetName': $_.Exception.Message" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Error creating document set '$DocumentSetName' for file '$FileURL': $_.Exception.Message" -ForegroundColor Red
        }
    }
}

}
Write-Host "Document set creation and file moving completed in $($timer.TotalHours) hours" -ForegroundColor Green
