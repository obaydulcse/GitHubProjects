#user shell changes in ubuntu
chsh -s /bin/bash sandy


#sudo user check
root@mongo2:~# su - devops1
devops1@mongo2:/root$ sudo useradd test1
devops1@mongo2:/root$ sudo id test1
uid=1003(test1) gid=1003(test1) groups=1003(test1)
devops1@mongo2:/root$ sudo userdell test1
sudo: userdell: command not found
devops1@mongo2:/root$ sudo userdel test1

devops1@mongo2:/root$ sudo grep wheel /etc/sudoers
devops1@mongo2:/root$


# remotely command run other server using ssh
ssh root@serverb "bash /root/test.sh"