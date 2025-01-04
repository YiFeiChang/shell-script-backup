#!/bin/bash

# 確認腳本以 root 身分執行
if [ "$(id -u)" -ne 0 ]; then
    echo "請以 root 身分執行此腳本。"
    exit 1
fi

# 更新系統套件
echo "更新系統套件..."
dnf update -y
dnf install -y samba

setsebool -P samba_enable_home_dirs 1
setsebool -P samba_export_all_ro 1
setsebool -P samba_export_all_rw 1

# 提示使用者輸入使用者名稱
read -p "請輸入要新增的 Samba 使用者名稱: " samba_user
read -p "請輸入要新增的 Samba 使用者密碼: " samba_password

# 檢查使用者名稱是否已存在
if id "$samba_user" &>/dev/null; then
    echo "使用者 $samba_user 已存在於系統中。"
else
    # 新增系統使用者
    useradd -M "$samba_user"
    echo "系統使用者 $samba_user 已新增。"
fi

# 設定 Samba 使用者密碼
echo "請為 $samba_user 設定 Samba 密碼:"
(
    echo $samba_password
    echo $samba_password
) | smbpasswd -a "$samba_user"

systemctl enable --now smb nmb

# 確認 Samba 使用者已成功新增
if pdbedit -L | grep -q "^$samba_user:"; then
    echo "Samba 使用者 $samba_user 已成功新增。"
else
    echo "新增 Samba 使用者 $samba_user 時發生錯誤。"
fi
