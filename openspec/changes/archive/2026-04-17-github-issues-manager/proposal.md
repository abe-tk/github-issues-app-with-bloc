## Why

GitHub Issuesの管理をモバイルから手軽に行えるFlutterアプリを構築する。BLoCパターンによる状態管理の検証実装を兼ねており、フィルタリングやコメント機能など複数の状態が連動する実践的なユースケースを通じてBLoCの理解を深める。

## What Changes

- GitHub REST API v3を利用したIssue CRUD機能の実装
- Issue一覧画面（state/ラベルによるフィルタリング、無限スクロール）
- Issue詳細画面（メタ情報の閲覧、コメント一覧・投稿）
- Issue作成・編集画面（title, body, stateの変更）
- PATによる認証（dart-define-from-fileでコンパイル定数として注入）
- 対象リポジトリはコンパイル定数で固定

## Capabilities

### New Capabilities

- `issue-list`: Issue一覧の取得・表示。state(open/closed/all)切り替え、ラベルフィルタリング、ページネーション（無限スクロール）を含む
- `issue-detail`: Issue詳細情報の表示。title, body, state, ラベル, 作成日時などのメタ情報を閲覧する
- `issue-create`: 新規Issueの作成。title, bodyを入力して作成する
- `issue-update`: 既存Issueの更新。title, body, state(open/close)を変更する
- `issue-comments`: Issueに紐づくコメントの一覧取得と新規コメントの投稿
- `github-api`: GitHub REST API v3との通信基盤。PAT認証、HTTPクライアント、エラーハンドリングを含む

### Modified Capabilities

（既存のcapabilityはないため該当なし）

## Impact

- **依存パッケージ**: flutter_bloc, http（またはdio）等の追加が必要
- **ビルド設定**: dart-define-from-fileによるPAT・リポジトリ情報の注入設定
- **API**: GitHub REST API v3の以下のエンドポイントを使用
  - `GET /repos/{owner}/{repo}/issues` — Issue一覧
  - `GET /repos/{owner}/{repo}/issues/{number}` — Issue詳細
  - `POST /repos/{owner}/{repo}/issues` — Issue作成
  - `PATCH /repos/{owner}/{repo}/issues/{number}` — Issue更新
  - `GET /repos/{owner}/{repo}/labels` — ラベル一覧
  - `GET /repos/{owner}/{repo}/issues/{number}/comments` — コメント一覧
  - `POST /repos/{owner}/{repo}/issues/{number}/comments` — コメント追加
