#!/bin/bash
#
# prupose:To install/uninstall new relic java agent on Locus-IR: ir1/ir2/ir3 VMs
# usage:
# 1. login to server
# 2. bash <(wget -qO - https://raw.githubusercontent.com/jason75023/newrelic-server/master/newrelicjava.sh)
#       To install java agent: 1, 3, 4, 5
#       To uninstall java agent: 2, 3, 4, 5
#       select 6 to exit program  
#
install() {
#cd tomcat(CATALINA_HOME) directory
cd  /mnt/apache-tomcat-7.0.52/

#download latest new relic java agent version  
wget http://yum.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java-3.14.0.zip

#unzip 
unzip newrelic-java-3.8.2.zip

#install newrelic java agent
cd /mnt/apache-tomcat-7.0.52/newrelic
/mnt/jdk1.7.0_51/bin/java -jar newrelic.jar install 

#Update newrelic config file 
#license="1385436c45c570cb5e1ec46664b06adb03748bde"
#app="IR API(ewr2)"

echo -n "Please enter license: "
read license
echo -n "Please enter app name: "
read app
sed -i.old -e "/^  app_name: My.*[^)]$/s/My Application/$app/" -e '/license_key:.*license_key/s/<%= license_key %>/$license/' newrelic.yml

echo "*** verify config file update ***"
diff newrelic.yml newrelic.yml.old

#For newrelic_agent.log, to check newrelic agent status  
mkdir /mnt/apache-tomcat-7.0.52/newrelic/logs
chown -R tomcat.ir /mnt/apache-tomcat-7.0.52/newrelic

return
}

uninstall() {
#Delete newrelic folder 
cd /mnt/apache-tomcat-7.0.52/
rm -rf newrelic

#Delete the New Relic Java options variable from your startup script.
cd /mnt/apache-tomcat-7.0.52/bin
sed -i.`date +%Y%m%d`  '/New Relic/{N;N;s/^/#/gm }' catalina.sh
diff catalina.sh catalina.sh.`date +%Y%m%d`

return
}

stopjava() {
#stop tomcat java process
su - tomcat -c "/mnt/tomcat/ir-api/startup.sh stop"

return
}

startjava() {
#start tomcat java process
su - tomcat -c "/mnt/tomcat/ir-api/startup.sh start"

return
}

checkjava() {
ps -ef | grep [t]omcat 

return
}


#
# MAIN program
#
IFS='
'
MENU="
install new relic java agent 
uninstall new relic java agent
stop java process
start java process
check java process 
Exit/Stop
"
PS3='Select task:'
select m1 in $MENU
do
case $REPLY in
1) install;;
2) uninstall;;
3) stopjava;;
4) startjava;;
5) checkjava;;
6) exit 0 ;;
esac
done
