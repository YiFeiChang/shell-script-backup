#!/bin/bash

# 確保以 root 權限執行此腳本
if [[ $EUID -ne 0 ]]; then
    echo "請以 root 身份執行此腳本"
    exit 1
fi

# 定義要移除的使用者名稱
read -p "請輸入要移除的使用者名稱：" username

# 檢查使用者是否存在
if id "$username" &>/dev/null; then
    # 移除使用者及其 home 目錄
    userdel -r $username
    echo "使用者 $username 及他的 home 目錄已被移除。"
else
    echo "使用者 $username 不存在。"
    exit 1
fi
