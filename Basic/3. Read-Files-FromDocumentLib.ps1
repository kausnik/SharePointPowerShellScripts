#This script connects to a SharePoint site, retrieves all items from a specified document library, and displays their file names and test metadata. It provides a concise summary of the item details in the library.

#Parameters
$SiteURL = "https://zsdzr.sharepoint.com/sites/TestSitePowershell"
$LibraryName = "TestPowershell"


 
#Connect to PnP Online
    Connect-PnPOnline -Url $SiteURL -UseWebLogin
    $Web = Get-PnPWeb
 
    #Get the Document Library 
    $Library = Get-PnPList -Identity $LibraryName -Includes RootFolder
   

# Get all items in the document library
	$Items = Get-PnPListItem -List $Library.Title
	

 # Display item details
    foreach ($Item in $Items) {
        Write-Host "File Name: $($Item.FieldValues.FileLeafRef)"
        Write-Host "Test Metadata: $($Item.FieldValues.TestMD)"
        Write-Host "-----------------------------"
    }