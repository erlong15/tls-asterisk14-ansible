# tls-asterisk14-ansible

ansible role for installation asterisk-14 with TLS and SRTP and Mysql.
This role includes SSL keys creation for server and clients.
It includes client creation.
It doesn't include iptables configuration.

Example of run
```
ansible-playbook -i pbx.inv pbx.yml 
```
Where:
* pbx.inv - your inventory file


after installation you can find passwords in mysql db "asterisk":
```
 select * from ps_auths;
```

If you want another sip numbers fix /etc/asterisk/extensions.conf in line
```
[default]
exten = _11XX,1,Dial(PJSIP/${EXTEN})
```

You can use zoiper for testing. Don't forget enable SRTP and TLS in zoiper client.


