#This PowerShell script connects to a SharePoint site and library specified by the parameters. It imports a CSV file containing key-value pairs. The script then iterates through each row in the CSV, creating a hashmap with the key-value pairs. Next, it retrieves all files from the source library and copies them to the destination library while updating the "Metadata" property of each file with the corresponding value from the hashmap.

#Parameters
$SiteURL = "https://zsdzr.sharepoint.com/sites/TestSitePowershell"
$LibraryName = "TestPowershell"
$CSVFilePath = "C:\Users\nikhi\OneDrive\Client Work\<test>\Scripts-Powershell\Intermediate\UpdateMetadataCSV.csv"
 
#Connect to PnP Online
    Connect-PnPOnline -Url $SiteURL -UseWebLogin
    $Web = Get-PnPWeb
 
    #Get the Document Library and its site relative URL
    $Library = Get-PnPList -Identity $LibraryName -Includes RootFolder
    If($Web.ServerRelativeUrl -eq "/")
    {
        $LibrarySiteRelativeURL = $Library.RootFolder.ServerRelativeUrl
    }
    else
    {
        $LibrarySiteRelativeURL = $Library.RootFolder.ServerRelativeUrl.Replace($Web.ServerRelativeUrl,'')
    }
 


# Create an empty hashmap to store CSV in memory for quick retriaval
$hashmap = @{}

# Import the CSV file
$csvData = Import-Csv -Path $CSVFilePath

# Iterate through each row in the CSV and add key-value pairs to the hashmap
foreach ($row in $csvData) {
    $key = $row.Name   # Replace 'KeyColumn' with the actual column name from your CSV
    $value = $row.TestMD   # Replace 'ValueColumn' with the actual column name from your CSV
    $hashmap[$key] = $value
}

# Get all files from the source library
    $Files = Get-PnPListItem -List $LibraryName -Fields "FileRef"
	

    # Copy each file to the destination library
    foreach ($File in $Files) {
        $FileRef = $File["FileRef"]
        $FileName = $FileRef.Substring($FileRef.LastIndexOf("/") + 1)
		#Get the File from SharePoint
        $SiteRelativeURL= $LibrarySiteRelativeURL+"/"+ $FileName
  
		#Update document properties
        Set-PnPListItem -List $Library -Identity $File.Id -Values @{"TestMD" = $hashmap[$FileName]}
	}