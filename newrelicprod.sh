#!/bin/bash
#
# prupose:To install/uninstall new relic server agent on Locus-IR: ir1/ir2/ir3 VMs
# usage:
# 1. login to server
# 2. bash <(wget -qO - https://raw.githubusercontent.com/jason75023/newrelic-server/master/newrelicprod.sh)
# To install new relic server agent: 1, 5, 6
# To uninstall new relic server agent: 3, 2, 5, 6
# select 6 to exit program
#

install() {
rpm -Uvh http://download.newrelic.com/pub/newrelic/el5/i386/newrelic-repo-5-3.noarch.rpm
echo "*** check new relic repository is added ***"
yum repolist| grep newrelic
yum -y install newrelic-sysmond
/usr/sbin/nrsysmond-config --set license_key=1385436c45c570cb5e1ec46664b06adb03748bde
echo "*** check license_key is added to new relic config file ***"
grep license_key= /etc/newrelic/nrsysmond.cfg
/etc/init.d/newrelic-sysmond start
echo "*** check new relic processes are running ***"
ps -fu newrelic

return
}

uninstall() {

yum remove newrelic-sysmond

return
}

startnewrelic() {

service newrelic-sysmond start 

return
}

stopnewrelic() {

service newrelic-sysmond stop 

return
}

checknewrelic() {

service newrelic-sysmond status

return
}


#
# MAIN program
#
IFS='
'
MENU="
install new relic server agent
uninstall new relic server agent
stop new relic process
start new relic process
check new relic process
Exit/Stop
"
PS3='Select task:'
select m1 in $MENU
do
case $REPLY in
1) install;;
2) uninstall;;
3) stopnewrelic;;
4) startnewrelic;;
5) checknewrelic;;
6) exit 0 ;;
esac
done
