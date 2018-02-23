#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '##### About to run setup-kdc-authentication-system.sh script #############'
echo '##########################################################################'


yum install -y krb5-server krb5-workstation pam_krb5


cp /var/kerberos/krb5kdc/kdc.conf /var/kerberos/krb5kdc/kdc.conf-orig




sed -i s/EXAMPLE.COM/CODINGBEE.NET/g /var/kerberos/krb5kdc/kdc.conf


# make it only kerberos5 compatible and not backward compatible. 
sed -i s/#master_key_type/master_key_type/g /var/kerberos/krb5kdc/kdc.conf
sed -i '/master_key_type/a \ \ default_principle_flags = +preauth' /var/kerberos/krb5kdc/kdc.conf # this inserts a line after a match
                                                                                                  # https://stackoverflow.com/questions/15559359/insert-line-after-first-match-using-sed


cp /etc/krb5.conf /etc/krb5.conf-orig
# the following replaces a whole line based on a partial match
# https://stackoverflow.com/questions/11245144/replace-whole-line-containing-a-string-using-sed
sed -i '/default_realm/c\ default_realm = CODINGBEE.NET' /etc/krb5.conf


sed -i 's/# EXAMPLE.COM/  CODINGBEE.NET/g' /etc/krb5.conf

sed -i 's/#  kdc = kerberos.example.com/   kdc = kdc.codingbee.net/g' /etc/krb5.conf
sed -i 's/#  admin_server = kerberos.example.com/   admin_server = kdc.codingbee.net/g' /etc/krb5.conf
sed -i 's/# }/}/g' /etc/krb5.conf     # this should edit the line that's right after the admin_server line. 

sed -i 's/# .example.com = EXAMPLE.COM/ .codingbee.net = CODINGBEE.NET/g' /etc/krb5.conf
sed -i 's/# example.com = EXAMPLE.COM/ codingbee.net = CODINGBEE.NET/g' /etc/krb5.conf

cp /var/kerberos/krb5kdc/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl-orig

sed -i 's/EXAMPLE.COM/CODINGBEE.NET/g' /var/kerberos/krb5kdc/kadm5.acl

# this is the create the kerberos database. It can take several minutes to finish. 
kdb5_util create -s -r CODINGBEE.NET << EOF
MySecretPassword
MySecretPassword
EOF

systemctl enable krb5kdc
systemctl enable kadmin

systemctl start krb5kdc
systemctl start kadmin