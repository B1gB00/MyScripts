# Install DHCP, Configure, change log location
$IP = "192.168.3.3"
$FQDN = "DHCP1.TSP.int"

# Install DHCP
Install-WindowsFeature -Name DHCP -IncludeManagementTools
# Netsh configures properties of DHCP Administrators / Users security group
netsh dhcp add securitygroups
Restart-Service dhcpserver
# Authorize DHCP in Domain
Add-DhcpServerInDC -DnsName $FQDN -IPAddress $IP
# Server Manger must be made aware that the post-install Confiugration (Security Authorization) is complete
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2
# Set server level DNS dynamic update configuration settings (Optional)
Set-DhcpServerv4DnsSetting -ComputerName $FQDN -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True
# Configure Administrative credential
# At prompt, supply credential in form DOMAIN\user, password
$Credential = Get-Credential
Set-DhcpServerDnsCredential -Credential $Credential -ComputerName $FQDN

# Change default install location for Database and Backup path
$Database = "D:\DHCP\dhcp.mdb"
$Backup = "D:\DHCP\Backup"
$Audit = "D:\DHCP"
Set-DhcpServerDatabase -ComputerName $FQDN -FileName $Database -BackupPath $Backup
Restart-Service dhcpserver
#This cmdlet will change the default location of the DHCP Audit log file
Set-DhcpServerAuditLog -ComputerName $FQDN -Path $Audit
Restart-Service dhcpserver

# Add and configure a DHCP Scope
$Name = "192.168.3.0/24"
$DHCPStartRange = "192.168.3.1"
$DHCPEndRange = "192.168.3.254"
$Subnet = "255.255.255.0"
$Network = "192.168.3.0"
$DefaultGateway = "192.168.3.254"
$ExclusionStartRange1 = "192.168.3.1"
$ExclusionStartRange2 = "192.168.3.250"
$ExclusionEndRange1 = "192.168.3.10"
$ExclusionEndRange2 = "192.168.3.254"
Add-DhcpServerv4Scope -name $Name -StartRange $DHCPStartRange -EndRange $DHCPEndRange -SubnetMask $Subnet -State Active
Add-DhcpServerv4ExclusionRange -ScopeID $Network -StartRange $ExclusionStartRange1 -EndRange $ExclusionEndRange1
Add-DhcpServerv4ExclusionRange -ScopeID $Network -StartRange $ExclusionStartRange2 -EndRange $ExclusionEndRange2
Set-DhcpServerv4OptionValue -OptionID 3 -Value $DefaultGateway -ScopeID $Network -ComputerName $DHCPFQDN
Set-DhcpServerv4OptionValue -OptionID 6 -Value $DC -ScopeId $Network -ComputerName $DHCPFQDN

# Create a DHCP Reservation
$DHCPReserve1 = "192.168.3.1"
$Description1 = "Domain Controller & DNS"
$ClientID1 = "00-15-5D-DB-1C-36"
$DHCPReserve2 = "192.168.3.3"
$Description2 = "DHCP Server"
$ClientID2 = "00-15-5D-DB-1C-39"
$DHCPReserve3 = "192.168.3.230"
$Description3 = "R&D: Bill Nye"
$ClientID3 = "00-15-5D-DB-1C-37"
$DHCPREserve4 = "192.168.3.231"
$Description4 = "HR: Ted Bundy"
$ClientID4 = "00-15-5D-DB-1C-34"
Add-DhcpServerv4Reservation -ScopeId $Network -IPAddress $DHCPReserve1 -ClientId $ClientID1 -Description $Description1
Add-DhcpServerv4Reservation -ScopeId $Network -IPAddress $DHCPReserve2 -ClientId $ClientID2 -Description $Description2
Add-DhcpServerv4Reservation -ScopeId $Network -IPAddress $DHCPReserve3 -ClientId $ClientID3 -Description $Description3
Add-DhcpServerv4Reservation -ScopeId $Network -IPAddress $DHCPReserve4 -ClientId $ClientID4 -Description $Description4