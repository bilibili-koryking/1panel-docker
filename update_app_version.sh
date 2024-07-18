#!/bin/bash

# 更新数据库
update_database() {
  if [[ -f ${PANEL_BASE_DIR}/1panel/db/1Panel.db ]]; then
    # 备份数据库文件
    cp ${PANEL_BASE_DIR}/1panel/db/1Panel.db ${PANEL_BASE_DIR}/1panel/db/1Panel.db.bak

    # 使用 sqlite3 执行更新操作
    sqlite3 ${PANEL_BASE_DIR}/1panel/db/1Panel.db <<EOF
UPDATE settings
SET value = '$(curl -s https://resource.fit2cloud.com/1panel/package/stable/latest)'
WHERE key = 'SystemVersion';
.exit
EOF

    echo "数据库版本已更新为 $(curl -s https://resource.fit2cloud.com/1panel/package/stable/latest)"
  else
    echo "警告：${PANEL_BASE_DIR}/1panel/db/1Panel.db 文件不存在" >&2
    exit 0
  fi
}

# 主函数
main() {
    update_database
}

# 调用主函数
main
