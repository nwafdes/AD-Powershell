# Rename the Computer 
Rename-Computer -NewName Computer2

# interface index 
$inet_index = Get-NetIPInterface | Where-Object {$_.InterfaceAlias -match 'Eth*' -and $_.AddressFamily -eq "IPv4"} | Select-Object -ExpandProperty ifIndex 

# set dns 
Set-DnsClientServerAddress -InterfaceIndex $inet_index -ServerAddresses "192.168.77.14"

# Enable Administrator and Change its password 
Set-LocalUser -Name Administrator -Password (ConvertTo-SecureString "p@ssw0rdadmin" -AsPlainText -Force); Enable-LocalUser -Name Administrator 

# add the computer to the domain
Add-Computer -DomainName "sudo.local" -Credential "sudo\administrator"

# add The user nawaf to The Remote Management Group 
Add-LocalGroupMember -Name "Administrators" -Member "designer@sudo.local"

# Restart the Computer 
Restart-Computer -Force 