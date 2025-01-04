#!/bin/bash

# 確認以 root 身份執行
if [ "$EUID" -ne 0 ]; then
    echo "請以 root 身份執行此腳本"
    exit 1
fi

# 更新系統套件
echo "更新系統套件..."
dnf update -y
dnf install tar chrony cockpit -y

echo "啟用 cockpit.socket"
systemctl enable cockpit.socket
systemctl restart cockpit.socket

# 讓使用者輸入 hostname
read -p "請輸入主機名稱 (hostname): " USER_HOSTNAME

# 設定 hostname
echo "設定主機名稱為 $USER_HOSTNAME..."
hostnamectl set-hostname "$USER_HOSTNAME"

# 設定系統語言為台灣中文
echo "設定系統語言為台灣中文..."
localectl set-locale LANG=zh_TW.UTF-8

# 設定時區為台北
echo "設定時區為台北..."
timedatectl set-timezone Asia/Taipei

# 設定 NTP server
echo "設定 NTP server..."
if ! grep -q "server time.stdtime.gov.tw" /etc/chrony.conf; then
    echo "server time.stdtime.gov.tw" >>/etc/chrony.conf
fi
systemctl restart chronyd

echo "設定完成！請重新啟動系統以確保所有變更生效。"
