
# Current Computer_name 
$Comp_name = $env:COMPUTERNAME

# Prompt the user to input the current computer name
$target = Read-Host "Enter the target computer name (e.g., computer1)"

# IP of the DC
$ip = "192.168.77.5"

# interface index 
$inet_index = Get-NetIPInterface | Where-Object {$_.InterfaceAlias -match 'Eth*' -and $_.AddressFamily -eq "IPv4"} | Select-Object -ExpandProperty ifIndex 

# set dns 
Set-DnsClientServerAddress -InterfaceIndex $inet_index -ServerAddresses $ip

# Enable Administrator and Change its password 
Set-LocalUser -Name Administrator -Password (ConvertTo-SecureString "p@ssw0rdadmin" -AsPlainText -Force); Enable-LocalUser -Name Administrator 

# add the computer to the domain
Add-Computer -DomainName "sudo.local" -Credential "sudo\administrator"

# Disable AV
Set-MpPreference -DisableRealtimeMonitoring $true

# Disable Cloud Monitoring
Set-MpPreference -MAPSReporting 0

# mount the share 
net use * \\$ip\Treasure "MYpassword123#" /user:manager


# Check if the current computer name is "Computer1"
if ($target -eq "computer1") {
    
    if ($Comp_name.ToLower() -ne 'computer1') {
        
        # Rename the computer to "Computer1"
        Rename-Computer -NewName "Computer1" -Force
    }
    

    # add The user nawaf to The Remote Management Group 
    Add-LocalGroupMember -Name "Remote Management Users" -Member "nawaf@sudo.local"
}
# Check if the current computer name is "Computer2"
elseif ($target -eq "computer2") {

    if ($Comp_name.ToLower() -ne 'computer2') {

        # Rename the computer to "Computer1"
        Rename-Computer -NewName "Computer2" -Force
    }


    # add The user designer to The Administrators Group 
    Add-LocalGroupMember -Name "Administrators" -Member "designer@sudo.local"
}
else {
    # Print a message if neither "Computer1" nor "Computer2" is entered
    Write-Host "Sorry, please choose either 'computer1' or 'computer2'" -ForegroundColor Red
    exit
}

# Restart the Computer 
Restart-Computer -Force 
