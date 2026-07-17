#!/bin/bash

set -e

LOG_FILE="/var/log/openvpn-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "========== OpenVPN Bootstrap Started : $(date) =========="

MARKER="/var/lib/openvpn-fips-disabled"

AFTER_SCRIPT="/usr/local/bin/openvpn-after-reboot.sh"

SERVICE_FILE="/etc/systemd/system/openvpn-after-reboot.service"

############################################################
# Disable FIPS if enabled
############################################################

if [ ! -f "$MARKER" ]; then

    if [ "$(cat /proc/sys/crypto/fips_enabled)" = "1" ]; then

        echo "FIPS Enabled"

        fips-mode-setup --disable

        cat > "$AFTER_SCRIPT" <<'EOF'
#!/bin/bash

set -e

LOG_FILE="/var/log/openvpn-install.log"
exec >> "$LOG_FILE" 2>&1

echo "========== Continuing After Reboot =========="

echo "Waiting for network..."

NETWORK_READY=false

for i in {1..30}
do

    if curl -fsS https://raw.githubusercontent.com >/dev/null 2>&1
    then
        NETWORK_READY=true
        break
    fi

    sleep 10

done

if [ "$NETWORK_READY" != "true" ]
then
    echo "Network never became ready"
    exit 1
fi

echo "Setting crypto policy..."

update-crypto-policies --set DEFAULT

echo "Current Crypto Policy:"
update-crypto-policies --show

echo "Checking FIPS..."

fips-mode-setup --check || true

cat /proc/sys/crypto/fips_enabled

update-crypto-policies --show

if [ "$(cat /proc/sys/crypto/fips_enabled)" != "0" ]
then
    echo "FIPS still enabled"
    exit 1
fi

echo "Downloading installer..."

cd /root

curl -fO https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh

chmod +x openvpn-install.sh

############################################################
# OpenVPN Variables
############################################################

export AUTO_INSTALL=y

TOKEN=$(curl -sX PUT \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
http://169.254.169.254/latest/api/token)

export ENDPOINT=$(curl -s \
-H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/public-ipv4)
export APPROVE_INSTALL=y

export APPROVE_IP=y

export IPV6_SUPPORT=n

export CLIENT_IPV4=y

export CLIENT_IPV6=n

export IPV4_SUBNET_CHOICE=1

export PORT_CHOICE=1

export PROTOCOL=tcp

export DNS=adguard

export MULTI_CLIENT=n

export MTU_CHOICE=1

export AUTH_MODE=pki

export COMPRESSION_ENABLED=n

export CUSTOMIZE_ENC=n

export CLIENT=arunvpn

export CLIENT_CERT_DURATION_DAYS=3650

export PASS=1

echo "Installing OpenVPN..."

./openvpn-install.sh install


# ----------------------------------------------------------
# OVPN Profile
# ----------------------------------------------------------

echo "OVPN profile created at: /root/arunvpn.ovpn"

if [ -f /root/arunvpn.ovpn ]; then
    echo "OVPN file generated successfully."
    ls -l /root/arunvpn.ovpn
else
    echo "ERROR: arunvpn.ovpn was not created."
    exit 1
fi
# ----------------------------------------------------------
# Restart OpenVPN
# ----------------------------------------------------------

echo "Restarting OpenVPN..."

systemctl enable openvpn-server@server

systemctl restart openvpn-server@server || true

echo "Checking OpenVPN status..."

systemctl status openvpn-server@server --no-pager || true

echo "OpenVPN installation completed."

# ----------------------------------------------------------
# Cleanup
# ----------------------------------------------------------

systemctl disable openvpn-after-reboot.service || true

rm -f /etc/systemd/system/openvpn-after-reboot.service

rm -f /usr/local/bin/openvpn-after-reboot.sh

systemctl daemon-reload

echo "Completed Successfully"

EOF

chmod +x "$AFTER_SCRIPT"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Continue OpenVPN Installation After FIPS Reboot
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=$AFTER_SCRIPT
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl enable openvpn-after-reboot.service


touch "$MARKER"

echo "Rebooting instance..."

systemctl reboot

exit 0

    fi
fi

############################################################
# FIPS already disabled
############################################################

echo "FIPS already disabled."

update-crypto-policies --set DEFAULT

echo "Current Crypto Policy:"
update-crypto-policies --show

cd /root

curl -fO https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh

chmod +x openvpn-install.sh

export AUTO_INSTALL=y

TOKEN=$(curl -sX PUT \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
http://169.254.169.254/latest/api/token)

export ENDPOINT=$(curl -s \
-H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/public-ipv4)

export APPROVE_INSTALL=y
export APPROVE_IP=y
export IPV6_SUPPORT=n
export CLIENT_IPV4=y
export CLIENT_IPV6=n
export IPV4_SUBNET_CHOICE=1
export PORT_CHOICE=1
export PROTOCOL=tcp
export DNS=adguard
export MULTI_CLIENT=n
export MTU_CHOICE=1
export AUTH_MODE=pki
export COMPRESSION_ENABLED=n
export CUSTOMIZE_ENC=n
export CLIENT=arunvpn
export CLIENT_CERT_DURATION_DAYS=3650
export PASS=1

./openvpn-install.sh install

echo "OVPN profile created at: /root/arunvpn.ovpn"

if [ -f /root/arunvpn.ovpn ]; then
    echo "OVPN file generated successfully."
    ls -l /root/arunvpn.ovpn
else
    echo "ERROR: arunvpn.ovpn was not created."
    exit 1
fi

systemctl enable openvpn-server@server

systemctl restart openvpn-server@server || true

systemctl status openvpn-server@server --no-pager || true

echo "========== OpenVPN Bootstrap Completed : $(date) =========="