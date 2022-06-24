# Requires Module MSOnline and ActiveDirectory installed
# Import Modules
Import-Module ActiveDirectory
Import-Module MsolService

# Variables for the script
$FirstName = Read-Host "Enter First Name"
$Surname = Read-Host "Enter Last Name"
$Username = Read-Host "Enter Username"
$ADgroups = Read-Host "Copy AD group membership from which user? (Enter username)"
$Password = Read-Host "Enter a Password" | ConvertTo-SecureString -AsPlainText -Force

# Creating Displayname, First name, surname, samaccountname, UPN, etc and entering and a password for the user.
 New-ADUser `
    -Name "$FirstName $Surname" `
    -GivenName $FirstName `
    -Surname $Surname `
    -SamAccountName $Username `
    -UserPrincipalName $Username@***.com.au `
    -Displayname "$FirstName $Surname" `
    -Path "OU=***,DC=***,DC=com,DC=au" `
    -AccountPassword $Password `
    -HomeDirectory ***$username$ `
    -Homedrive H `
    -ScriptPath ***

# Set required details
Set-ADUser $Username -Enabled $True
Set-ADUser $Username -ChangePasswordAtLogon $False 
Set-ADUser $Username -EmailAddress "$Username@***.com.au"

# Finds all the AD-groups that the "$ADGroups" user you entered is a part of and adds it to the new user automatically.
Get-ADPrincipalGroupMembership -Identity $ADgroups  | `
Select-Object SamAccountName | `
ForEach-Object  {
    Add-ADGroupMember -Identity $_.SamAccountName -Members $Username
} 
Write-Host -BackgroundColor DarkGreen "Ignore error that user is already a member of default group"

# Create user folder and Share
Invoke-Command -ComputerName *** -ScriptBlock `
    {mkdir ***\$using:username} 
Invoke-Command -ComputerName *** -ScriptBlock `
    {New-SMBShare –Name $using:username$ `
             –Path ***\$using:username `
             –FullAccess Administrators, $using:username} 

#create Office365 account and add Business standard license
Connect-MsolService -UserPrincipalName *** -ShowProgress $true
New-MsolUser `
    -DisplayName "$using:FirstName $using:Surname" `
    -FirstName "$using:FirstName" `
    -LastName "$using:Surname" `
    -UserPrincipalName $using:Username@***.com.au `
    -UsageLocation AUS `
    -Password $using:Password `
    -ForceChangePassword $False`
    -AccountEnabled $using:true

    Set-MsolUserLicense `
    -UserPrincipalName $using:Username@***.com.au `
    -AddLicense "***:ENTERPRISEPACK"
#End
Write-Host -BackgroundColor DarkGreen "Active Directory user account setup complete with default logon script! "