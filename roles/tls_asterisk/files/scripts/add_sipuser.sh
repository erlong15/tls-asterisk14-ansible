#!/bin/bash
sip=$1
mypass=$2
keypass=$3
server=$4
name=$5
echo $sip
if [ ! -f /etc/asterisk/keys/zoip$sip.crt ]
then
./ast_tls_cert  -m client -c /etc/asterisk/keys/ca.crt -k /etc/asterisk/keys/ca.key -C "$server" -O "$name" -d /etc/asterisk/keys -o zoip$sip -p $keypass
chown asterisk /etc/asterisk/keys/zoip$sip.*
pass=$RANDOM$RANDOM
sql="SET @user := $sip;
SET @pass := $pass;
SET @crt := '/etc/asterisk/keys/zoip$sip.crt';
SET @key := '/etc/asterisk/keys/zoip$sip.key';
insert into ps_aors (id, max_contacts) values (@user, 1);
insert into ps_auths (id, auth_type, password, username) values (@user, 'userpass',@pass, @user);
insert into ps_endpoints (id, transport, aors, auth, dtls_cert_file, dtls_private_key, disallow, allow, 
direct_media, rtp_symmetric, force_rport, rewrite_contact, dtmf_mode, media_encryption) 
values (@user, 'transport-tls', @user, @user,@crt,@key, 'all', 'alaw,ulaw,gsm,g722', 'no',
'yes', 'yes', 'yes', 'rfc4733', 'sdes');
"
echo $sql | mysql -p$mypass -D asterisk
echo $pass
fi

