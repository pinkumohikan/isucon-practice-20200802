#!/bin/bash -eu

echo 'init process' > init.log

mysql -uisucon -pisucon isucon -e "CREATE INDEX memos_idx_is_private_created_at ON memos (is_private, created_at)" >> init.log 2>&1
mysql -uisucon -pisucon isucon -e "CREATE INDEX memos_idx_user_created_at ON memos (user, created_at)" >> init.log 2>&1
mysql -uisucon -pisucon isucon -e "CREATE INDEX memos_idx_03 ON memos (user, is_private, created_at)" >> init.log 2>&1

mysql -uisucon -pisucon isucon -e "ALTER TABLE memos ADD COLUMN title VARCHAR(1000) DEFAULT ''" >> init.log 2>&1
mysql -uisucon -pisucon isucon -e "CREATE TRIGGER make_title BEFORE INSERT ON memos FOR EACH ROW SET NEW.title = substring_index(NEW.content, \"\\n\", 1)" >> init.log 2>&1

mysql -uisucon -pisucon isucon -e "DROP TABLE IF EXISTS public_memos" >> init.log 2>&1
mysql -uisucon -pisucon isucon -e "CREATE TABLE public_memos (memo_id int)" >> init.log 2>&1
mysql -uisucon -pisucon isucon -e "CREATE INDEX memo_id ON public_memos (memo_id)" >> init.log 2>&1
mysql -uisucon -pisucon isucon -e "INSERT INTO public_memos SELECT id FROM memos WHERE is_private=0 ORDER BY created_at" >> init.log 2>&1
