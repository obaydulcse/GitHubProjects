----------------Key base Authentication-------------
1. Generate key pair
puttygen- From windows
ssh-key-gen-- from linux

2. copy public to server (path depends on sshd_config file)
#vim /etc/ssh/sshd_config
shift : set nu
60 AuthorizedKeysFile	.ssh/authorized_key 	//users home directory/.ssh/authorized_key

#cd /home/.ssh/authorized_key 

#ssh-keygen --> /root/.ssh/id_rsa -->
#ssh-copy-id root@servera

#grep -i password /etc/ssh/sshd_config		//**************

#vi /etc/ssh/sshd_config

id-rsa is private key normally found in user home directory .ssh/authorized_key***********

#ssh -i id_akdum root@servera

3. Login to ssh server using private key

======================================================