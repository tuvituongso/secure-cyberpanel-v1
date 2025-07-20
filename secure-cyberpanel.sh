#!/bin/bash

echo "🛡️ Bắt đầu bảo mật VPS Ubuntu 22.04 chạy CyberPanel..."

# 1. Cập nhật hệ thống
echo "📦 Cập nhật hệ thống..."
apt update && apt upgrade -y

# 2. Cài đặt UFW và cấu hình firewall cho CyberPanel
echo "🧱 Cấu hình tường lửa UFW..."
apt install ufw -y
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 443/tcp
ufw allow 80/tcp
ufw allow 8090/tcp
ufw allow 21/tcp
ufw allow 40110:40210/tcp
ufw allow 25,587/tcp
ufw allow 110,143,993,995/tcp
ufw enable

# 3. Cài Fail2Ban chống brute-force
echo "🚫 Cài đặt và cấu hình Fail2Ban..."
apt install fail2ban -y
cat > /etc/fail2ban/jail.local <<EOF
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = systemd
maxretry = 5
bantime = 1h

[cyberpanel]
enabled = true
port = 8090
filter = cyberpanel
logpath = /usr/local/lscp/logs/error.log
maxretry = 5
bantime = 1h
EOF

mkdir -p /etc/fail2ban/filter.d
cat > /etc/fail2ban/filter.d/cyberpanel.conf <<EOF
[Definition]
failregex = Authentication failed for user .* from <HOST>
EOF

systemctl restart fail2ban

# 4. Vô hiệu hóa root login SSH
echo "🔒 Tắt đăng nhập root SSH..."
sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

# 5. Cài đặt rkhunter phát hiện rootkit
echo "🕵️ Cài rkhunter kiểm tra rootkit..."
apt install rkhunter -y
rkhunter --update
rkhunter --propupd

# 6. Cấu hình sysctl để bảo vệ kernel
echo "🔐 Cấu hình sysctl bảo mật kernel..."
cat >> /etc/sysctl.conf <<EOF

# Security hardening
net.ipv4.conf.all.rp_filter = 1
net.ipv4.icmp_echo_ignore_all = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.tcp_syncookies = 1
EOF

sysctl -p

# 7. Chặn ping
echo "🙈 Ẩn server khỏi ping (ICMP)..."
echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all

echo "✅ Đã hoàn tất bảo mật VPS. Hãy kiểm tra hoạt động của firewall và Fail2Ban."
