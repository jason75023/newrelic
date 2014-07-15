#!/bin/bash
rpm -Uvh http://download.newrelic.com/pub/newrelic/el5/i386/newrelic-repo-5-3.noarch.rpm
echo "check new relic repository is added"
yum repolist| grep newrelic
yum install newrelic-sysmond
/usr/sbin/nrsysmond-config --set license_key=d2db314eee5a923e1bc31dfae0ed0f27238a34c0
echo "check license_key is added to new relic config file"
grep license_key= /etc/newrelic/nrsysmond.cfg
/etc/init.d/newrelic-sysmond start 
echo "check new relic processes are running"
ps -fu newrelic
