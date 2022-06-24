$ou = ""
$domain = ""

$users = Get-ADuser -Server $domain -SearchBase $ou -Filter 'enabled -eq $true'

Add-Content -Path C:\temp\changes.csv  -Value '"oldSAM","newSAM"'


foreach ($user in $users) {
    $oldSAM = $user."samAccountName"
    $fname = $user."GivenName"
    $sname = $user."Surname"
    $num = 1
    $length = $sname.length


if ($sname.length -gt 5) {
    $newSAM = $sname.Substring(0,5) + $fname.Substring(3,1) + $num
}
else {
    $newSAM = $sname.Substring(0,$length) + $fname.Substring(3,1) + $num
}

try
{
    Get-ADuser -Identity $newSAM | Out-Null
    $found = "True"

}
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
{       
    $found = "False"
    
}

while ($found -eq "True")
{
    try
    {
        Get-ADuser -Identity $newSAM | Out-Null
        $found = "True"
        $num += 1
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {       
        $found = "False"
        
    }
    if ($sname.length -gt 5) 
    {
        $newSAM = $sname.Substring(0,5) + $fname.Substring(3,1) + $num
    }
    else {
        $newSAM = $sname.Substring(0,$length) + $fname.Substring(3,1) + $num
    }
}
Set-ADUser -Identity $oldSAM -SamAccountName $newSAM
Write-Host "$oldSAM changed to $newSAM"

Add-Content -Path  C:\temp\changes.csv -Value "$oldSAM,$newSAM"

}