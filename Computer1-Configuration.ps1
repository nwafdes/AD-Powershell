# IP of the DC
$ip = "192.168.77.14"

# Rename the Computer 
Rename-Computer -NewName Computer1

# interface index 
$inet_index = Get-NetIPInterface | Where-Object {$_.InterfaceAlias -match 'Eth*' -and $_.AddressFamily -eq "IPv4"} | Select-Object -ExpandProperty ifIndex 

# set dns 
Set-DnsClientServerAddress -InterfaceIndex $inet_index -ServerAddresses $ip

# Enable Administrator and Change its password 
Set-LocalUser -Name Administrator -Password (ConvertTo-SecureString "p@ssw0rdadmin" -AsPlainText -Force); Enable-LocalUser -Name Administrator 

# add the computer to the domain
Add-Computer -DomainName "sudo.local" -Credential "sudo\administrator"

# Disable Firewall
Set-MpPreference -DisableRealtimeMonitoring $true

# add The user nawaf to The Remote Management Group 
Add-LocalGroupMember -Name "Remote Management Users" -Member "nawaf@sudo.local"

# mount the share 
net use * \\$ip\Treasure "MYpassword123#" /user:manager

# Restart the Computer 
Restart-Computer -Force 