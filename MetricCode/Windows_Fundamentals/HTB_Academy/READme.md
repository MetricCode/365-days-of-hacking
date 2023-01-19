# Windows Fundamentals!
## @Author : M3tr1c_r00t
### HTB_Academy!
### Windows Versions...

![image](https://user-images.githubusercontent.com/99975622/212542317-d8ed1c5e-3167-4cd5-bd6c-a77494a66e44.png)

We can use the <a href="https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1">get-wmiobject</a> in powershell to get more information on a system.

Also, we can use the <a href="https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-overview?view=powershell-7"> cmd-outlet</a>

Checking the Version and Build Number...
```
 Get-WmiObject -Class win32_OperatingSystem| select Version,BuildNumber
```
![image](https://user-images.githubusercontent.com/99975622/212542657-a4fac87c-02c9-461b-8976-82226ce3606b.png)
Checking the Bios information...
```
Get-WmiObject -Class win32_Bios
```
![image](https://user-images.githubusercontent.com/99975622/212542793-49bb8fa6-491d-4142-8965-4cbe12c49951.png)

### Accessing Windows
#### Local Access
This refers to accessing a computer physically.
#### Remote Access
This refers to accessing a computer over a network.
Some of the most common remote access technologies include:
- Virtual Private Networks (VPN)
- Secure Shell (SSH)
- File Transfer Protocol (FTP)
- Virtual Network Computing (VNC)
- Windows Remote Management (or PowerShell Remoting) (WinRM)
- Remote Desktop Protocol (RDP)

### Remote Desktop Protocol (RDP)
RDP uses a client/server architecture where a client-side application is used to specify a computer's target IP address or hostname over a network where RDP access is enabled.

The target computer where RDP remote access is enabled is considered the server. 

RDP listens by default on logical port 3389.

#### Connection to a windows target from a windows host...
 we can use the built-in RDP client application called Remote Desktop Connection (mstsc.exe).
 ![UsingRemoteDesktopConnection](https://user-images.githubusercontent.com/99975622/212544854-6a801d78-5d94-40fa-8bab-ff55b2111970.gif)
 
 Saving The RDP profiles for easy login/connection
 ![SavingRDPConnections](https://user-images.githubusercontent.com/99975622/212544952-b26dfe0e-c437-4e5a-9b39-439834de1abc.gif)
 
 #### Connection to a windows target from a Linux host...
 For linux, we can connect using xfreerdp
 ```
 xfreerdp /v:<targetIp> /u:htb-student /p:Password
 ```
 ![ConnectingwithXfreerdp](https://user-images.githubusercontent.com/99975622/212545110-52d36dda-8072-463e-89fd-10dd2c5ffc68.gif)
 
 Other RDP clients exist, such as Remmina and rdesktop.
 
 ### Operating System Structure
 The root directory is usually in the c drive.
 Some of the directories in the root system include:
![image](https://user-images.githubusercontent.com/99975622/212546385-64d1728a-ba5f-4794-a111-0221ae8a5483.png)
To list Directories in a tree like manner;
```
tree "c:\Program Files (x86)\VMware"
```
![image](https://user-images.githubusercontent.com/99975622/212546554-eb5fa48e-1d54-4ba1-864e-53ea05d815a5.png)

You can use this command to control the amount of output coming from the terminal...
```
tree C:\ /f | more
```

### File System
There are 5 types of Windows file systems: FAT12, FAT16, FAT32, NTFS, and exFAT.
FAT12 and FAT16 are no longer used on modern Windows operating systems. 

#### FAT32
FAT32 (File Allocation Table) is widely used across many types of storage devices such as USB memory sticks and SD cards but can also be used to format hard drives. The "32" in the name refers to the fact that FAT32 uses 32 bits of data for identifying data clusters on a storage device.

Pros of FAT32:
- Device compatibility - it can be used on computers, digital cameras, gaming consoles, smartphones, tablets, and more.
- Operating system cross-compatibility - It works on all Windows operating systems starting from Windows 95 and is also supported by MacOS and Linux.

Cons of FAT32:
- Can only be used with files that are less than 4GB.
- No built-in data protection or file compression features.
- Must use third-party tools for file encryption.

#### NTFS
NTFS (New Technology File System) is the default Windows file system since Windows NT 3.1. In addition to making up for the shortcomings of FAT32, NTFS also has better support for metadata and better performance due to improved data structuring.

Pros of NTFS:
- NTFS is reliable and can restore the consistency of the file system in the event of a system failure or power loss.
- Provides security by allowing us to set granular permissions on both files and folders.
Supports very large-sized partitions.
- Has journaling built-in, meaning that file modifications (addition, modification, deletion) are logged.

Cons of NTFS:
- Most mobile devices do not support NTFS natively.
- Older media devices such as TVs and digital cameras do not offer support for NTFS storage devices.

#### Permissions
![image](https://user-images.githubusercontent.com/99975622/212547237-f3690da2-1a0b-4f5e-86c9-a42c83f77e8a.png)

Files and folders inherit the NTFS permissions of their parent folder for ease of administration, so administrators do not need to explicitly set permissions for each file and folder.
#### Integrity Control Access Control List (icacls)
We can list out the NTFS permissions on a specific directory by running either icacls from within the working directory or icacls C:\Windows against a directory not currently in.

![image](https://user-images.githubusercontent.com/99975622/212548116-d38fe2d8-49c1-40b9-8b60-13b27fbeda2f.png)

The resource access level is list after each user in the output. The possible inheritance settings are:
- (CI): container inherit
- (OI): object inherit
- (IO): inherit only
- (NP): do not propagate inherit
- (I): permission inherited from parent container

Basic access permissions are as follows:
- F : full access
- D :  delete access
- N :  no access
- M :  modify access
- RX :  read and execute access
- R :  read-only access
W :  write-only access

We can add and remove permissions via the command line using icacls. 
The command icacls c:\users /grant joe:f we can grant the joe user full control over the directory.
But given that (oi) and (ci) were not included in the command, the joe user will only have rights over the c:\users folder but not over the user subdirectories and files contained within them.

These permissions can be revoked using the command icacls c:\users /remove joe.

<a href="https://ss64.com/nt/icacls.html" > icacls commands lists</a>

### NTFS vs. Share Permissions
The Server Message Block protocol (SMB) is used in Windows to connect shared resources like files and printers.
Share permissions include:
![image](https://user-images.githubusercontent.com/99975622/212549081-30ebe800-07e8-49ad-9049-93b4a0396f5b.png)
NTFS Basic permissions
![image](https://user-images.githubusercontent.com/99975622/212549109-2435b510-0c03-43c3-9646-717ce974783a.png)
NTFS special permissions
![image](https://user-images.githubusercontent.com/99975622/212549165-999d8a30-3962-49fe-8c44-fee8976a662b.png)
Keep in mind that NTFS permissions apply to the system where the folder and files are hosted. Folders created in NTFS inherit permissions from parent folders by default. It is possible to disable inheritance to set custom permissions on parent and subfolders, as we will do later in this module. The share permissions apply when the folder is being accessed through SMB, typically from a different system over the network. This means someone logged in locally to the machine or via RDP can access the shared folder and files by simply navigating to the location on the file system and only need to consider NTFS permissions. The permissions at the NTFS level provide administrators much more granular control over what users can do within a folder or file.

### Creating a Network Share
- First off, create an empty folder...
( Most large enterprise environments, shares are created on a Storage Area Network (SAN), Network Attached Storage device (NAS), or a separate partition on drives accessed via a server operating system like Windows Server. If we ever come across shares on a desktop operating system, it will either be a small business or it could be a beachhead system used by a penetration tester or malicious attacker to gather and exfiltrate data.)

- Making the Folder a Share...
(Go to the folder properties, in the sharing tab, click on advanced sharing. Click on share this folder. Note you can limit the number of users to access the share at once. Note that  there is an access control list (ACL) for shared resources. The ACL contains access control entries (ACEs) which are made up of users and groups. You can set the permissions for everyone , either read,write or both.)
![image](https://user-images.githubusercontent.com/99975622/212549670-b5294044-852d-4da5-8a8e-436df10eb1f4.png)
Setting permissions
![image](https://user-images.githubusercontent.com/99975622/212549696-7b99c9a9-c1e0-46a3-8b43-482879df6797.png)
And done!

In our case,we are being blocked if we try to connect through our linux system.
It is also important to note that when a Windows system is part of a workgroup, all netlogon requests are authenticated against that particular Windows system's SAM database. When a Windows system is joined to a Windows Domain environment, all netlogon requests are authenticated against Active Directory.

The primary difference between a workgroup and a Windows Domain in terms of authentication, is with a workgroup the local SAM database is used and in a Windows Domain a centralized network-based database (Active Directory) is used. We must know this information when attempting to logon & authenticate with a Windows system. Consider where the htb-student account is hosted to properly connect to the target.

In terms of the firewall blocking connections, this can be tested by completely deactivating each firewall profile in Windows or by enabling specific predefined inbound firewall rules in the Windows Defender Firewall advanced security settings. Like most firewalls, Windows Defender Firewall permits or denies traffic (access & connection requests in this case) flowing inbound &/or outbound

The different inbound and outbound rules are associated with the different firewall profiles in defender.

Windows Defender Firewall Profiles:

- Public
- Private
- Domain

It is a best practice to enable predefined rules or add custom exceptions rather than deactivating the firewall altogether. 

#### Creating a Mounting Point...
 Once a connection is established with a share, we can create a mount point from our Pwnbox to the Windows 10 target box's file system.
 
 We can create a mounting point if the files that are in the smb shares are super large.
 In this case, we need to consider the NTFS permissions.
 ![image](https://user-images.githubusercontent.com/99975622/212554231-4d9bc915-176c-45d1-a10a-b8e20fada3ba.png)
 
 Mounting command...
 ```
 sudo mount -t cifs -o username=htb-student,password=Academy_WinFun! //<TARGET_IP>/"Share_Name" /home/user/Desktop/
 ```
 If the command doesnt work, we need to install cifs-utils
 ```
 sudo apt-get install cifs-utils
 ```
 
#### Monitoring Shares
We can use the command 'net share' to see all the available shares in the system.
 
Computer Management is another tool we can use to identify and monitor shared resources on a Windows system.

We can poke around in Shares, Sessions, and Open Files to get an idea of what information this provides us. Should there be a situation where we assist an individual or organization with responding to a breach related to SMB, these are some great places to check and start to understand how the breach may have happened and what may have been left behind.

#### Viewing Share access logs in Event Viewer
Event Viewer is another good place to investigate actions completed on Windows. Almost every operating system has a logging mechanism and a utility to view the logs that were captured. Know that a log is like a journal entry for a computer, where the computer writes down all the actions that were performed and numerous details associated with that action. We can view the logs created for every action we performed when accessing the Windows 10 target box, as well as when creating, editing and accessing the shared folder.

![image](https://user-images.githubusercontent.com/99975622/212555677-b5bf2cbe-cc4b-40bb-9e7c-f21b09160c00.png)

### Windows Services & Processes
#### Windows Services
Windows services are managed via the Service Control Manager (SCM) system, accessible via the services.msc MMC add-in.
This add-in provides a GUI interface for interacting with and managing services and displays information about each installed service. This information includes the service Name, Description, Status, Startup Type, and the user that the service runs under.

It is also possible to query and manage services via the command line using sc.exe using __PowerShell__ cmdlets such as **__Get-Service__**.

This shows the first 2 running services...
```
Get-Service | ? {$_.Status -eq "Running"} | select -First 2 |fl
```

Service statuses can appear as __Running, Stopped, or Paused,__ and they can be set to start manually, automatically, or on a delay at system boot. 
Services can also be shown in the state of __Starting or Stopping__ if some action has triggered them to either start or stop. 

Windows has three categories of services: __Local Services, Network Services, and System Services.__
 Services can usually only be created, modified, and deleted by users with administrative privileges.
 
 In Windows, we have some critical system services that cannot be stopped and restarted without a system restart. If we update any file or resource in use by one of these services, we must restart the system.
 
 ![critical_system_services](https://user-images.githubusercontent.com/99975622/212779910-428b2217-8e01-4fcd-a6b2-1879b1d566b9.png)
 
 We can find info on other services here:
 ```
 https://en.wikipedia.org/wiki/List_of_Microsoft_Windows_components#Services
 ```
 
#### Processes
Processes associated with installed applications can often be terminated without causing a severe impact on the operating system. Certain processes are critical and, if terminated, will stop certain components of the operating system from running properly. Some examples include the Windows Logon Application, System, System Idle Process, Windows Start-Up Application, Client Server Runtime, Windows Session Manager, Service Host, and Local Security Authority Subsystem Service (LSASS) process.

#### Local Security Authority Subsystem Service (LSASS)
__lsass.exe__ is the process that is responsible for enforcing the security policy on Windows systems.
When a user attempts to log on to the system, this process verifies their log on attempt and creates access tokens based on the user's permission levels.
#### Sysinternals Tools
This is a set of portable Windows applications that can be used to administer Windows systems (for the most part without requiring installation). 
The suite includes tools such as Process Explorer, an enhanced version of Task Manager, and Process Monitor, which can be used to monitor file system, registry, and network activity related to any process running on the system. Some additional tools are TCPView, which is used to monitor internet activity, and PSExec, which can be used to manage/connect to systems via the SMB protocol remotely.
These tools can be useful for penetration testers to, for example, discover interesting processes and possible privilege escalation paths as well as for lateral movement.

#### Process Explorer
It is a part of the Sysinternals tool suite.
This tool can show which handles and DLL processes are loaded when a program runs.

Process Explorer shows a list of currently running processes, and from there, we can see what handles the process has selected in one view or the DLLs and memory-swapped files that have been loaded in another view.

The tool can also be used to analyze parent-child process relationships to see what child processes are spawned by an application and help troubleshoot any issues such as orphaned processed that can be left behind when a process is terminated.

#### Service Permissions
The first step in realizing the importance of service permissions is simply understanding that they exist and being mindful of them. On server operating systems, critical network services like DHCP and Active Directory Domain Services commonly get installed using the account assigned to the admin performing the install. Part of the install process includes assigning a specific service to run using the credentials and privileges of a designated user, which by default is set within the currently logged-on user context.

For example, if we are logged on as Bob on a server during DHCP install, then that service will be configured to run as Bob unless specified otherwise. What bad things could come of this? Well, what if Bob leaves the organization or gets fired? The typical business practice would be to disable Bob’s account as part of his exit process. In this case, what would happen to DHCP and other services running using Bob’s account? Those services would fail to start. DHCP or Dynamic Host Configuration Protocol is responsible for leasing IP addresses to computers on the network. If this service stops on a Windows DHCP server, clients requesting an IP address will not receive one. This means a service misconfiguration could lead to downtime and loss of productivity. It is highly recommended to create an individual user account to run critical network services. These are referred to as service accounts.

Most services run with LocalSystem privileges by default which is the highest level of access allowed on an individual Windows OS. Not all applications need Local System account-level permissions, so it is beneficial to perform research on a case-by-case basis when considering installing new applications in a Windows environment. It is a good practice to identify applications that can run with the least privileges possible to align with the principle of least privilege.

Notable built-in service accounts in Windows:

- LocalService
- NetworkService
- LocalSystem

#### Examining services using sc
Sc can also be used to configure and manage services. Let's experiment with a few commands.
```  
C:\Users\htb-student>sc qc wuauserv
[SC] QueryServiceConfig SUCCESS

SERVICE_NAME: wuauserv
        TYPE               : 20  WIN32_SHARE_PROCESS
        START_TYPE         : 3   DEMAND_START
        ERROR_CONTROL      : 1   NORMAL
        BINARY_PATH_NAME   : C:\WINDOWS\system32\svchost.exe -k netsvcs -p
        LOAD_ORDER_GROUP   :
        TAG                : 0
        DISPLAY_NAME       : Windows Update
        DEPENDENCIES       : rpcss
        SERVICE_START_NAME : LocalSystem
```
The sc qc command is used to query the service. This is where knowing the names of services can come in handy. If we wanted to query a service on a device over the network, we could specify the hostname or IP address immediately after sc.
```
C:\Users\htb-student>sc //hostname or ip of box query ServiceName
```
We can also use sc to start and stop services.

```  
C:\Users\htb-student> sc stop wuauserv
[SC] OpenService FAILED 5:
Access is denied.
```
Notice how we are denied access from performing this action without running it within an administrative context. If we run a command prompt with elevated privileges, we will be permitted to complete this action.

 we can examine service permissions using sc is through the sdshow command.
 ```
 C:\WINDOWS\system32> sc sdshow wuauserv

D:(A;;CCLCSWRPLORC;;;AU)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SY)S:(AU;FA;CCDCLCSWRPWPDTLOSDRCWDWO;;;WD)
 ```
This amalgamation of characters crunched together and delimited by opened and closed parentheses is in a format known as the Security Descriptor Definition Language (SDDL).

We may be tempted to read from left to right because that is how the English language is typically written, but it can be much different when interacting with computers. Read the entire security descriptor for the Windows Update (wuauserv) service in this order starting with the first letter and set of parentheses:

As we read the security descriptor, it can be easy to get lost in the seemingly random order of characters, but recall that we are essentially viewing access control entries in an access control list. Each set of 2 characters in between the semi-colons represents actions allowed to be performed by a specific user or group.

;;CCLCSWRPLORC;;;

After the last set of semi-colons, the characters specify the security principal (User and/or Group) that is permitted to perform those actions.

;;;AU

The character immediately after the opening parentheses and before the first set of semi-colons defines whether the actions are Allowed or Denied.

A;;

This entire security descriptor associated with the Windows Update (wuauserv) service has three sets of access control entries because there are three different security principals. Each security principal has specific permissions applied.

![image](https://user-images.githubusercontent.com/99975622/212783402-2915d1d0-78a7-490f-bd93-8a751b68504f.png)
 The crazy output is a security decryptors
 Security descriptors identify the object’s owner and a primary group containing a Discretionary Access Control List (DACL) and a System Access Control List (SACL).
 
 Generally, a DACL is used for controlling access to an object, and a SACL is used to account for and log access attempts. This section will examine the DACL, but the same concepts would apply to a SACL.
 
#### Windows Sessions 
##### Interactive sessions
 This is where you login physically on to the machine, remotely, or when your creds are entered in a runaas command....
##### Non Interactive Sessions
 Non-interactive accounts in Windows differ from standard user accounts as they do not require login credentials. There are 3 types of non-interactive accounts: the Local System Account, Local Service Account, and the Network Service Account. Non-interactive accounts are generally used by the Windows operating system to automatically start services and applications without requiring user interaction. These accounts have no password associated with them and are usually used to start services when the system boots or to run scheduled tasks.
 
 ![image](https://user-images.githubusercontent.com/99975622/212784402-b70db4a6-ecd6-4b8b-aea7-58b16a89de59.png)
 
### Interacting with windows
 
#### CMD
```
https://download.microsoft.com/download/5/8/9/58911986-D4AD-4695-BF63-F734CD4DF8F2/ws-commands.pdf
```
Note that certain commands have their own help menus, which can be accessed by typing <command> /?. 
#### Powershell
PowerShell utilizes cmdlets, which are small single-function tools built into the shell. There are more than 100 core cmdlets, and many additional ones have been written, or we can author our own to perform more complex tasks. PowerShell also supports both simple and complex scripts used for system administration tasks, automation, and more.

Cmdlets are in the form of Verb-Noun. For example, the command Get-ChildItem can be used to list our current directory. Cmdlets also take arguments or flags. We can type Get-ChildItem - and hit the tab key to iterate through the arguments. A command such as Get-ChildItem -Recurse will show us the contents of our current working directory and all subdirectories. Another example would be Get-ChildItem -Path C:\Users\Administrator\Documents to get the contents of another directory. Finally, we can combine arguments such as this to list all subdirectories' contents within another directory recursively: Get-ChildItem -Path C:\Users\Administrator\Downloads -Recurse.

#### Aliases
Many cmdlets in PowerShell also have aliases. For example, the aliases for the cmdlet Set-Location, to change directories, is either cd or sl. Meanwhile, the aliases for Get-ChildItem are ls and gci. We can view all available aliases by typing Get-Alias.

We can also set up our own aliases with New-Alias and get the alias for any cmdlet with Get-Alias -Name.

```
New-Alias -Name "Show-Files" Get-ChildItem
```
### Execution Policy
![image](https://user-images.githubusercontent.com/99975622/212785916-d836af9b-6693-4bf2-8b14-d131f0f4b4f2.png)

The execution policy is not meant to be a security control that restricts user actions. A user can easily bypass the policy by either typing the script contents directly into the PowerShell window, downloading and invoking the script, or specifying the script as an encoded command.

```
Get-ExecutionPolicy -List
```
### Windows Management Instrumentation.(WMI)
WMI is a powershell subsystem.
It provides system administrators with powerful tools for system monitoring.
Some of the uses for WMI are:
- Status information for local/remote systems
- Configuring security settings on remote machines/applications
- Setting and changing user and group permissions
- Setting/modifying system properties
- Code execution
- Scheduling processes
- Setting up logging

We can run WMI on the command prompt by typing __wmic__

To list information on the os;
```
 wmic os list brief
```
<a href="https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmic"> more on the wmic command</a>

We can also use the Invoke-WmiMethod module, which is used to call the methods of WMI objects. A simple example is renaming a file. We can see that the command completed properly because the ReturnValue is set to 0.

### Miscrosoft Management Console
The MMC can be used to group snap-ins, or administrative tools, to manage hardware, software, and network components within a Windows host. 
 We can also use MMC to create custom tools and distribute them to users. MMC works with the concept of snap-ins, allowing administrators to create a customized console with only the administrative tools needed to manage several services. These snap-ins can be added to manage both local and remote systems.
 To start MMC, on the start menu type __mmc__
 
 ![image](https://user-images.githubusercontent.com/99975622/213190176-d033e072-aa69-44a5-8f9f-02c14cea304a.png)
 
 From here, we can browse to File --> Add or Remove Snap-ins, and begin customizing our administrative console.
 
 ![image](https://user-images.githubusercontent.com/99975622/213190766-d747210b-eaee-4a5e-a3a4-c44e12e23ae9.png)
 
 As we begin adding snap-ins, we will be asked if we want to add the snap-in to manage just the local computer or if it will be used to manage another computer on the network.
 
 ![image](https://user-images.githubusercontent.com/99975622/213190891-c06e04bd-a94d-4081-a8dc-f7c7b25725c8.png)
 
Once we have finished adding snap-ins, they will appear on the left-hand side of MMC. From here, we can save the set of snap-ins as a .msc file, so they will all be loaded the next time we open MMC. By default, they are saved in the Windows Administrative Tools directory under the Start menu. Next time we open MMC, we can choose to load any of the views that we have created.

![image](https://user-images.githubusercontent.com/99975622/213191097-c5122ecd-616e-45ff-b084-07236c06ed6c.png)

### Windows Security
#### Security Identifier (SID)
Each of the security principals on the system has a unique security identifier (SID). The system automatically generates SIDs. This means that even if, for example, we have two identical users on the system, Windows can distinguish the two and their rights based on their SIDs. SIDs are string values with different lengths, which are stored in the security database. These SIDs are added to the user's access token to identify all actions that the user is authorized to take.

A SID consists of the Identifier Authority and the Relative ID (RID). In an Active Directory (AD) domain environment, the SID also includes the domain SID.

To see your SID;
```
PS C:\htb> whoami /user

USER INFORMATION
----------------

User Name           SID
=================== =============================================
ws01\bob S-1-5-21-674899381-4069889467-2080702030-1002
```
The SID is broken down into this pattern.
```
(SID)-(revision level)-(identifier-authority)-(subauthority1)-(subauthority2)-(etc)
```

![image](https://user-images.githubusercontent.com/99975622/213196577-1d3fd737-9775-436d-a0f0-9aeb20c18f52.png)

To see the SID of other users;
```
Get-LocalUser -name "Username" | select Name,SID 
```
### Security Accounts Manager (SAM) and Access Control Entries (ACE)
SAM grants rights to a network to execute specific processes.

The access rights themselves are managed by Access Control Entries (ACE) in Access Control Lists (ACL). The ACLs contain ACEs that define which users, groups, or processes have access to a file or to execute a process, for example.

The permissions to access a securable object are given by the security descriptor, classified into two types of ACLs: the Discretionary Access Control List (DACL) or System Access Control List (SACL). Every thread and process started or initiated by a user goes through an authorization process. An integral part of this process is access tokens, validated by the Local Security Authority (LSA). In addition to the SID, these access tokens contain other security-relevant information. Understanding these functionalities is an essential part of learning how to use and work around these security mechanisms during the privilege escalation phase.

### User Account Control (UAC)
User Account Control (UAC) is a security feature in Windows to prevent malware from running or manipulating processes that could damage the computer or its contents. There is the Admin Approval Mode in UAC, which is designed to prevent unwanted software from being installed without the administrator's knowledge or to prevent system-wide changes from being made. Surely you have already seen the consent prompt if you have installed a specific software, and your system has asked for confirmation if you want to have it installed. Since the installation requires administrator rights, a window pops up, asking you if you want to confirm the installation. With a standard user who has no rights for the installation, execution will be denied, or you will be asked for the administrator password. This consent prompt interrupts the execution of scripts or binaries that malware or attackers try to execute until the user enters the password or confirms execution. To understand how UAC works, we need to know how it is structured and how it works, and what triggers the consent prompt. The following diagram, adapted from the <a href= "https://docs.microsoft.com/en-us/windows/security/identity-protection/user-account-control/how-user-account-control-works">source here</a>, illustrates how UAC works.

![image](https://user-images.githubusercontent.com/99975622/213197868-3bfb6c37-0d74-4a15-96d0-c4e522a6f1ea.png)

### Registry
The Registry is a hierarchical database in Windows critical for the operating system. It stores low-level settings for the Windows operating system and applications that choose to use it. It is divided into computer-specific and user-specific data. We can open the Registry Editor by typing regedit from the command line or Windows search bar.

There are 11 different types of values that can be entered in a subkey.

![image](https://user-images.githubusercontent.com/99975622/213198195-27a0b58d-2056-47b2-a260-4e0115aac6eb.png)

Each folder under Computer is a key. The root keys all start with HKEY. A key such as HKEY-LOCAL-MACHINE is abbreviated to HKLM. HKLM contains all settings that are relevant to the local system. This root key contains six subkeys like SAM, SECURITY, SYSTEM, SOFTWARE, HARDWARE, and BCD, loaded into memory at boot time (except HARDWARE which is dynamically loaded).

The entire system registry is stored in several files on the operating system. You can find these under C:\Windows\System32\Config\.

The user-specific registry hive (HKCU) is stored in the user folder (i.e., C:\Windows\Users\<USERNAME>\Ntuser.dat).

```
PS C:\htb> gci -Hidden

    Directory: C:\Users\bob

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d--h--         6/25/2020   5:12 PM                AppData
d--hsl         6/25/2020   5:12 PM                Application Data
d--hsl         6/25/2020   5:12 PM                Cookies
d--hsl         6/25/2020   5:12 PM                Local Settings
d--h--         6/25/2020   5:12 PM                MicrosoftEdgeBackups
d--hsl         6/25/2020   5:12 PM                My Documents
d--hsl         6/25/2020   5:12 PM                NetHood
d--hsl         6/25/2020   5:12 PM                PrintHood
d--hsl         6/25/2020   5:12 PM                Recent
d--hsl         6/25/2020   5:12 PM                SendTo
d--hsl         6/25/2020   5:12 PM                Start Menu
d--hsl         6/25/2020   5:12 PM                Templates
-a-h--         8/13/2020   6:01 PM        2883584 NTUSER.DAT
-a-hs-         6/25/2020   5:12 PM         524288 ntuser.dat.LOG1
-a-hs-         6/25/2020   5:12 PM        1011712 ntuser.dat.LOG2
-a-hs-         8/17/2020   5:46 PM        1048576 NTUSER.DAT{53b39e87-18c4-11ea-a811-000d3aa4692b}.TxR.0.regtrans-ms
-a-hs-         8/17/2020  12:13 PM        1048576 NTUSER.DAT{53b39e87-18c4-11ea-a811-000d3aa4692b}.TxR.1.regtrans-ms
-a-hs-         8/17/2020  12:13 PM        1048576 NTUSER.DAT{53b39e87-18c4-11ea-a811-000d3aa4692b}.TxR.2.regtrans-ms
-a-hs-         8/17/2020   5:46 PM          65536 NTUSER.DAT{53b39e87-18c4-11ea-a811-000d3aa4692b}.TxR.blf
-a-hs-         6/25/2020   5:15 PM          65536 NTUSER.DAT{53b39e88-18c4-11ea-a811-000d3aa4692b}.TM.blf
-a-hs-         6/25/2020   5:12 PM         524288 NTUSER.DAT{53b39e88-18c4-11ea-a811-000d3aa4692b}.TMContainer000000000
                                                  00000000001.regtrans-ms
-a-hs-         6/25/2020   5:12 PM         524288 NTUSER.DAT{53b39e88-18c4-11ea-a811-000d3aa4692b}.TMContainer000000000
                                                  00000000002.regtrans-ms
---hs-         6/25/2020   5:12 PM             20 ntuser.ini
```

### Run and RunOnce Registry Keys
There are also so-called registry hives, which contain a logical group of keys, subkeys, and values to support software and files loaded into memory when the operating system is started or a user logs in. These hives are useful for maintaining access to the system. These are called Run and RunOnce registry keys.

The Windows registry includes the following four keys:

 ``` 
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce
```
Here is an example of the HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run key while logged in to a system.
  
```
PS C:\htb> reg query HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run

HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run
    SecurityHealth    REG_EXPAND_SZ    %windir%\system32\SecurityHealthSystray.exe
    RTHDVCPL    REG_SZ    "C:\Program Files\Realtek\Audio\HDA\RtkNGUI64.exe" -s
    Greenshot    REG_SZ    C:\Program Files\Greenshot\Greenshot.exe
```
Here is an example of the HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run showing applications running under the current user while logged in to a system.

```  
PS C:\htb> reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run

HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
    OneDrive    REG_SZ    "C:\Users\bob\AppData\Local\Microsoft\OneDrive\OneDrive.exe" /background
    OPENVPN-GUI    REG_SZ    C:\Program Files\OpenVPN\bin\openvpn-gui.exe
    Docker Desktop    REG_SZ    C:\Program Files\Docker\Docker\Docker Desktop.exe
```

### Local Group Policy
Group Policy allows administrators to set, configure, and adjust a variety of settings. In a domain environment, group policies are pushed down from a Domain Controller onto all domain-joined machines that Group Policy objects (GPOs) are linked to. These settings can also be defined on individual machines using Local Group Policy.

Group Policy can be configured locally, in both domain environments and non-domain environments. Local Group Policy can be used to tweak certain graphical and network settings that are otherwise not accessible via the Control Panel. It can also be used to lock down an individual computer policy with stringent security settings, such as only allowing certain programs to be installed/run or enforcing strict user account password requirements.

We can open the Local Group Policy Editor by opening the Start menu and typing gpedit.msc. The editor is split into two categories under Local Computer Policy - Computer Configuration and User Configuration.

![image](https://user-images.githubusercontent.com/99975622/213200534-327191f5-dbfa-4986-9dc9-0707a9f57992.png)

For example, we can open the Local Computer Policy to enable Credential Guard by enabling the setting Turn On Virtualization Based Security. Credential Guard is a feature in Windows 10 that protects against credential theft attacks by isolating the operating system's LSA process.

![image](https://user-images.githubusercontent.com/99975622/213200709-3e64143f-818c-4e27-964e-217d7f0ea27a.png)
We can also enable fine-tuned account auditing and configure AppLocker from the Local Group Policy Editor. It is worth exploring Local Group Policy and learning about the wide variety of ways it can be used to lock down a Windows system.


### Socials
@instagram:https://instagram.com/Metric_r00t
<br> Twitter:https://twitter.com/M3tr1c_root
