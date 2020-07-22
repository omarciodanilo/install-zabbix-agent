# Important
### Run this script on your own. I strongly suggest that you read it completely to understand what it does.

# Notes
### Tested environments (I need to retest due to some modifications in the code)
- Ubuntu 16.04
- Ubuntu 18.04
- Debian 9
- Debian 10

### Instructions
- This script should be run with root user
- First, it will install and configure Zabbix agent on the machine
- Second, it will install and configure the possibility of monitor temperature, FANs, and power of the machine
  - For this to take efect, you need to setup your Zabbix server properly, importing and linking the template_sensors.xml
  - This file can be downloaded at https://share.zabbix.com/cat-server-hardware/sensors
