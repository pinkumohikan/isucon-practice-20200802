#!/bin/bash -eu

echo 'init process'

mysql -uisucon -pisucon isucon -e "CREATE INDEX memos_idx_is_private_created_at ON memos (is_private, created_at)"
mysql -uisucon -pisucon isucon -e "CREATE INDEX memos_idx_user_created_at ON memos (user, created_at)"
mysql -uisucon -pisucon isucon -e "CREATE INDEX memos_idx_03 ON memos (user, is_private, created_at)"

mysql -uisucon -pisucon isucon -e "ALTER TABLE memos ADD COLUMN title VARCHAR(1000) DEFAULT ''"
mysql -uisucon -pisucon isucon -e "REATE TRIGGER make_title AFTER INSERT ON memos FOR EACH ROW UPDATE memos SET title = substring_index(NEW.content, \"\\n\", 1)"
