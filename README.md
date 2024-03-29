# AD-Powershell

This repository contains a PowerShell script for configuring Active Directory settings with a focus on creating vulnerable configurations for educational purposes.

## Functionality

The script includes the following functionalities, but it is not limited to them:
- Creation of users with weak passwords
- Creation of service accounts (Kerberoasting)
- Configuration of users with reversible password encryption
- Planned ACL/ACE and DSync attacks (work in progress)
- Creation of an SMB share with full access (LNK Attack)
- Password Reuse (Pass the Hash)

## DC Configuration

Before running the script, ensure you meet the following prerequisites:

1. **PowerShell Execution Policy**: Ensure PowerShell is running with Administrator privileges.
2. **Active Directory Domain Services (ADDS)**: Install ADDS by executing `Install_AD.ps1`.
3. **Create Forest/Domain**: Run the following command to create the Forest/domain:
   ```powershell
   Install-ADDSForest -DomainName "sudo.local" -SafeModeAdministratorPassword (ConvertTo-SecureString "P@$$w0rd" -AsPlainText -Force) -InstallDns -Force
4. **Download Employees file**: Make sure you downloaded `Employees.txt`
4. **Run The Script**: Now you can run the script `DC_config.ps1`


## Workstations Configuration 

Make sure there is connectivity between Your computers and the DC 

1. Edit The $ip variable, and use the IP address of your DC
2. Start Powershell with elevated privileges and then run :
   ```powershell
      set-executionpolicy Bypass -scope process
4. when you are prompted to type the Computer name (you have 2 choices only, `computer1`/`computer2`) Please make sure to type them correctly to avoid any future errors.
5. Now you are ready to run `computer_config.ps1`


