#!/bin/bash

log_file="$HOME/install-zabbix-agent.log"
zabbix_ip="Zabbix server IP"

check_command_output() {
	if [ $(echo $?) -eq 0 ]
	then
		echo -e "... OK" | tee -a $log_file
	else
		echo -e "... FAIL" | tee -a $log_file
	fi
}

clear

echo -e "\n==== $(date) ====" >> $log_file
echo -e "==== ZABBIX AGENT ====\n"  | tee -a $log_file

echo -e "- Updating the list of repositories" | tee -a $log_file
apt update > /dev/null 2> $log_file
check_command_output

echo -e "- Installing Zabbix agent" | tee -a $log_file
apt install -y zabbix-agent > /dev/null 2> $log_file
check_command_output

echo -e "- Creating backup file for /etc/zabbix/zabbix_agentd.conf" | tee -a $log_file
cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bak 2> $log_file
check_command_output

echo -e "- Changing Server parameter in /etc/zabbix/zabbix_agentd.conf" | tee -a $log_file
sed -i "s/Server=127.0.0.1/Server=$zabbix_ip/" /etc/zabbix/zabbix_agentd.conf 2> $log_file
check_command_output

echo -e "- Changing ServerActive parameter in /etc/zabbix/zabbix_agentd.conf" | tee -a $log_file
sed -i "s/ServerActive=127.0.0.1/ServerActive=$zabbix_ip/" /etc/zabbix/zabbix_agentd.conf 2> $log_file
check_command_output

echo -e "- Changing Hostname parameter in /etc/zabbix/zabbix_agentd.conf" | tee -a $log_file
sed -i "s/Hostname=Zabbix server/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf 2> $log_file
check_command_output

echo -e "- Enabling zabbix-agent service on boot" | tee -a $log_file
systemctl enable zabbix-agent 2> $log_file
check_command_output

echo -e "- Restarting zabbix-agent service" | tee -a $log_file
/etc/init.d/zabbix-agent restart > /dev/null 2> $log_file
check_command_output

echo -e "\n==== TEMPERATURE, FANS AND POWER MONITORING ====\n"  | tee -a $log_file

echo -e "- Installing lm-sensors" | tee -a $log_file
apt install -y lm-sensors > /dev/null 2> $log_file
check_command_output

echo -e "- Creating directory /etc/zabbix/scripts/" | tee -a $log_file
mkdir /etc/zabbix/scripts/ 2> $log_file
check_command_output

echo -e "- Changing ownership of /etc/zabbix/scripts" | tee -a $log_file
chown zabbix.zabbix /etc/zabbix/scripts 2> $log_file
check_command_output

echo -e "- Downloading zabbix-sensors.zip from Zabbix website to $HOME" | tee -a $log_file
wget -P $HOME -O zabbix-sensors.zip https://share.zabbix.com/index.php?option=com_mtree&task=att_download&link_id=1496&cf_id=39
check_command_output

echo -e "- Unziping sensors.conf from $HOME/zabbix-sensors.zip to /etc/zabbix/zabbix_agentd.conf.d" | tee -a $log_file
unzip $HOME/zabbix-sensors.zip sensors.conf -d /etc/zabbix/zabbix_agentd.conf.d
check_command_output

echo -e "- Changing ownership of /etc/zabbix/zabbix_agentd.conf.d/sensors.conf to the user and group zabbix" | tee -a $log_file
chown zabbix.zabbix /etc/zabbix/zabbix_agentd.conf.d/sensors.conf 2> $log_file
check_command_output

echo -e "- Unziping discover-sensors.py from $HOME/zabbix-sensors.zip to /etc/zabbix/scripts" | tee -a $log_file
unzip $HOME/zabbix-sensors.zip discover-sensors.py -d /etc/zabbix/scripts
check_command_output

echo -e "- Changing ownership of /etc/zabbix/scripts/discover-sensors.py to the user and group zabbix" | tee -a $log_file
chown zabbix.zabbix /etc/zabbix/scripts/discover-sensors.py 2> $log_file
check_command_output

echo -e "- Changing permissions of /etc/zabbix/scripts/discover-sensors.py" | tee -a $log_file
chmod 744 /etc/zabbix/scripts/discover-sensors.py 2> $log_file
check_command_output

echo -e "- Removing $HOME/zabbix-sensors.zip" | tee -a $log_file
rm $HOME/zabbix-sensors.zip
check_command_output

echo -e "\n- Please refer to the $log_file file for error information.\n"