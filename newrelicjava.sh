#!/bin/bash
#
#To install new relic java agent on ir1/ir2/ir3
#usage: ./newrelicjava.sh  
#       To install java agent: 1, 3, 4, 5
#       To uninstall java agent: 2, 3, 4, 5
#       select 6 to exit program  
install() {
#cd tomcat(CATALINA_HOME) directory
cd  /mnt/apache-tomcat-7.0.52/

#download latest new relic java agent version  
wget http://yum.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java-3.14.0.zip

#unzip 
unzip newrelic-java-3.8.2.zip

#Update newrelic config file 
cd /mnt/apache-tomcat-7.0.52/newrelic
sed -i.old '/^  app_name: My.*[^)]$/s/[ ]*\([^ ]*\)[ ]\([^ ]*[ ][^ ]*\)/\1 IR API(ewr2)/' newrelic.yml
echo "*** verify config file update ***"
diff newrelic.yml newrelic.yml.old

}

uninstall() {
#Delete newrelic folder 
cd /mnt/apache-tomcat-7.0.52/
rm -rf newrelic

#Delete the New Relic Java options variable from your startup script.
cd /mnt/apache-tomcat-7.0.52/bin
sed -i.`date +%Y%m%d`  '/New Relic/{N;N;s/^/#/gm }' catalina.sh
diff catalina.sh catalina.sh.`date +%Y%m%d`

}

stopjava() {
#stop tomcat java process
su - tomcat 
cd /mnt/tomcat/ir-api
startup.sh stop
}

startjava() {
#start tomcat java process
su - tomcat 
cd /mnt/tomcat/ir-api
startup.sh start 
}

checkjava() {
ps -ef | grep [t]omcat 
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
