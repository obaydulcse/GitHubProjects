yum check-update

Updating a Single Package:
yum update package_name
# yum update rpm

yum group update group_name
#yum update --security

Search
$ yum search vim gvim emacs

yum list all
yum list installed glob_expression&hellip;

yum repolist
yum repolist -v
yum repoinfo
yum repolist all

$ yumdb info yum
$ yum info abrt


#yum install package_name
# yum install httpd


To install a previously downloaded package from the local directory on your system, use the following command:
yum localinstall path

# yum remove totem


yum groups summary

yum history list all
yum history stats

yum history undo id

yum history new

#yum whatprovides package_name

Configuring Yum and Yum Repositories:
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

