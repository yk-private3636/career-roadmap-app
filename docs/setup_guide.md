# セットアップ手順

ローカル環境構築および Terraform 操作の手順をまとめる。

## 1. 共通の初期セットアップ

### 1.1 前提ツール

- Docker / Docker Compose
- AWS CLI v2 (Terraform 操作を行う場合)

### 1.2 `setup.sh` の実行

リポジトリルートで一度だけ実行する。各サービス (`api` / `batch` / `job` / `observability` / `infra`) の `.env.example` と `infra/terraform.tfvars.example` から、それぞれ `.env` / `terraform.tfvars` を生成する。

```bash
chmod +x ./setup.sh
./setup.sh
```

`--update=none` 指定のため、既存ファイルは上書きされない。再実行は安全。

## 2. アプリケーションのローカル起動

### 2.1 全サービスの起動

```bash
docker compose up -d
```

依存関係 (`db` / `inmemory` / `observability` の healthcheck 通過 → `api` 起動 → `proxy` / `web` 起動) は compose 側で定義済み。初回はビルドが走るため数分かかる。

### 2.2 アクセス先

| サービス | URL / ポート | 備考 |
|---------|------------|-----|
| Web (フロント) | http://localhost:3000 | `WEB_PORT` で変更可 |
| Proxy (api 経由) | http://localhost:8080 | `PROXY_PORT` で変更可 |
| DB (Postgres) | localhost:5432 | `DATABASE_PORT` で変更可。user/pass: `developer` / `developer`、DB 名: `career_roadmap` |
| Inmemory (Redis) | localhost:6380 | `INMEMORY_PORT` で変更可 |
| Observability (OTLP) | localhost:4318 | `OBSERVABILITY_OTLP_PORT` で変更可 |
| Observability (UI) | http://localhost:16686 | `OBSERVABILITY_UI_PORT` で変更可 |

ポートを変更したい場合は、`docker compose up` 実行前にシェル環境変数または `compose.yml` と同階層の `.env` で指定する。

### 2.3 停止 / クリーンアップ

```bash
# 停止 (コンテナのみ削除、ボリュームは残る)
docker compose down

# DB の永続データもまとめて削除して初期状態に戻したいとき
docker compose down -v
```

`db/init/test_schema_setup.sql` は `docker-entrypoint-initdb.d` 経由で **初回起動時のみ** 適用される。スキーマを再作成したい場合は `down -v` でボリュームごと削除してから `up -d` し直す。

## 3. Terraform 操作 (ローカル) の手順

### 3.1 AWS 側で手動作成しておくリソース (Terraform 管理外)

以下は **Terraform 自身が動くための前提** であり、Terraform 管理対象に含められない (chicken-and-egg)。マネジメントコンソール / CLI で先に用意しておく。

| リソース | 用途 |
|---------|-----|
| IAM ユーザー `career-roadmap-app-terraform` | Terraform 操作の起点。MFA を有効化すること (assume role 側で MFA 必須化されている) |
| S3 バケット `career-roadmap-app-tfstate` | `backend.tf` で参照される tfstate 保管先 |

### 3.2 `terraform_role` は初回に作成し、以後**削除してはならない**

`infra/src/envs/prod/terraform_role.tf` で定義されている `${env}-${project_name}-terraform-role` は **Terraform が自身を実行するための assume role 先**。削除すると `provider.tf` の `assume_role` で参照しているロールが消失し、Terraform 操作自体が不可能になる (再構築には IAM ユーザー直接権限による緊急復旧が必要)。

- 初回は **コンソール等で手動作成** → `imports.tf` の `import` ブロックで Terraform 管理下に取り込む構成になっている
- `terraform destroy` の対象から外すこと。「触らない時は destroy」運用を行う際も、本ロールは破棄しない層に置く

### 3.3 `terraform.tfvars` の設定

`infra/src/envs/prod/terraform.tfvars` に以下を記入する。

```hcl
account_id                 = "123456789012"
terraform_assume_role_arn  = "arn:aws:iam::123456789012:role/prod-career-roadmap-app-terraform-role"
```

### 3.4 一時クレデンシャル取得 (MFA 必須)

`terraform_role` の assume role policy で `aws:MultiFactorAuthPresent = true` を強制しているため、**MFA 通過済みの一時クレデンシャル** が必須。

```bash
aws sts get-session-token \
  --duration-seconds 14400 \
  --serial-number arn:aws:iam::<account_id>:mfa/<device-name> \
  --token-code <6桁ワンタイム>
```

`--duration-seconds` は最大 129600 (36時間) まで指定可。作業セッションに合わせて調整する。

### 3.5 `infra/.env` への貼り付け

取得したクレデンシャルを `infra/.env` に転記する。

```env
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_SESSION_TOKEN=...
TF_LOG=
```

### 3.6 コンテナ起動と Terraform 操作

```bash
docker compose up -d infra
docker compose exec infra sh
# コンテナ内
cd prod
terraform init
terraform plan
terraform apply
```

クレデンシャル切れ (4h 経過等) で 401/403 が出たら、3.4 から再取得して `infra/.env` を上書き → コンテナ再起動 (`docker compose restart infra`)。
