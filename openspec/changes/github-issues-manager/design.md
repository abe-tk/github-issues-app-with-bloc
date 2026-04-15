## Context

GitHub Issuesを管理するFlutterアプリを新規構築する。現状はFlutterプロジェクトの初期状態（`main.dart`のみ）であり、アーキテクチャはゼロから設計する。BLoCパターンによる状態管理を採用し、GitHub REST API v3と通信する。認証にはPersonal Access Token (PAT)を使い、dart-define-from-fileでコンパイル時に注入する。対象リポジトリもコンパイル定数として固定する。

## Goals / Non-Goals

**Goals:**
- BLoCパターンを用いた明確なレイヤー分離（Presentation / BLoC / Repository / Data Source）
- GitHub REST API v3を利用したIssueのCRUD操作
- フィルタリング・ページネーションを含む実践的なリスト表示
- コメント機能による親子関係データの管理

**Non-Goals:**
- OAuth認証フロー（PATで代替）
- Issueの削除（GitHub APIの制約。closeで代替）
- マイルストーン・アサイン管理
- コメントの編集・削除
- ラベルの作成・編集・削除
- オフラインキャッシュ・ローカルDB
- テストコードの整備（検証実装のため優先度を下げる）

## Decisions

### 1. 状態管理: flutter_bloc

**選択**: `flutter_bloc` パッケージを使用  
**理由**: BLoCパターンの公式推奨実装であり、Event→State の明確なフローで状態遷移を追跡しやすい。学習目的にも適している。  
**代替案**: Riverpod（より軽量だがBLoC学習の目的に合わない）、Provider（BLoCの下位互換）

### 2. HTTPクライアント: http パッケージ

**選択**: `http` パッケージを使用  
**理由**: GitHub REST APIとの通信はシンプルなREST呼び出しのみであり、インターセプター等の高度な機能は不要。Dart公式パッケージで依存が軽い。  
**代替案**: dio（多機能だがこの規模では過剰）

### 3. レイヤー構成

```
lib/
├── main.dart
├── config/                  # コンパイル定数の定義
├── models/                  # データモデル（Issue, Comment, Label）
├── repositories/            # APIアクセスの抽象化
├── blocs/                   # BLoC（Event, State, BLoC本体）
├── screens/                 # 画面ウィジェット
└── widgets/                 # 共通ウィジェット
```

**理由**: BLoCパターンの標準的なレイヤー構成に従い、責務を明確に分離する。  
**代替案**: feature-firstのディレクトリ構成（機能が増えた場合に有利だが、今回は機能数が限定的なためlayer-firstで十分）

### 4. ページネーション方式

**選択**: GitHub APIの`page`/`per_page`パラメータを使用し、スクロール末尾到達時に次ページを取得  
**理由**: GitHub REST APIの標準的なページネーション。Linkヘッダーまたはレスポンスのアイテム数で次ページの有無を判定する。

### 5. コンパイル定数の管理

**選択**: `dart-define-from-file`で`.env`ファイルからPATとリポジトリ情報を注入  
**理由**: シークレットをコードに含めず、ビルド時に注入する安全な方式。`.env`ファイルを`.gitignore`に追加して保護する。

```
# .env
GITHUB_TOKEN=ghp_xxxxxxxxxxxx
GITHUB_OWNER=owner-name
GITHUB_REPO=repo-name
```

## Risks / Trade-offs

- **[PAT漏洩]** → `.env`を`.gitignore`に登録。README にセットアップ手順を記載し、各開発者が自分のPATを使う想定。
- **[APIレート制限]** → 認証済みリクエストは5,000回/時間。通常利用では問題にならない。UIにエラー表示を実装して対処。
- **[Pull RequestがIssues APIに混入]** → GitHub REST APIの`/issues`エンドポイントはPull Requestも返す。`pull_request`フィールドの有無でフィルタリングする。
