$DiskNumber = "1"
$DriveLetter = "E"
$DomainName = "CAP.tsp"
$DatabasePath = "E:\NTDS"
$SysvolPath = "E:\SYSVOL"
$DomainNetBiosName = "CAP"

#Create & Format AD Backup Drive
Initialize-Disk $DiskNumber
New-Partition -DiskNumber $DiskNumber -DriveLetter $DriveLetter -UseMaximumSize
Format-Volume -DriveLetter $DriveLetter -FileSystem NTFS
New-Item -ItemType Directory -Path $DatabasePath , $SysvolPath

# Install ADDS
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
#Install AD-Forest
#Install-ADDSForest -DomainName $DomainName -InstallDns -DatabasePath $DatabasePath -DomainMode 7 -DomainNetbiosName $DomainNetBiosName -ForestMode 7 -LogPath $DatabasePath -SysvolPath $SysvolPath
#Promote this Server to DC2
Install-ADDSDomainController -CreateDnsDelegation:$false -DatabasePath "E:\NTDS" -DomainName "CAP.tsp" -InstallDns:$true -LogPath "E:\NTDS" -NoGlobalCatalog:$false -SiteName "Default-First-Site-Name" -SysvolPath "E:\SYSVOL" -NoRebootOnCompletion:$true -Force:$true -WhatIf
