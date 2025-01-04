#!/bin/bash

# 確保以 root 權限執行此腳本
if [[ $EUID -ne 0 ]]; then
    echo "請以 root 身份執行此腳本"
    exit 1
fi

# 提示用戶輸入新的使用者名稱
read -p "輸入新的使用者名稱：" username

# 新增使用者
adduser $username

# 設定使用者密碼
passwd $username

# 將使用者添加到 wheel 組以給予 sudo 權限
usermod -aG wheel $username

# 確認操作是否成功
if id "$username" &>/dev/null; then
    echo "使用者 $username 已被加入並添加到 wheel 群組給予 sudo 權限。"
else
    echo "加入使用者 $username 失敗。"
    exit 1
fi
