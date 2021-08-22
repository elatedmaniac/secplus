#!/bin/bash
echo -e "-------------------------------System Information----------------------------"
echo -e "Hostname:\t\t"`hostname`
echo -e "uptime:\t\t\t"`uptime | awk '{print $3,$4}' | sed 's/,//'`
echo -e "Manufacturer:\t\t"`cat /sys/class/dmi/id/chassis_vendor`
echo -e "Product Name:\t\t"`system_profiler SPHardwareDataType | grep "Model Identifier"`
echo -e "Firmware Version:\t\t"`system_profiler SPHardwareDataType | grep "System Firmware Version"`| sed -n -e 's/System Firmware Version: //p'
echo -e "Serial #:\t\t"`system_profiler SPHardwareDataType | grep "Serial Number (system)"`| sed -n -e 's/Serial Number (system): //p'
echo -e "Machine Type:\t\t"`vserver=$(sysctl -n kern.hv_support); if [ $vserver -gt 0 ]; then echo "Supported"; else echo "Not supported"; fi`
echo -e "OS Version Number:\t"`sysctl -n kern.osproductversion`
echo -e "Kernel:\t\t\t"`uname -r`
echo -e "Architecture:\t\t"`arch`
echo -e `system_profiler SPHardwareDataType | grep "Processor Name"`
echo -e 'Processor Speed:\t' `system_profiler SPHardwareDataType | grep "Processor Speed"` | sed -n -e 's/Processor Speed: //p'
echo -e "Number of cores:\t\t"`system_profiler SPHardwareDataType | grep "Total Number of Cores:"` | sed -n -e 's/Total Number of Cores: //p'
echo -e "Active User:\t"`w | cut -d ' ' -f1 | grep -v USER | xargs -n1`
echo -e "System Main IP:\t\t"`ipconfig getifaddr en0`
echo -e "Boot UUID:\t\t"`sysctl -n kern.bootuuid`
echo ""
echo -e "-------------------------------CPU/Memory Usage------------------------------"
echo -e "Memory Usage:\t"`free | awk '/Mem/{printf("%.2f%"), $3/$2*100}'`
echo -e "Swap Usage:\t"`free | awk '/Swap/{printf("%.2f%"), $3/$2*100}'`
echo -e "CPU Usage:\t"`cat /proc/stat | awk '/cpu/{printf("%.2f%\n"), ($2+$4)*100/($2+$4+$5)}' |  awk '{print $0}' | head -1`
echo ""
echo -e "-------------------------------Disk Usage >80%-------------------------------"
df -Ph | sed s/%//g | awk '{ if($5 > 80) print $0;}'
echo ""

echo -e "-------------------------------For WWN Details-------------------------------"
echo -e sysctl -n machdep.cpu.brand_string
vserver=$(lscpu | grep Hypervisor | wc -l)
if [ $vserver -gt 0 ]
then
echo "$(hostname) is a VM"
else
cat /sys/class/fc_host/host?/port_name
fi
echo ""

if (( $(cat /etc/*-release | grep -w "Oracle|Red Hat|CentOS|Fedora" | wc -l) > 0 ))
then
echo -e "-------------------------------Package Updates-------------------------------"
yum updateinfo summary | grep 'Security|Bugfix|Enhancement'
echo -e "-----------------------------------------------------------------------------"
else
echo -e "-------------------------------Package Updates-------------------------------"
cat /var/lib/update-notifier/updates-available
echo -e "-----------------------------------------------------------------------------"
fi