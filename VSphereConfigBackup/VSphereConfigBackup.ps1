#Requires -Module VMware.PowerCLI
Import-Module VMware.PowerCLI

#Create VSphere and ESXi host variables
$VsphereHost = "192.168.1.200"
$Hostlist = "192.168.1.135", "192.168.1.209", "192.168.1.133"

#Connects to VSphere
Connect-VIServer -Server $VsphereHost -User "***" -Password "***" 

#Loops through each ESXi Host creating backup in both VSphere Datastore and secondary location. Secondary location may not be needed for you
foreach ($VMHost in $Hostlist) {
    Get-VMHost $VMHost | Get-VMHostFirmware -BackupConfiguration -DestinationPath C:\Temp
    $TimeNow = Get-Date -Format "yyyy.MM.dd.hh.mm"
    Rename-Item C:\Temp\configBundle-"$VMHost".tgz -NewName "$VMHost.$TimeNow.tgz"
#    Copy-Item C:\Temp\$VMHost.$TimeNow.tgz -Destination \\***\ExternalBackup***
    Move-Item C:\Temp\$VMHost.$TimeNow.tgz -Destination \\***\VSphereDatastoreBackup***

}
