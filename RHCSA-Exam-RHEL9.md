Setup an ip address for node1 virtual machine
hostname: nodea.lab.example.com
Password: redhat
IP: 172.25.250.10/24
GW: 172.25.250.254
DNS: 172.25.250.254
NB: All partition should be created on /dev/vdb

----Password Break and Network COnnectivity------------

A-Passwd:
*Rebuild for unforseen scenarion
Cosole Open -> Then Reboot ->
option-1
esc-> e-> rd.break console=tty1 rw -> ctrl+x -> chroot /sysroot/ -> passwd -> cat /etc/selinux/config (if enforce then autorelabel) 
-> touch /.autorelabel -> exit ->exit

option-2
esc-> e-> console=tty1 init=/bin/bash or (rw console=tty1 init=/bin/bash )-> ctrl+x -> mount -o remount.rw/ or ()-> passwd 
-> cat /etc/selinux/config (if enforce then autorelabel) -> touch /.autorelabel -> exit -> /usr/sbin/reboot -f

[root@localrnd ~]# ifconfig
[root@localrnd ~]# nmcli connection add con-name LAN2 type ethernet autoconnect yes ipv4.method static ipv4.addresses 172.25.250.10/24 ipv4.dns 172.25.250.254 ipv4.gateway 172.25.250.254  ifname ens33

Option-1	
	nmcli connection modify con-name LAN2 type ethernet autoconnect yes ipv4.method static ipv4.addresses 172.25.250.10/24 ipv4.dns 172.25.250.254 ipv4.gateway 172.25.250.254  ifname ens33
	nmcli connection LAN2 down; nmcli connection LAN2 up
	

--Change Hostname-----------
	[root@baika ~]# hostnamectl set-hostname baika.local.domain
	ping FQDN 

if not possible to modified the resolve.conf
	[root@localrnd ~]# chattr -i  /etc/resolv.conf
	[root@localrnd ~]# lsattr /etc/resolv.conf
	[root@localrnd ~]# chattr +i /etc/resolv.conf
=======================================================


A-01: SElinux Must be Running in Enable. 

	[root@localrnd ]# getenforce
	Enforcing
	[root@localrnd ]# vim /etc/selinux/config
Need reboot for successful executions.


A-02: Yum repository configuration on node1 machine:
	◾Packages are available at: url1= http://content.example.com/rhel8.0/x86_64/dvd/AppStream/ 
	◾Packages are available at: url2= http://content.example.com/rhel8.0/x86_64/dvd/BaseOS/

	[root@localrnd ]# vim /etc/yum.repos.d/AppStream-BaseOS.repo
		[AppStream_repo]
		name= App Stream Repo
		basurl=http://content.example.com/rhel8.0/x86_64/dvd/AppStream/
		gpgcheck=0
		enabled=1

**[root@baika yum.repos.d]# vim /etc/yum/pluginconf.d/subscription-manager.conf
**[root@baika yum.repos.d]# vim /etc/dnf/pluginconf.d/subscription-manager.conf
Need to change 1 to 0 to withdraw the default repo of RH.
	
A-03: Configure a cron job on Primary machine:   
	[root@localrnd ~]# yum whatprovides crond
		Last metadata expiration check: 1:53:46 ago on Tue 23 Aug 2022 03:57:12
		cronie-1.5.7-5.el9.x86_64 : Cron daemon for executing programs at set t
	[root@localrnd ~]# yum install cronie
	[root@localrnd ~]# systemctl enable crond
	[root@localrnd ~]# systemctl restart crond

◾a. The user natasha must configure a cron job that runs daily at 14:23 local time & executes /bin/echo "hi alex"
	
	[root@localrnd ~]# useradd natasha
	[root@localrnd ~]# crontab -eu natasha
				23 14 * * * /bin/echo "hi alex"


◾b. The user harry must configure a cron job that runs daily at every 3 minute local time & executes /bin/echo I got RHCE certificate. 
	
	[root@localrnd ~]# useradd harry	
	[root@localrnd ~]# crontab -eu harry
				*/3 * * * * bin/echo "I got RHCE certificate"
		# cd /var/spool/cron/					*/20
		# cat natasha harry		
[root@baika ~]# tail -f /var/log/cron
		
A-04: Debug Selinux: Fixed the HTTP service, the page isn't provived nodea machine by this link=http://172.25.250.10:82
SELinux must be running in the Enforcing mode.
	[root@localrnd ~]# rpm -qc httpd
	[root@localrnd ~]# vim /etc/httpd/conf/httpd.conf
	
	[root@localrnd ~]# systemctl restart httpd
we can also check by using setenforce 0, to confirm whether it is selinux issues or not. if then
	[root@localrnd ~]# semanage port -l | grep 82
	[root@localrnd ~]# man semanage port
	# semanage port -a -t http_port_t -p tcp 81
	[root@localrnd ~]# curl localhost:8233
Finally need to add firewall-cmd to get access from outside of the host.
	[root@localrnd ~]# firewall-cmd --permanent --add-port=8233/tcp
	[root@localrnd ~]# firewall-cmd --reload
Done.
-----------

Exam-A-04: Debug Selinux: Fixed the HTTP service, the page isn't provived nodea machine by this link=http://172.25.250.10:82
---------------
systemctl restart selinux
grep -i Listem /etc/httpd/conf/httpd
getenforce
setenforce
systemctl restart selinux
semanage port -l | grep http
man semanage port
semanage port -a -t http_port_t-p tcp 82
systemctl restart httpd

curl localhost:82/file1
firewall-cmd --permanent --add-port=82/tcp
firewall-cmd --reload

/var/www/html
ls -lZ
restoecon -Rv /var/www/html/
ls -lZ

// To change file context(it will be changed to default if anyone run restorcon)
[root@baika html]# chcon -t httpd_sys_content_t fil4
[root@baika html]# ls -lZ


Restore default context to the selinux context file
[root@baika html]# restorecon -Rv /var/www/html/file1


semanage fcontext -D /loation
used for changing default context of selinux
==============


A-05: Create the following users, groups, and group memberships:

- A group named sysadmin
	[root@localrnd ~]# groupadd sysadmin
	
- A user natasha who belongs to sysadmin as a secondary group.
- A user sarah who also belongs to sysadmin as a secondary group
	[root@localrnd ~]# useradd batasha -G dysadmin

- A user harry who does not have access to an interactive shell on the system & who is not a member of sysadmin.
	[root@localrnd ~]# useradd darry -s /sbin/nologin
	useradd --uid=1499 jata
	usermod --uid=1498 jata

- natasha, sarah & harry should all have the password of password. 
	[root@localrnd ~]# echo passwd | passwd --stdin darry

06: Create a collaborative directory "/common/admin" with the following characteristics:
- Group ownership of "/common/admin/" is sysadmin.
	[root@localrnd ~]# chgrp dysadmin /common/badmin/
	[root@localrnd ~]# getfacl /common/badmin/

- The directory should be readable, writable & accessible to members of sysadmin, but not to any other users. (It is understood that root has access to all files & directories on the system.)
- Files created in "/common/admin/" automatically have group ownership set to the sysadmin.

	[root@localrnd ~]# chmod 2770 /common/badmin/
	[root@localrnd ~]# ll -d /common/badmin/
	drwxrws---. 2 root dysadmin 6 Aug 24 16:10 /common/badmin/

07: Copy the file pwd" to "/var/tmp". Configure the permissions of "/var/tmp/passwd" so that:
- The file "/var/tmp/passwd" is owned by the root user.
- The file "/var/tmp/passwd" belong to the group root.
- The file "/var/tmp/passwd" should not be executable by anyone.

	[root@localrnd tmp]# cp /etc/passwd /var/tmp/

- The user harry is able to read and write "var/tmp/passwd". [ACL]
	[root@localrnd tmp]# setfacl -m u:harry:rw- passwd
	
- The user sarah can neither write nor read "/var/tmp/passwd". [Note that: all other users (current or future) have the ability to read "/var/tmp/passwd".]
	[root@localrnd tmp]# setfacl -m u:sarah:--- passwd

08: Syncronise your system time with the classroom.example.com. 

	[root@localrnd tmp]# yum whatprovides chrony (ISET)
	[root@baika tmp]# systemctl restart chronyd
  330  vim /etc/chrony.conf
  331  chronyc clients
  332  chronyc tracking
  334  chronyc sources -v

	

09. Configure AutoFS.
			All remote users home directory is exported via NFS, which is available on
			workstation.lab.example.com 172.25.250.9 and your NFS-exports directory is /home/guests for remote5.
		- Remote home directory is workstation.lab.example.com:/home/guests/remote5.
		- Remote home directory should be automount autofs service.
		- Home directories must be writable by their users.
		- while you are able to log in as remote5 user it's found home directory as /home/guests/remote5.
		- Ensure that remote5 user can read, write on his home directory but remote10 only can read privileges.

	 yum whatprovides autofs
	 yum install autofs
	 systemctl status autofs
	 systemctl enable autofs
	 systemctl restrat autofs
	[root@baika tmp]# rpm -qc autofs
	/etc/auto.master
	/etc/auto.misc
	# yum install autofs -y
	# systesmctl restart autofs
	# showmount -e workstation.lab.example.com
	# systesmctl enable autofs
	# vim /etc/auto.master

	/home/guests   /etc/auto.misc

	# vim/etc/auto.misc

	remote5         -rw,sync                workstation.lab.example.com:/home/guests/&
	remote10         -ro,sync                workstation.lab.example.com:/home/guests/&

	# systesmctl restart autofs


10: Create a backup.tar.(bz2 and gz) of /etc directory in /home location.
			# tar -cvjf /home/backup.tar.bz2 /etc
			# file /home/backup.tar.bz2
			# tar -cvzf /home/backup.tar.gz /etc
			# file /home/backup.tar.gz

11: Deny cronjob for user susan so that other user for this system are not effected for this cronjob.
	# vim /etc/cron.deny
	susan
	
12: Find all files owned by user brain and put them into /root/brain.

	#mkdir /root/brain 
	#find / -group
	#find / -user brain -exec cp -frvp {} /root/brain/ \;
	
	#find / -size +10M  -size -20M -perm 777 
	#find / -size +10M  -size -20M -perm 4000 

A- Script (newsearch)
Exam: create a shell script newsearch which will locate from /user  directory where file size will be morethan 20K and less than 50K. suid and output will store at /root/output. script will be in /usr/local/bin/
	/"-" first character matched only
#!/bin/bash
#find /usr/ -size +20K  -size -70K -perm -4000 > /root/output
	
#chmod +x /usr/local/bin/newsearch

Additional Info:
	// upto 4 special permission
	#find / -size +10M  -size -20M -perm /4000 
	chmod u+s file3
	suid 4 --> sgi bit 2--> sticky 1
	
13: Download a file word.dict from http://content.example.com & put it to "/root". Copy all the lines from /root/word.dict files that contains the word "mail" 
and put those lines in /root/sorted.dict
	# cd /root 	
	# wget http://classroom.example.com/content/word.dict
	or	
	# wget -O /root/word.dict http://classroom.example.com/content/word.dict
	# grep mail word.dict > /root/sorted.dict
  		


Setup an ip address for node2 virtual machine:
hostname: node2.lab.example.com 
Password: TombigSmall 
IP: 172.25.250.11/24 
GW: 172.25.250.254 
DNS: 172.25.250.254

B-00: First crack password of node2 Machine & set it to the instruction is above instructions:
B-01: SElinux Must be Running in Enable. 
02: Yum repository configuration on node1 machine:
	◾Packages are available at: url1= http://content.example.com/rhel8.0/x86_64/dvd/AppStream/ 
	◾Packages are available at: url2= http://content.example.com/rhel8.0/x86_64/dvd/BaseOS/
03: Set a recommended tuning profile for your system. (profile already available).
	# rpm -qa tuned		to check package is installed or not.	
	# yum install tuned -y
	# systemctl restart tuned.service
	# systemctl enable tuned.service
	# tuned-adm active [to see the active profile]
	# tuned-adm list [check how many profiles are available]
	# tuned-adm recommend [check which profile recommend to your system]
	# tuned-adm profile virtual-guest [set the profile]
	
04: Create a SWAP partition of 250 megabyte & make available at next reboot.
	# fdisk /dev/vdb
		Hex code (type L to list all codes): 82
		Changed type of partition 'Linux' to 'Linux swap / Solaris'.
	# lsblk
	# fdisk -l		
	# mkswap /dev/vdb1
	# blkid
		/dev/vdb1: UUID="b2337e16-691e-4a2a-92d1-35d5c1be3f18" TYPE="swap" PARTUUID="d8f3c21a-01"
	# vim /et	
				UUID="b2337e16-691e-4a2a-92d1-35d5c1be3f18"     swap    swap    defaults        0       0
	# swapon -av
		verification: # swapon -s	# free -h

		
05: Create the volume group with name myvolume with 8MiB P.E. and create the lvm name
    mydatabase with the 100P.E. format this lvm with ext4 and create a directory /database & mount this lvm permanently on /database.

gpt partition practice
	# fdisk /dev/vdb
		Command (m for help): g
		Created a new GPT disklabel (GUID: 086E1947-A456-E846-B266-070F53381589).

		  Create a new label
		   g   create a new empty GPT partition table
		   G   create a new empty SGI (IRIX) partition table
		   o   create a new empty DOS partition table
		   s   create a new empty Sun partition table


		Command (m for help): g
		Created a new GPT disklabel (GUID: 086E1947-A456-E846-B266-070F53381589).
		The device contains 'swap' signature and it will be removed by a write command. See fdisk(8) man page and --wipe option for more details.

		Command (m for help): n
		Partition number (1-128, default 1): 1
		First sector (2048-204766, default 2048):
		Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-204766, default 204766): +200M
		Value out of range.
		Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-204766, default 204766): +50M

		Created a new partition 1 of type 'Linux filesystem' and of size 50 MiB.

		Command (m for help): t
		Selected partition 1
		Partition type or alias (type L to list all): 30
		Changed type of partition 'Linux filesystem' to 'Linux LVM'.

		Command (m for help): p
		Disk /dev/sdb2: 100 MiB, 104857600 bytes, 204800 sectors
		Units: sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 512 bytes / 512 bytes
		Disklabel type: gpt
		Disk identifier: 086E1947-A456-E846-B266-070F53381589

		Device      Start    End Sectors Size Type
		/dev/sdb2p1  2048 104447  102400  50M Linux LVM

	
	
	# fdisk /dev/vdb
		Last sector, +sectors or +size{K,M,G,T,P} (514048-10485759, default 10485759): +850M
		Hex code (type L to list all codes): 8e
		Changed type of partition 'Linux' to 'Linux LVM'.
	# lsblk
	# fdisk -l
	# pvcreate /dev/vdb2
		 Physical volume "/dev/vdb2" successfully created.
	# pvdisplay	or, # pvs
	# vgcreate myvolume -s 8M /dev/vdb2
		Volume group "myvolume" successfully created
	# vgdisplay	or, # vgs
	# lvcreate -n mydatabase -l 100 myvolume
	# lvdisplay	or, lvs
	# mkfs.ext4 /dev/myvolume/mydatabase		or, # mkfs.ext4 /dev/mapper/myvolume-mydatabase
	# blkid
		/dev/mapper/myvolume-mydatabase: UUID="a747660c-8d14-4943-a227-a1320a31e943" TYPE="ext4"
	# vim /etc/fstab +
				UUID="a747660c-8d14-4943-a227-a1320a31e943"     /database       ext4    defaults        0       0
	# mkdir /database
	# mount -av

06: Extend or Resize the LVM partition /dev/myvolume/mydatabase into 500 MiB from the current size and mount the
			 LVM /dev/myvolume/mydatabase to a mount point /database.
			 The extended partition size must be within approximately 450MiB to 550MiB.
	# lvresize -r -L 500M /dev/myvolume/mydatabase
	# df -HT
	
07: You have been provided with a disk drive attached to your system /dev/vdX.  Make use of it to create a VDO. VDO device name
			is myvdo1 with a logical size of 100GiB & format this vdo storage as xfs & create a mount point /vdostorage & mount it permanently. 
	ISET- VDO
	Man VDO

08. Configure the rhcsa application so that when run as "pandora" it shows below message "Labla lbal lahs ksbhs".
	#env
	#cd /usr/local/bin
	#ls
	#vim pandora
		#!/bin/bash
		echo "Labla lbal lahs ksbhs"

    #chmod +x pandora

09. Customize user environment:
			- Create a command called starton on your server.
			- It should able to execute the following command (ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,comm).
	

10. Configure your system so that; All the new users password will be valid of maximum 30 days. 
	But all the previous user will be default days.
[root@baika bin]# cat /etc/login.defs
			#PASS_MAX_DAYS   99999
			PASS_MAX_DAYS   30


----------------------
		11. Create a container logserver from an image rsyslog in nodeb From: registry.lab.example.com

		- Configure the container with systemd services by an existing user "Walhalla".
		- Service name should be container-logserver and configure it to start automatically across reboot.

		12.Configure your host journal to store all journal across reboot.
		- Copy all *.journal from /var/log/journal and all subdirectories to /home/Walhalla/container_logserver.
		- Configure automount /var/log/journal from logserver (container) to /home/walhalla/container_logserver. when container starts.



   
			
-------------------------------------------
file size allocation
#fallocate 1001.txt -l 5M


    Who - represents identities: u,g,o,a (user, group, other, all)
    What - represents actions: +, -, = (add, remove, set exact)
 Which - represents access levels: r, w, x (read, write, execute)
	[root@baika lvm-jewel]# which fallocate
		/usr/bin/fallocate
	[root@baika lvm-jewel]# which cat
		/usr/bin/cat


special bit:
https://linuxhint.com/special-permissions-suid-guid-sticky-bit/

selinux:
https://jfearn.fedorapeople.org/fdocs/en-US/Fedora/20/html/Security_Guide/sect-Security-Enhanced_Linux-SELinux_Contexts_Labeling_Files-Persistent_Changes_semanage_fcontext.html

JOurnalctl:
