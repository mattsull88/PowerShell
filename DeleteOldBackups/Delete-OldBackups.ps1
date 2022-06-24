#Define folders and file age to delete
$Paths = "\Folder1", "\Folder2"
$DateToDelete = (Get-Date).AddDays(-7)

#Loop through each folder and delete files older then the age
foreach ($Path in $Paths) {
    Get-ChildItem -Path $Path |
    Where-Object { $_.LastWriteTime -lt $DateToDelete} |
    Remove-Item
}