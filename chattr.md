‘chattr’ Commands to Make Important Files IMMUTABLE (Unchangeable) in Linux

chattr (Change Attribute) is a command line Linux utility that is used to set/unset certain attributes to a file in Linux system to secure 
accidental deletion or modification of important files and folders, even though you are logged in as a root user.

# chattr [operator] [flags] [filename]
Attributes and Flags

Following are the list of common attributes and associated flags can be set/unset using the chattr command.

    If a file is accessed with ‘A‘ attribute set, its atime record is not updated.
    If a file is modified with ‘S‘ attribute set, the changes are updates synchronously on the disk.
    A file is set with ‘a‘ attribute, can only be open in append mode for writing.
    A file is set with ‘i‘ attribute, cannot be modified (immutable). Means no renaming, no symbolic link creation, no execution, no writable, only superuser can unset the attribute.
    A file with the ‘j‘ attribute is set, all of its information updated to the ext3 journal before being updated to the file itself.
    A file is set with ‘t‘ attribute, no tail-merging.
    A file with the attribute ‘d‘, will no more candidate for backup when the dump process is run.
    When a file has ‘u‘ attribute is deleted, its data are saved. This enables the user to ask for its undeletion.

Operator

    + : Adds the attribute to the existing attribute of the files.
    – : Removes the attribute to the existing attribute of the files.
    = : Keep the existing attributes that the files have.

[root@tecmint tecmint]# chattr +i demo/
[root@tecmint tecmint]# chattr +i important_file.conf
[root@tecmint tecmint]# lsattr
----i----------- ./demo
----i----------- ./important_file.conf
[root@tecmint tecmint]# rm -rf demo/
rm: cannot remove âdemo/â: Operation not permitted

[root@tecmint tecmint]# chattr -i demo/ important_file.conf


Setting immutable attribute on files /etc/passwd or /etc/shadow, 
makes them secure from an accidental removal or tamper and also it will disable user account creation.
[root@tecmint tecmint]# chattr +i /etc/passwd
[root@tecmint tecmint]# chattr +i /etc/shadow
[root@tecmint tecmint]# useradd tecmint
useradd: cannot open /etc/passwd


How to Secure Directories
[root@tecmint tecmint]# chattr -R +i myfolder
[root@tecmint tecmint]# chattr -R -i myfolder