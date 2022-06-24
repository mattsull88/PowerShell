$domain = ""

Import-Csv "C:\temp\changes.csv" | ForEach-Object {
    Set-ADUser  -Server $domain -Identity $newSAM -SamAccountName $oldSAM
  }