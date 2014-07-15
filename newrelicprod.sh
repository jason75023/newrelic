#!/bin/bash
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
