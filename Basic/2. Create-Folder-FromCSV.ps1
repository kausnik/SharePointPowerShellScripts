
#This script connects to a SharePoint site, reads a CSV file containing folder names, and creates those folders in a specified document library.
# Change the configurable variables in this script according to your environment:

#$SiteURL: The URL of the SharePoint site.
#$CSVFilePath: The file path of the CSV file containing folder names.
#$LibraryName: The name of the document library in SharePoint where the folders will be created.


$SiteURL = "https://zsdzr.sharepoint.com/sites/TestSitePowershell"
$CSVFilePath = "C:\Users\nikhi\OneDrive\Client Work\BC Pensions\Scripts-Powershell\Basic\FolderList.csv"
$LibraryName = "TestPowershell"
 
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
 
    #Get the CSV file
    $CSVFile = Import-Csv $CSVFilePath
  
    #Read CSV file and create folders
    ForEach($Row in $CSVFile)
    {
        #Replace Invalid Characters from Folder Name, If any
        $FolderName = $Row.FolderName
        $FolderName = [RegEx]::Replace($FolderName, "[{0}]" -f ([RegEx]::Escape([String]'\"*:<>?/\|')), '_')
 
        #Frame the Folder Name
        $FolderURL = $LibrarySiteRelativeURL+"/"+$FolderName
 
        #Create Folder if it doesn't exist
        Resolve-PnPFolder -SiteRelativePath $FolderURL | Out-Null
        Write-host "Created Folder:"$FolderName -f Green
    }
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}