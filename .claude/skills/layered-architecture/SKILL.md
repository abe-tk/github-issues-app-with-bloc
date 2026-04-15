---
name: layered-architecture
description: BLoCパターンにおけるレイヤードアーキテクチャの実装ガイド。ディレクトリ構成、Repository層、Data Provider層の設計時に使用する。「レイヤー」「アーキテクチャ」「repository」「data source」「ディレクトリ構成」などのキーワードで発動。
autoApply: true
---

# レイヤードアーキテクチャスキル

bloclibrary.dev 公式ドキュメント準拠のレイヤー設計ガイド。

## 3層アーキテクチャ

```
┌──────────────────────────────────┐
│    Presentation Layer            │  ← Widget, Page, View
│    (UI / ユーザー操作)            │
├──────────────────────────────────┤
│    Business Logic Layer          │  ← Bloc / Cubit
│    (状態管理 / ビジネスロジック)    │
├──────────────────────────────────┤
│    Data Layer                    │
│    ┌────────────────────────┐    │
│    │ Repository             │    │  ← データ統合・変換
│    ├────────────────────────┤    │
│    │ Data Provider          │    │  ← 生データ取得（API, DB）
│    └────────────────────────┘    │
└──────────────────────────────────┘
```

## 依存の方向ルール

```
Presentation → Business Logic → Repository → Data Provider
```

- 上位レイヤーが下位レイヤーに依存する（一方向のみ）
- 下位レイヤーは上位レイヤーを知らない
- **同一レイヤー内の兄弟依存は禁止**（Bloc同士の直接参照は不可）

## 各レイヤーの責務

### Presentation Layer
- UIの描画とユーザー操作のハンドリング
- BlocにEventを送信し、Stateの変化でUIを再構築
- **データ層に直接アクセスしてはならない**

### Business Logic Layer（Bloc / Cubit）
- PresentationとDataの橋渡し
- Eventを受け取り、Repositoryと通信して新しいStateを構築
- **他のBlocを直接参照しない**（必要ならRepositoryのストリーム経由）
- コンストラクタ注入されたRepositoryからのみデータを受け取る

### Repository Layer
- 1つ以上のData Providerをラップする**ファサード（窓口）**
- 複数のData Providerからのデータを統合・変換してBlocに渡す
- 各Repositoryは**単一のドメイン**を管理する
- Data Providerの実装詳細を隠蔽し、差し替えを容易にする

### Data Provider Layer
- **生データ（raw data）の提供**を担当する最下層
- API通信、DB操作などの直接的なやり取り
- 汎用的・多目的に設計する
- CRUD操作のシンプルなAPIを公開する

## データの流れ

```
[Widget] ──Event──▶ [Bloc] ──request──▶ [Repository] ──request──▶ [Data Provider]
   ▲                  │                      │                         │
   │                  │                      │                         │
   └──State rebuild── └── State ◀── data ◀──┘ ◀── raw data ◀─────────┘
```

## ディレクトリ構成（feature-first）

公式チュートリアル（Flutter Counter, Weather, Todos）は全てfeature-first構成を採用している。
公式ではRepository/Data Providerを`packages/`として別パッケージに分離するが、
今回の規模では`lib/`内に配置する。

```
lib/
├── main.dart
├── app/                           # アプリ全体の設定
│   └── app.dart
├── config/                        # コンパイル定数（PAT, owner, repo）
│   └── app_config.dart
├── models/                        # 共有ドメインモデル
│   ├── issue.dart
│   ├── comment.dart
│   └── label.dart
├── repositories/                  # Repository層
│   ├── issue_repository.dart
│   └── comment_repository.dart
├── data_providers/                # Data Provider層（API通信）
│   └── github_api_client.dart
├── issue_list/                    # feature: Issue一覧
│   ├── bloc/
│   │   ├── issue_list_bloc.dart
│   │   ├── issue_list_event.dart
│   │   └── issue_list_state.dart
│   ├── view/
│   │   ├── issue_list_page.dart   # BlocProviderを配置
│   │   └── issue_list_view.dart   # BlocBuilderでUI構築
│   ├── widgets/
│   │   └── issue_list_tile.dart
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

### バレルファイル

各featureディレクトリにバレルファイル（`issue_list.dart`等）を置き、外部に公開するクラスをまとめる。
これは公式チュートリアル全てで採用されているパターン。

```dart
// issue_list/issue_list.dart
export 'bloc/issue_list_bloc.dart';
export 'view/issue_list_page.dart';
```

## モデルクラスの設計

- Data Layer に配置する
- 純粋なDartクラス（ライブラリ依存なし）として定義する
- `Equatable` を継承する
- `fromJson` / `toJson` でJSON変換を担う

```dart
class Issue extends Equatable {
  final int number;
  final String title;
  final String? body;
  final String state;
  final List<Label> labels;
  final DateTime createdAt;

  const Issue({
    required this.number,
    required this.title,
    this.body,
    required this.state,
    required this.labels,
    required this.createdAt,
  });

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
    number: json['number'] as int,
    title: json['title'] as String,
    body: json['body'] as String?,
    state: json['state'] as String,
    labels: (json['labels'] as List)
        .map((l) => Label.fromJson(l as Map<String, dynamic>))
        .toList(),
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  @override
  List<Object?> get props => [number, title, body, state, labels, createdAt];
}
```

## Repository の実装パターン

```dart
class IssueRepository {
  final GitHubApiClient _apiClient;

  const IssueRepository({required GitHubApiClient apiClient})
      : _apiClient = apiClient;

  Future<List<Issue>> getIssues({
    required String state,
    String? label,
    int page = 1,
  }) async {
    final rawData = await _apiClient.fetchIssues(
      state: state,
      label: label,
      page: page,
    );
    return rawData
        .where((json) => json['pull_request'] == null)
        .map((json) => Issue.fromJson(json))
        .toList();
  }
}
```

## やってはいけないこと

- WidgetからData Providerを直接呼ばない
- BlocからHTTPリクエストを直接発行しない（Repository経由）
- Repository同士を依存させない
- Bloc同士を直接参照しない
