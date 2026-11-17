for u in root admin ubuntu oracle postgres test deploy backup; do
  echo "Nov 17 05:38:01 wazuh-server sshd: Failed password for invalid user $u from 185.220.101.45 port 54321 ssh2" >> /var/ossec/logs/active-responses.log
  sleep 0.3
done
