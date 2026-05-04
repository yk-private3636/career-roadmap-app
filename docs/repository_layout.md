# リポジトリ構成

ルート直下から見える単位ごとに役割をまとめる。各サービスの内部構成 (`src/` 以下等) は対象外。

## ディレクトリツリー

```
career-roadmap-app/
├── .github/                              # GitHub Actions ワークフロー (CI/CD)
├── api/                                  # API サービス (Go)
├── batch/                                # 定期実行バッチ (Go)
├── job/                                  # キュー駆動ジョブワーカー (Go)
├── web/                                  # フロントエンド (Bun)
├── db/                                   # データベース (PostgreSQL)
├── inmemory/                             # インメモリストア (Redis)
├── proxy/                                # リバースプロキシ (Nginx)
├── observability/                        # 観測性基盤 (local: Jaeger / prod: Datadog Agent)
├── infra/                                # インフラ定義 (Terraform)
├── docs/                                 # プロジェクトドキュメント
├── compose.yml                           # ローカル全体の Docker Compose 定義
├── setup.sh                              # 初回セットアップスクリプト (.env / tfvars 生成)
├── system_architecture_diagram.drawio.png # アーキテクチャ図
├── README.md                             # リポジトリ概要
├── AGENTS.md                             # AI エージェント向けの作業前提・読み込み指示
└── CLAUDE.md                             # Claude Code 用 (AGENTS.md を参照)
```

## 各単位の役割

### アプリケーション層

| ディレクトリ | 役割 | スタック |
|------------|-----|--------|
| `api/` | HTTP API サーバ。フロントからのリクエストを受け、DB / Redis にアクセス | Go |
| `batch/` | スケジュール起動の定期処理 (集計・クリーンアップ等) | Go |
| `job/` | キュー (Redis) 経由で起動する非同期ジョブワーカー | Go |
| `web/` | フロントエンド (SPA) | Bun |

### ミドルウェア層

| ディレクトリ | 役割 | スタック |
|------------|-----|--------|
| `db/` | 永続データストア。`init/` 以下のスキーマを初回起動時に投入 | PostgreSQL |
| `inmemory/` | キャッシュ / キュー用途のインメモリストア | Redis |
| `proxy/` | API リクエストの集約・ルーティング | Nginx |
| `observability/` | トレース / ログ収集基盤。`local` ターゲット = Jaeger、`prod` ターゲット = Datadog Agent でビルドが分岐 | Jaeger / Datadog |

### インフラ・運用層

| ディレクトリ / ファイル | 役割 |
|--------------------|-----|
| `infra/` | AWS リソースを定義する Terraform プロジェクト。環境別に `src/envs/<env>/` で分離 |
| `.github/workflows/` | GitHub Actions の定義。OIDC で AWS にアクセスし、CICDを実行 |
| `compose.yml` | アプリ + ミドルウェア + observability + infra コンテナの起動定義 |
| `setup.sh` | 各サービスの `.env.example` / `terraform.tfvars.example` をコピーして初回セットアップを行う |

### ドキュメント・メタ

| ファイル | 役割 |
|--------|-----|
| `README.md` | リポジトリ概要・背景・アーキテクチャ図表示 |
| `docs/` | 詳細ドキュメント (プロダクト要件 / セットアップ / アーキテクチャ評価 等) |
| `system_architecture_diagram.drawio.png` | アーキテクチャ図の実体 |
| `AGENTS.md` | AI エージェントが作業前に読むべき指示・ドキュメントの動的分岐 |
| `CLAUDE.md` | Claude Code 用エントリ。中身は `AGENTS.md` を参照するだけ |
