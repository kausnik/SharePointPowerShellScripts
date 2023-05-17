# SharePointPowerShellScripts PnP
Basic scripts to manage SharePoint migrations and corrections


## Basic
1. Create-File-FromLocal : This script allows you to upload a file from  your local computer to SharePoint Online Document Library with metadata of your choice. 
2. Create-Folder-FromCSV :This script connects to a SharePoint site, reads a CSV file containing folder names, and creates those folders in a specified document library.Change the configurable variables in this script according to your environment.
3.Read-Files-FromDocumentLib: This script connects to a SharePoint site, retrieves all items from a specified document library, and displays their file names and test metadata. It provides a concise summary of the item details in the library.
4. Update-File-Metadata : he script allows you to connect to SharePoint, locate a specific file in a document library, and modify its metadata properties for better organization and management.
5. CopyFiles_bet_Doclib :this script connects to a SharePoint Online site, retrieves files from a source library, and copies them to a destination library, handling errors that may occur during the process.

## Intermediate
1. CopyFiles_Folder_Metadata: this script connects to a SharePoint site, retrieves files from a source library, creates corresponding folders in a destination library based on a specified metadata value, and copies the files to the destination library while preserving the folder structure. It handles exceptions and provides feedback on the success or failure of each file operation.
2. Update_metadata_fromCSV : It's a handy script to bulk upload Metadata on a document library. This PowerShell script connects to a SharePoint site and library specified by the parameters. It imports a CSV file containing key-value pairs. The script then iterates through each row in the CSV, creating a hashmap with the key-value pairs. Next, it retrieves all files from the source library a while updating the a specific "Metadata" property of each file with the corresponding value from the hashmap.

## Advanced
1. The script enables the creation of document sets based on metadata values for files in a SharePoint document library and moves the files into their respective document sets. You just need to define the parameters such as the SharePoint site URL, document library name, metadata field, and content type.
