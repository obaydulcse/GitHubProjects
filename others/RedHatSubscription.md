---------Redhat Subscription Manager-------------
create RHN in Redhat Portal.
#man subscription-manager
Register and automatically subscribe in one step:
# subscription-manager register --username <username> --password <password> --auto-attach
# subscription-manager list --available --all

Registration via GUI
# subscription-manager-gui


Un-registering a system
# subscription-manager remove --all
# subscription-manager unregister
# subscription-manager clean
