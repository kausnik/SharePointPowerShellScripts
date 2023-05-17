#The script allows you to bulk update metadata values for files in a SharePoint library based on the information provided in the CSV file. It reads the following inputs in the CSV file containing file names, folder names, and corresponding metadata values.

# Parameters
$SiteURL = "https://zsdzr.sharepoint.com/sites/TestSitePowershell"
$LibraryName = "TestPowershell"
$CSVFilePath = "C:\Users\nikhi\OneDrive\Client Work\BC Pensions\Scripts-Powershell\Intermediate\Level2_metadata.csv"
$MetadataToUpdate = "TestMD"
$timer = Measure-Command {
# Connect to SharePoint Online
Connect-PnPOnline -Url $SiteURL -UseWebLogin

# Get the document library
$Library = Get-PnPList -Identity $LibraryName -Includes RootFolder
$LibraryURL = $Library.RootFolder.ServerRelativeUrl

# Read the CSV file
$CSVData = Import-Csv -Path $CSVFilePath

# Iterate through each row in the CSV
foreach ($Row in $CSVData) {
    $FolderName = $Row.Folder
    $FileName = $Row.Name
    $MetadataValueFromCSV = $Row.TestMD

    Write-Host "File is '$FolderName/$FileName'"
    # Get the folder by name
    $Folder = Get-PnPFolder -Url "$LibraryURL/$FolderName" -ErrorAction SilentlyContinue

    if ($Folder) {
        try {
            # Get the file by name within the folder
            $File = Get-PnPFile -Url "$LibraryURL/$FolderName/$FileName" -AsListItem -ErrorAction SilentlyContinue

            if ($File) {
                # Update the metadata field value
                Set-PnPListItem -List $LibraryName -Identity $File.id -Values @{ $MetadataToUpdate = $MetadataValueFromCSV }
                Write-Host "Metadata updated for file '$FolderName/$FileName' with '$MetadataValueFromCSV'."
            }
            else {
                Write-Host "File '$FileName' not found in the folder '$FolderName'." -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "Error updating metadata for file '$FolderName/$FileName': $_.Exception.Message" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Folder '$FolderName' not found in the document library." -ForegroundColor Yellow
    }
}
}
Write-Host "Metadata update  completed in $($timer.TotalHours) hours" -ForegroundColor Green