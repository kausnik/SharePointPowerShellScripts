# this script allows you to upload a file from  your local computer to SharePoint Online Document Library, with metadata of your choice
# change the pasameters SiteURL, LibraryName FilesPath and the custom metdata fields or existing metadata


$SiteURL = "https://zsdzr.sharepoint.com/sites/TestSitePowershell"
$LibraryName = "TestPowershell"
$FilesPath="C:\Users\nikhi\OneDrive\Desktop\test1.docx"
 
Try {
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
 
    #Get the  file from Local machine
   $File = Get-ChildItem -Path $FilesPath
   
   
   #Upload the file to SharePoint Online folder - and Set Metadata
    Add-PnPFile -Path $File.FullName -Folder $LibrarySiteRelativeURL -Values @{"Title" = $($File.Name); "TestMD"="My Custom metadata"}

}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}