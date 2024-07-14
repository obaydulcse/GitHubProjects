------------- Ansible Install-------------------
https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-20-04

mongo0-user@mongo0:~$ sudo apt update
mongo0-user@mongo0:~$ sudo apt install ansible -y
mongo0-user@mongo0:~$ ansible --list-host all


Setting Up the Inventory File
#sudo vim  /etc/ansible/hosts

	[servers]
	server1 ansible_host=203.0.113.111
	server2 ansible_host=203.0.113.112
	server3 ansible_host=203.0.113.113



-------------Passwordless authentications for ANSIBLE---------------
obaydul@workstation:~/.ssh$ pwd
/home/obaydul/.ssh
//key generation in the controller node
#ssh-keygen -t rsa

#cat /home/obaydul/.ssh/id_rsa.pub

//before share the key need to create directory into the remote hosts
#ssh obaydul@serverb mkdir -p /home/obaydul/.ssh

//copy the public key to the managed hosts 
#cat /home/obaydul/.ssh/id_rsa.pub | ssh obaydul@servera 'cat >> .ssh/authorized_keys'


//Change the rights on the authorized_keys, this is important depending on the version of ssh server used.