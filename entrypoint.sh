#!/bin/bash
set -e

# Default variables
P4USER=${P4USER:-super}
P4PASSWD=${P4PASSWD:-Password123!}
P4PORT=${P4PORT:-1666}

echo "Starting Perforce Entrypoint..."

# Ensure the server is configured
if [ ! -d "/opt/perforce/servers/master/root" ]; then
    echo "Configuring Perforce server for the first time..."
    # Execute configure-helix-p4d.sh
    # -n for non-interactive
    # -p for P4PORT
    # -r for P4ROOT
    # -u for P4USER
    # -P for P4PASSWD
    /opt/perforce/sbin/configure-helix-p4d.sh master -n -p ${P4PORT} -r /opt/perforce/servers/master/root -u ${P4USER} -P ${P4PASSWD}

    # Wait a bit for server to start properly
    sleep 2

    # Login and run configuration script
    echo "Running configuration script..."
    echo ${P4PASSWD} | p4 login
    /root/configure_p4.sh
else
    echo "Starting existing Perforce service..."
    # Ensure p4dctl config exists if attached to new container
    if [ ! -f "/etc/perforce/p4dctl.conf.d/master.conf" ]; then
        echo "Recreating p4dctl config for master..."
        cat <<EOF > /etc/perforce/p4dctl.conf.d/master.conf
p4d master
{
    Owner       = perforce
    Execute     = /opt/perforce/sbin/p4d
    Umask       = 077
    Environment
    {
        P4ROOT    = /opt/perforce/servers/master/root
        P4SSLDIR  = ssl
        P4PORT    = ${P4PORT}
        PATH      = /bin:/usr/bin:/usr/local/bin:/opt/perforce/bin:/opt/perforce/sbin
    }
}
EOF
        chown root:root /etc/perforce/p4dctl.conf.d/master.conf
    fi
    p4dctl start master
fi

echo "Perforce server is running."

# Keep container running by tailing the log file
LOG_FILE="/opt/perforce/servers/master/root/logs/log"
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    chown perforce:perforce "$LOG_FILE"
fi

exec tail -F "$LOG_FILE"
