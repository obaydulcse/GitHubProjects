1. Install and configure Ansible
install & config Ansible on the control node workstation.lab.example.com

* install the require packages
* create a static file called /home/student/ansible/inventory so that:

	servera.lab.example.com is a member of the dev host group

	serverb.lab.example.com is a member of the test host group

	serverc.lab.example.com and serverd.lab.example.com are members of the prod host group

	bastion.lab.example.com is a member of the balancers host group The

	prod group is Members of the webservers host group



* Create a configuration file calles /home/student/ansible/ansible.cfg


- The host inventory file is /home/student/ansible/inventory

- The location of role used in playbooks include /home/student/ansible/roles

#dpkg -l ansible
#ansible --version



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


2. Create and run Ansible ad-hoc commands

As a system administrator you will need install software on the managed nodes.

Create a shell script called /home/student/ansible/adhoc.sh the user ansible ad-hoc command to create a yum repository on each of the managed nodes as follows:


Repository 1:

	- The name of the repository is EX294_BASE

	- The description is EX294 base software

	- The base URL is http://content.example.com/rhel8.0/x86_64/dvd/BaseOS

	- GPG signature checking is enabled

	- The GPG Key URL is http://content.example.com/rhel8.0/x86_64/dvd/RPM-GPG-KEY-redhat-release

	- The repository is enabled


Repository 2:

	- The name of the repository is EX294_STREM

	- The description is EX294 stream software

	- The base URL is http://content.example.com/rhel8.0/x86_64/dvd/AppStream

	- GPG signature checking is enabled

	- The GPG Key URL is http://content.example.com/rhel8.0/x86_64/dvd/RPM-GPG-KEY-redhat-release
	
	- The repository is enabled


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



3. Install packages

Create a playbook called /home/student/ansible/packages.yml that:


	- Installs the php & mariadb on hosts in the dev,test and prod host group


	- Installs the "Development Tools" (build-essential in ubuntu) package group on host in the dev host group

	- Update all packages to the latest version on host in the dev host group


		apt list
   86  apt list --installed
   87  apt list -a mariadb
   88  apt list grep mariadb

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



4. Use a RHEL system role

Install the RHEL System role package on your control node & create a playbook called /home/student/ansible/timesync.yml that:

	- Runs on all managed nodes

	- Uses the timesync role

	- Configures the role to use the currently active NTP provider

	- Configure the role to use the time server 172.25.254.254

	- Configure the role to enable the iburst parameter



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



5. Install roles using Ansible Galaxy

use Ansible Galaxy with a requirements file called /home/student/ansible/roles/requirement.yml to download and install role to /home/student/ansible/roles from following URL:


* http://content.example.com/EX294_Ansible/Ansible_files/balancer.tar.gz

	The Name of the role should be balancer


* http://content.example.com/EX294_Ansible/Ansible_files/phpinfo.tar.gz

	The name of this role should be phpinfo	


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


6. Create & use a role

*Create a role called apache in /home/student/ansible/roles with the following requirement:


	- The httpd package is install, enabled on boot and started

	- The Firewall is enabled & running with a rule to allow access the web server

	- Create a template file called index.html.j2 which creates and serves a message from
	  /var/www/html/index.html with the following output:
		
		Welcome to HOSTNAME on IPADDRESS
	
	  where HOSTNAME is the fully qualified domain name of the managed node, and IPADDRESS
	  is the IP address of the managed node. Whenever the content of the file changes, restart the 
	  webserver service.
	

* create a playbook called /home/student/ansible/newrole.yml that uses this role as foloows:

	- The playbook runs on host in the webservers host group




>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


7. Use roles from Ansible Galaxy


Create a playbook called /home/student/ansible/roles.yml


* The palybook contains a play that runs on host in the balancers (in this lab test hosts) host group and uses the balancer role.

- This role configures a service to load balancer web server request between hosts in the webservers host group.

- Browsing to host in the balancers host group (in this lab test hosts) ( for example http://serverb.lab.example.com) produces the following output:

	Welcome to serverc.lab.example.com on 172.25.250.12


- Reloading the Browser produces output from the alternet web server:

	Welcome to serverd.lab.example.com on 172.25.250.13



* The Playbook contains a play the runs on hosts in webservers host group and user the phpinfo role.

- Browsing to host in the webservers host group with the URL /hello.php produces the following output :


	Hello PHP World from FQDN


- For example Browsing to http://serverb.lab.example.com/hello.php produces the following output:


	Hello PHP World from serverb.lab.example.com


along with various details of the PHP configuration include the version of PHP that is installed.


- Similarly, Browsing to http://serverc.lab.example.com/hello.php, produces the following output:


	Hello PHP World from serverc.lab.example.com


along with various details of the PHP configuration including the version of PHP that is installed.




>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


8. Create & use a logical Volume

Create a playbook called /home/student/ansible/lv.yml that runs on all managed nodes that does the following:



* Creates a logocal volume with these requirement:

	- The logical Volume is Created in the research volume group

	- The logical volume name is data

	- The logical volume size is 1500 Mib

	- Format the logical volume with the ext4 file system


* if the requested logical volume size cannot be created, the error message

	
	"Could not create logical volume of that size"

	should be displayed and size 800 MiB should be used instead.

* if the volume research does not exist, the error message

	
	"volume group does not exist" 
	
	should be displayed

* Does NOT mount the logical volume in any way.



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



9. Generate a host file


* Download an initial template file from http://content.example.com/EX294_Ansible/Ansible_files/host.j2 to /home/student/ansible/

* Complete the template so that it can be used to generate a file with a line for each host in the same format as /etc/hosts

* Create a playbook called /home/student/ansible/host.yml that uses this template to generate the file /etc/myhosts on hosts in the dev host group.

When the playbook is run, the file /etc/myhosts on host in the dev host group should have a line for each managed hosts:

	127.0.0.1 localhost localhost.localdoamin localhost4 localhost4.localdomain

	::1 localhost localhost.localdoamin localhost6 localhost6.localdomain


	172.25.254.10 servera.lab.example.com servera

	172.25.254.11 serverb.lab.example.com serverb

	172.25.254.12 serverc.lab.example.com serverc

	172.25.254.13 serverd.lab.example.com serverd

	172.25.250.254 bastion.lab.example.com bastion


Note: The order in which the inventory host names appear is not important.


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


10. Modify file content

Create a playbook called /home/student/ansible/issue.yml

* The playbook runs on all inventory hosts

* The playbook replaces the content of /etc/issue with a single line of text as follows:


	- On host is the dev host group, the line reads: Development

	- On hosts in the test host group, the line read: Test

	- On hosts in the prod hosts group, the line read: Production


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



11. Create a Web content directory


Create a playbook called /home/student/ansible/webcontent.yml as follows:

* The playbook runs managed node in the dev host group

* Create the directory /webdev with the following requirement:


	- it is owner by the webdev group

	- it has regular permissions: owner=read+write+execute,group=r+w+x,other=r+x

	- it has special permission: set group GID


* Symbolically link /var/www/html/webdev to /webdev

* Create the file /webdev/index.html with a single line of text that reads: Development


* Browsing this directory on host in the dev host group ( for example http://servera.lab.example.com/webdev/) produces the following output:

		Development


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



12. Generate a hardware report


Create a playbook called /home/student/ansible/hwreport.yml that produces an output file called /root/hwreport.txt on all managed nodes with the following information:


	- Inventory hostname

	- Total Memory

	- BIOS version

	- Size of disk device vda

	- Size of disk device vdb

	- Each line of the output file contains a single key=value pair.

* your playbook should:

- Download the file from http://content.example.com/EX294_Ansible/Ansible_files/hwreport.empty and save it is aas /root/hwreport.txt


	- Modify /root/hwreport.txt with the correct values

	- if a hardware item does not exist, the associated value should be set to NONE



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



13. Create a password vault


Create an ansible vault to store user pasword as follows:

* The name of the vault is /home/student/ansible/locker.yml

* The vault contains two variables with names:


	- PW_developer with value Imadev

	- PW_manager with value Imamgr


* The Password to encrypt and decrypt the vault is whenyouwishuponastar

* The password is stored in the file /home/student/ansible/secret.txt


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



14. Create user accounts


* Download a list of user to be created from http://content.example.com/EX294_Ansible/Ansible_files/user_list.yml

* Using the password vault /home/student/ansible/locker.yml create elsewhere in this exam, create a play book called /home/student/ansible/users.yml that create user account as following:



* User with job description of developer should be:

	- create on managed node in the dev and test host group

	- assigned the password from the PW_devloper variable

	- a member of supplementary group devops



* User with a job description of manager should be:

	- create on managed node in the prod host group

	- assigned the password from PW_manager variable

	- a member of supplementary group opsmgr


* password should use the SHA512 gas format

* Your playbook should work using the vault password file /home/student/ansible/secret.txt create elsewhere in this exam



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


15. ReKey an Ansible vault


Rekey an existing Ansible vault as follows:

- Download the Ansible vault from http://content.example.com/EX294_Ansible/Ansible_files/salaries.yml to /home/student/ansible/

- The current vault password is insecure4sure

- The new vault password is bbe2de98389b 

- The vault remains in an encrypted state with the new password




---------------------------QUESTIONS-ONLY-----------------------------------
1. Install and configure Ansible


install & config Ansible on the control node workstation.lab.example.com


* install the require packages


* create a static file called /home/student/ansible/inventory so that:


	servera.lab.example.com is a member of the dev host group

	serverb.lab.example.com is a member of the test host group

	serverc.lab.example.com and serverd.lab.example.com are members of the prod host group

	bastion.lab.example.com is a member of the balancers host group The

	prod group is Members of the webservers host group



* Create a configuration file calles /home/student/ansible/ansible.cfg


- The host inventory file is /home/student/ansible/inventory

- The location of role used in playbooks include /home/student/ansible/roles



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


2. Create and run Ansible ad-hoc commands

As a system administrator you will need install software on the managed nodes.

Create a shell script called /home/student/ansible/adhoc.sh the user ansible ad-hoc command to create a yum repository on each of the managed nodes as follows:


Repository 1:

	- The name of the repository is EX294_BASE

	- The description is EX294 base software

	- The base URL is http://content.example.com/rhel8.0/x86_64/dvd/BaseOS

	- GPG signature checking is enabled

	- The GPG Key URL is http://content.example.com/rhel8.0/x86_64/dvd/RPM-GPG-KEY-redhat-release

	- The repository is enabled


Repository 2:

	- The name of the repository is EX294_STREM

	- The description is EX294 stream software

	- The base URL is http://content.example.com/rhel8.0/x86_64/dvd/AppStream

	- GPG signature checking is enabled

	- The GPG Key URL is http://content.example.com/rhel8.0/x86_64/dvd/RPM-GPG-KEY-redhat-release
	
	- The repository is enabled


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



3. Install packages

Create a playbook called /home/student/ansible/packages.yml that:


	- Installs the php & mariadb on hosts in the dev,test and prod host group


	- Installs the "Development Tools" package group on host in the dev host group

	- Update all packages to the latest version on host in the dev host group



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



4. Use a RHEL system role

Install the RHEL System role package on your control node & create a playbook called /home/student/ansible/timesync.yml that:

	- Runs on all managed nodes

	- Uses the timesync role

	- Configures the role to use the currently active NTP provider

	- Configure the role to use the time server 172.25.254.254

	- Configure the role to enable the iburst parameter



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



5. Install roles using Ansible Galaxy

use Ansible Galaxy with a requirements file called /home/student/ansible/roles/requirement.yml to download and install role to /home/student/ansible/roles from following URL:


* http://content.example.com/EX294_Ansible/Ansible_files/balancer.tar.gz

	The Name of the role should be balancer


* http://content.example.com/EX294_Ansible/Ansible_files/phpinfo.tar.gz

	The name of this role should be phpinfo	


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


6. Create & use a role

*Create a role called apache in /home/student/ansible/roles with the following requirement:


	- The httpd package is install, enabled on boot and started

	- The Firewall is enabled & running with a rule to allow access the web server

	- Create a template file called index.html.j2 which creates and serves a message from
	  /var/www/html/index.html with the following output:
		
		Welcome to HOSTNAME on IPADDRESS
	
	  where HOSTNAME is the fully qualified domain name of the managed node, and IPADDRESS
	  is the IP address of the managed node. Whenever the content of the file changes, restart the 
	  webserver service.
	

* create a playbook called /home/student/ansible/newrole.yml that uses this role as foloows:

	- The playbook runs on host in the webservers host group




>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


7. Use roles from Ansible Galaxy


Create a playbook called /home/student/ansible/roles.yml


* The palybook contains a play that runs on host in the balancers (in this lab test hosts) host group and uses the balancer role.

- This role configures a service to load balancer web server request between hosts in the webservers host group.

- Browsing to host in the balancers host group (in this lab test hosts) ( for example http://serverb.lab.example.com) produces the following output:

	Welcome to serverc.lab.example.com on 172.25.250.12


- Reloading the Browser produces output from the alternet web server:

	Welcome to serverd.lab.example.com on 172.25.250.13



* The Playbook contains a play the runs on hosts in webservers host group and user the phpinfo role.

- Browsing to host in the webservers host group with the URL /hello.php produces the following output :


	Hello PHP World from FQDN


- For example Browsing to http://serverb.lab.example.com/hello.php produces the following output:


	Hello PHP World from serverb.lab.example.com


along with various details of the PHP configuration include the version of PHP that is installed.


- Similarly, Browsing to http://serverc.lab.example.com/hello.php, produces the following output:


	Hello PHP World from serverc.lab.example.com


along with various details of the PHP configuration including the version of PHP that is installed.




>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


8. Create & use a logical Volume

Create a playbook called /home/student/ansible/lv.yml that runs on all managed nodes that does the following:



* Creates a logocal volume with these requirement:

	- The logical Volume is Created in the research volume group

	- The logical volume name is data

	- The logical volume size is 1500 Mib

	- Format the logical volume with the ext4 file system


* if the requested logical volume size cannot be created, the error message

	
	"Could not create logical volume of that size"

	should be displayed and size 800 MiB should be used instead.

* if the volume research does not exist, the error message

	
	"volume group does not exist" 
	
	should be displayed

* Does NOT mount the logical volume in any way.



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



9. Generate a host file


* Download an initial template file from http://content.example.com/EX294_Ansible/Ansible_files/host.j2 to /home/student/ansible/

* Complete the template so that it can be used to generate a file with a line for each host in the same format as /etc/hosts

* Create a playbook called /home/student/ansible/host.yml that uses this template to generate the file /etc/myhosts on hosts in the dev host group.

When the playbook is run, the file /etc/myhosts on host in the dev host group should have a line for each managed hosts:

	127.0.0.1 localhost localhost.localdoamin localhost4 localhost4.localdomain

	::1 localhost localhost.localdoamin localhost6 localhost6.localdomain


	172.25.254.10 servera.lab.example.com servera

	172.25.254.11 serverb.lab.example.com serverb

	172.25.254.12 serverc.lab.example.com serverc

	172.25.254.13 serverd.lab.example.com serverd

	172.25.250.254 bastion.lab.example.com bastion


Note: The order in which the inventory host names appear is not important.


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


10. Modify file content

Create a playbook called /home/student/ansible/issue.yml

* The playbook runs on all inventory hosts

* The playbook replaces the content of /etc/issue with a single line of text as follows:


	- On host is the dev host group, the line reads: Development

	- On hosts in the test host group, the line read: Test

	- On hosts in the prod hosts group, the line read: Production


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



11. Create a Web content directory


Create a playbook called /home/student/ansible/webcontent.yml as follows:

* The playbook runs managed node in the dev host group

* Create the directory /webdev with the following requirement:


	- it is owner by the webdev group

	- it has regular permissions: owner=read+write+execute,group=r+w+x,other=r+x

	- it has special permission: set group GID


* Symbolically link /var/www/html/webdev to /webdev

* Create the file /webdev/index.html with a single line of text that reads: Development


* Browsing this directory on host in the dev host group ( for example http://servera.lab.example.com/webdev/) produces the following output:

		Development


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



12. Generate a hardware report


Create a playbook called /home/student/ansible/hwreport.yml that produces an output file called /root/hwreport.txt on all managed nodes with the following information:


	- Inventory hostname

	- Total Memory

	- BIOS version

	- Size of disk device vda

	- Size of disk device vdb

	- Each line of the output file contains a single key=value pair.

* your playbook should:

- Download the file from http://content.example.com/EX294_Ansible/Ansible_files/hwreport.empty and save it is aas /root/hwreport.txt


	- Modify /root/hwreport.txt with the correct values

	- if a hardware item does not exist, the associated value should be set to NONE



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



13. Create a password vault


Create an ansible vault to store user pasword as follows:

* The name of the vault is /home/student/ansible/locker.yml

* The vault contains two variables with names:


	- PW_developer with value Imadev

	- PW_manager with value Imamgr


* The Password to encrypt and decrypt the vault is whenyouwishuponastar

* The password is stored in the file /home/student/ansible/secret.txt


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



14. Create user accounts


* Download a list of user to be created from http://content.example.com/EX294_Ansible/Ansible_files/user_list.yml

* Using the password vault /home/student/ansible/locker.yml create elsewhere in this exam, create a play book called /home/student/ansible/users.yml that create user account as following:



* User with job description of developer should be:

	- create on managed node in the dev and test host group

	- assigned the password from the PW_devloper variable

	- a member of supplementary group devops



* User with a job description of manager should be:

	- create on managed node in the prod host group

	- assigned the password from PW_manager variable

	- a member of supplementary group opsmgr


* password should use the SHA512 gas format

* Your playbook should work using the vault password file /home/student/ansible/secret.txt create elsewhere in this exam



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


15. ReKey an Ansible vault


Rekey an existing Ansible vault as follows:

- Download the Ansible vault from http://content.example.com/EX294_Ansible/Ansible_files/salaries.yml to /home/student/ansible/

- The current vault password is insecure4sure

- The new vault password is bbe2de98389b 

- The vault remains in an encrypted state with the new password
