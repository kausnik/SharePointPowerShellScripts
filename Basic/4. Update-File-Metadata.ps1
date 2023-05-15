#The script allows you to connect to SharePoint, locate a specific file in a document library, and modify its metadata properties for better organization and management.

#Parameters
$SiteURL = "https://zsdzr.sharepoint.com/sites/TestSitePowershell"
$LibraryName = "TestPowershell"
$FileName = "1.docx"
$TestMetadata= "NK Custom Metadata"
$Title = "I can update existing metadata"
 
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
 
write-host "Library URL is '$LibrarySiteRelativeURL'"
#Get the File from SharePoint
$SiteRelativeURL= $LibrarySiteRelativeURL+"/"+ $FileName
  
#Get the File from SharePoint
$File = Get-PnPFile -Url $SiteRelativeURL -AsListItem
 
write-host "File ID is '$File.Id'" 
#Update document properties
Set-PnPListItem -List $Library -Identity $File.Id -Values @{"Title" = $Title; "TestMD" = $TestMetadata}
