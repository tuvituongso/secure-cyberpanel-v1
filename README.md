# Script Bảo Mật VPS Ubuntu 22.04 Chạy CyberPanel

## Tính năng:
- Cập nhật hệ thống
- Cấu hình firewall UFW
- Cài và cấu hình Fail2Ban
- Tắt đăng nhập root SSH
- Cài đặt rkhunter để kiểm tra rootkit
- Bảo mật kernel với sysctl
- Ẩn server khỏi ICMP scan (chặn ping)

## Hướng dẫn sử dụng:

1. Tải script:
```bash
chmod +x secure-cyberpanel.sh
sudo ./secure-cyberpanel.sh
```

**Lưu ý:** Nên chạy với quyền `root` hoặc `sudo`.
