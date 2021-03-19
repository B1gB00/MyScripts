$VM = "SAN"

New-VHD -Path "V:\Capstone\VMs\VHDX\SAN-vDisk1.vhdx" -Dynamic -SizeBytes 30GB 
New-VHD -Path "V:\Capstone\VMs\VHDX\SAN-vDisk2.vhdx" -Dynamic -SizeBytes 30GB 
New-VHD -Path "V:\Capstone\VMs\VHDX\SAN-vDisk3.vhdx" -Dynamic -SizeBytes 30GB 
Add-VMHardDiskDrive -VMName $VM -Path "V:\Capstone\VMs\VHDX\SAN-vDisk1.vhdx" 
Add-VMHardDiskDrive -VMName $VM -Path "V:\Capstone\VMs\VHDX\SAN-vDisk2.vhdx" 
Add-VMHardDiskDrive -VMName $VM -Path "V:\Capstone\VMs\VHDX\SAN-vDisk3.vhdx" 
