#!/bin/bash

# Variables
VPN_HOST="103.134.88.80"
VPN_USER="infozillion"
VPN_PASS="oqu2ahk3iep3EaphieKa"
VPN_CERT_PIN="BAghA7LXVLR6JdMa4wKrhmFMf3nJGlfh4BHz5FCHvo4="

SSH_TUNNEL_HOST="192.168.200.10"
SSH_TUNNEL_PORT="22"
SSH_TUNNEL_USER="root"
SSH_TUNNEL_PASS="oqu2ahk3iep3EaphieKa"

DB_PORT="5432"
DB_HOST_IPTSP="192.168.200.199"
DB_HOST_MNO="192.168.200.194"
DB_USER="infozillion_db_user"
DB_PASS="oqu2ahk3iep3EaphieKa"
DB_NAME="a2p_reporting"



TODAY=$(date +%F)
YESTERDAY=$(date -d "yesterday" +%F)

SQL_QUERY="SELECT date(delivery_date), client_id, operator, message_type, COUNT(msisdn)
FROM a2p_broadcast_history_y2024m07
WHERE date(delivery_date) BETWEEN '$YESTERDAY' AND '$YESTERDAY'
AND ans_business_code='1000'
GROUP BY date(delivery_date), client_id, operator, message_type
ORDER BY 1 DESC, 5 DESC;"

OUTPUT_CSV_IPTSP="iptsp_output_sql_${TODAY}.csv"
OUTPUT_CSV_MNO="mno_output_sql_${TODAY}.csv"

# Connect to VPN
echo "Connecting to VPN..."
echo "$VPN_PASS" | sudo openconnect $VPN_HOST --user=$VPN_USER --passwd-on-stdin --servercert pin-sha256:$VPN_CERT_PIN &

# Wait for VPN connection to establish
sleep 10

# Set up SSH tunnels
echo "Creating SSH tunnel to $DB_HOST_IPTSP..."
sshpass -p $SSH_TUNNEL_PASS ssh -f -N -L $DB_PORT:$DB_HOST_IPTSP:$DB_PORT $SSH_TUNNEL_USER@$SSH_TUNNEL_HOST -p $SSH_TUNNEL_PORT

echo "Creating SSH tunnel to $DB_HOST_MNO..."
sshpass -p $SSH_TUNNEL_PASS ssh -f -N -L $DB_PORT:$DB_HOST_MNO:$DB_PORT $SSH_TUNNEL_USER@$SSH_TUNNEL_HOST -p $SSH_TUNNEL_PORT

# Create .pgpass file
echo "$DB_HOST_IPTSP:$DB_PORT:$DB_NAME:$DB_USER:$DB_PASS" > ~/.pgpass
echo "$DB_HOST_MNO:$DB_PORT:$DB_NAME:$DB_USER:$DB_PASS" >> ~/.pgpass
chmod 600 ~/.pgpass

# Execute SQL query on IPTSP database
echo "Executing SQL query on $DB_HOST_IPTSP..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST_IPTSP -p $DB_PORT -U $DB_USER -d $DB_NAME -c "$SQL_QUERY" -o $OUTPUT_CSV_IPTSP

# Execute SQL query on MNO database
echo "Executing SQL query on $DB_HOST_MNO..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST_MNO -p $DB_PORT -U $DB_USER -d $DB_NAME -c "$SQL_QUERY" -o $OUTPUT_CSV_MNO

# Disconnect from VPN
echo "Disconnecting from VPN..."
sudo killall openconnect

echo "Script finished."

