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

### 3. ディレクトリ構成: feature-first

**選択**: feature-first構成を採用  
**理由**: BLoC公式チュートリアル（Flutter Counter, Weather, Todos）が全てfeature-first構成を採用している。公式ではRepository/Data Providerを`packages/`として別パッケージに分離するが、今回の規模では`lib/`内に配置する。  
**代替案**: layer-first（`blocs/`, `screens/`等のレイヤー単位で分割）は公式チュートリアルでは採用されていない

```
lib/
├── main.dart
├── app/                           # アプリ全体の設定
│   └── app.dart
├── config/                        # コンパイル定数の定義
│   └── app_config.dart
├── models/                        # 共有ドメインモデル
│   ├── issue.dart
│   ├── comment.dart
│   └── label.dart
├── repositories/                  # Repository層
│   ├── issue_repository.dart
│   ├── comment_repository.dart
│   └── label_repository.dart
├── data_providers/                # Data Provider層（API通信）
│   └── github_api_client.dart
├── issue_list/                    # feature: Issue一覧
│   ├── bloc/
│   ├── view/
│   ├── widgets/
│   └── issue_list.dart            # バレルファイル
├── issue_detail/                  # feature: Issue詳細
│   ├── bloc/
│   ├── view/
│   ├── widgets/
│   └── issue_detail.dart
├── issue_create/                  # feature: Issue作成
│   ├── bloc/
│   ├── view/
│   └── issue_create.dart
└── issue_update/                  # feature: Issue更新
    ├── bloc/
    ├── view/
    └── issue_update.dart
```

### 4. ページネーション方式

**選択**: GitHub APIの`page`/`per_page`パラメータを使用し、スクロール末尾到達時に次ページを取得  
**理由**: GitHub REST APIの標準的なページネーション。Linkヘッダーまたはレスポンスのアイテム数で次ページの有無を判定する。

### 5. コンパイル定数の管理

**選択**: `dart-define-from-file`で`dart_defines.json`ファイルからPATとリポジトリ情報を注入  
**理由**: シークレットをコードに含めず、ビルド時に注入する安全な方式。`dart_defines.json`ファイルを`.gitignore`に追加して保護する。

```json
// dart_defines.json
{
  "GITHUB_TOKEN": "ghp_xxxxxxxxxxxx",
  "GITHUB_OWNER": "owner-name",
  "GITHUB_REPO": "repo-name"
}
```

## 実装戦略

機能単位でコミット粒度を下げるため、以下の6回に分けて実装する。各回で `/plan-and-review` → `/impl-and-review` → コミット の流れで進める。

| 回 | 範囲 | 確認方法 |
|----|------|---------|
| 1a | 基盤セットアップ + Models | テスト通過 |
| 1b | Data Provider + Repositories | テスト通過 |
| 2 | Feature: issue_list | 画面表示 |
| 3 | Feature: issue_detail | 画面遷移 |
| 4 | Feature: issue_comments | コメント表示・投稿 |
| 5 | Feature: issue_create | 作成画面 |
| 6 | Feature: issue_update + アプリ統合 | 編集画面 + テーマ統一 |

### 補足

- 回1a, 1bは単独では画面として動かないが、テストで品質を担保する
- 回2で初めてアプリとして動作確認が可能になる
- 共有ドメインモデルは `lib/models/` に配置する（BLoC公式チュートリアルに倣う）
- `issue_comments` は独立featureとして `lib/issue_comments/` に配置する

## Risks / Trade-offs

- **[PAT漏洩]** → `dart_defines.json`を`.gitignore`に登録。README にセットアップ手順を記載し、各開発者が自分のPATを使う想定。
- **[APIレート制限]** → 認証済みリクエストは5,000回/時間。通常利用では問題にならない。UIにエラー表示を実装して対処。
- **[Pull RequestがIssues APIに混入]** → GitHub REST APIの`/issues`エンドポイントはPull Requestも返す。`pull_request`フィールドの有無でフィルタリングする。
