#!/bin/bash

# 確認以 root 身份執行
if [ "$EUID" -ne 0 ]; then
    echo "請以 root 身份執行此腳本"
    exit 1
fi

# 更新系統套件
echo "更新系統套件..."
dnf update -y
dnf groupinstall "Server with GUI" -y
dnf install epel-release -y
dnf install xrdp -y

echo "啟用 xrdp"
systemctl enable --now xrdp
