sudo service snort restart
# Run Snort in Daemon mode (in background)
snort -D -c /etc/snort/snort.conf -l /var/log/snort/
tail -f /dev/null
