# PostgreSQL Debug Build Environment

PostgreSQL 16.1をデバッグ情報付きでビルドし、gdbで認証処理を解析するためのDocker環境です。

## 構成

```
vive_postgres_compile/
├── Dockerfile              # Amazon Linux 2023 + 開発ツール
├── docker-compose.yml      # Docker設定（SYS_PTRACE権限付き）
├── scripts/
│   ├── configure-debug.sh  # デバッグ用設定
│   ├── build.sh           # ビルド・contrib含む
│   └── full-build.sh      # 完全ビルド
└── README.md
```

## クイックスタート

### 1. 環境構築・ビルド
```bash
docker-compose up -d --build
docker exec -it postgres-compile bash

# 必要に応じてシステムツールをインストール
dnf install -y procps-ng util-linux shadow-utils which less vim gdb

# PostgreSQLビルド（contrib含む）
/usr/src/scripts/full-build.sh
```

### 2. PostgreSQL環境セットアップ
```bash
useradd -r -s /bin/false postgres || true
mkdir -p /usr/local/pgsql/data
chown postgres:postgres /usr/local/pgsql/data
su - postgres -s /bin/bash -c '/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data'
```

### 3. GDBデバッグ
```bash
# GDBでPostgreSQL起動
su - postgres -s /bin/bash -c 'cd /usr/local/pgsql && gdb /usr/local/pgsql/bin/postgres'

# GDB内で
(gdb) set args -D /usr/local/pgsql/data
(gdb) break ClientAuthentication
(gdb) break PerformAuthentication
(gdb) run

# 別ターミナルから接続テスト
docker exec -it postgres-compile bash
su - postgres -s /bin/bash -c '/usr/local/pgsql/bin/psql -h localhost'
```

## 主要機能

### ビルド仕様
- **PostgreSQL 16.1** デバッグビルド（-g3 -O0）
- **Contrib拡張** 全モジュール含む
- **依存関係** ICU、UUID、OpenSSL等完備
- **アサーション** 有効（--enable-cassert）

### デバッグ環境
- **GDB対応** SYS_PTRACE権限付きコンテナ
- **認証ブレークポイント** ClientAuthentication、PerformAuthentication等
- **システムツール** ps、vim、less等（要インストール）

### 利用可能拡張（例）
```sql
CREATE EXTENSION pg_stat_statements;  -- SQL統計
CREATE EXTENSION pgcrypto;            -- 暗号化
CREATE EXTENSION hstore;              -- KVストア
CREATE EXTENSION "uuid-ossp";         -- UUID生成
```

## トラブルシューティング

### ptrace権限エラー
- docker-compose.ymlでSYS_PTRACE権限を設定済み
- コンテナ再起動が必要

### システムツール不足
```bash
dnf install -y procps-ng util-linux shadow-utils which less vim gdb
```

### GDBシンボル読み込み
```bash
(gdb) file /usr/local/pgsql/bin/postgres
(gdb) set args -D /usr/local/pgsql/data
```

## Git ワークフロー（複数端末での作業）

### 他の端末で変更を加える場合

```bash
# 1. 最新版を取得
git pull origin main

# 2. 変更を加える
# ファイル編集...

# 3. 変更をコミット・プッシュ
git add .
git commit -m "変更内容の説明"
git push origin main
```

### この端末で変更を反映する場合

```bash
# 1. 作業前に最新版を取得
git pull origin main

# 2. 変更を加える
# ファイル編集...

# 3. 変更をコミット・プッシュ
git add .
git commit -m "変更内容の説明"
git push origin main
```

### 競合が発生した場合

```bash
# 1. 最新版を取得（競合発生）
git pull origin main

# 2. 競合ファイルを手動で編集
# <<<<<<< HEAD と >>>>>>> の間を修正

# 3. 競合解決後にコミット
git add .
git commit -m "Merge conflict resolved"
git push origin main
```

**重要**: 作業開始時は必ず `git pull` で最新版を取得してください。

---

**成果**: PostgreSQL認証処理のソースレベル解析が可能な完全デバッグ環境