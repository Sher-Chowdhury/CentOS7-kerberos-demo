#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '##### About to run setup-kerberos-client.sh script #############'
echo '##########################################################################'


yum install -y krb5-workstation pam_krb5

kadmin <<EOF
MySecretRootPassword
addprinc -randkey host/kerberos-client.codingbee.net 
ktadd host/kerberos-client.codingbee.net 
quit
EOF


cp /etc/ssh/ssh_config /etc/ssh/ssh_config-orig

sed -i 's/#   GSSAPIAuthentication no/    GSSAPIAuthentication yes/g' /etc/ssh/ssh_config
sed -i 's/#   GSSAPIDelegateCredentials no/    GSSAPIDelegateCredentials yes/g' /etc/ssh/ssh_config

sed -i 's/GSSAPIAuthentication no/GSSAPIAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

authconfig --enablekrb5  --update

useradd krbtest


# su - krbtest
# the following should fail, becuase it gives a password prompt:
# $ ssh kdc.codingbee.net
# the following should give a 'not found' error message:
# $ klist
# kinit    will get a password prompt, enter: 
# klist  # this is to check you have an active token
# then do:
# $ ssh kdc.codingbee.net
# you should be able to log in without a password prompt, or the need to first setup private+public ssh keys. 