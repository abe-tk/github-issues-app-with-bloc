## ADDED Requirements

### Requirement: PAT認証によるAPI通信
システムはdart-define-from-fileで注入されたPersonal Access Tokenを使用してGitHub REST API v3に認証リクエストを送信しなければならない（MUST）。全てのAPIリクエストにAuthorizationヘッダーを付与する。

#### Scenario: 認証ヘッダーの付与
- **WHEN** GitHub APIにリクエストを送信する
- **THEN** `Authorization: Bearer {PAT}` ヘッダーが含まれる

#### Scenario: PATが未設定の場合
- **WHEN** コンパイル定数にPATが設定されていない
- **THEN** エラーメッセージが表示され、API呼び出しは実行されない

### Requirement: リポジトリ情報のコンパイル定数管理
対象リポジトリのowner名とrepo名はdart-define-from-fileで注入されるコンパイル定数として管理しなければならない（MUST）。

#### Scenario: コンパイル定数からリポジトリ情報を取得する
- **WHEN** APIエンドポイントを構築する
- **THEN** コンパイル定数のGITHUB_OWNERとGITHUB_REPOが使用される

### Requirement: APIエラーハンドリング
HTTP 4xx/5xxレスポンスを適切にハンドリングし、ユーザーに分かりやすいエラー情報を提供しなければならない（MUST）。

#### Scenario: 401 Unauthorized
- **WHEN** APIが401を返す
- **THEN** 認証エラーとしてユーザーに「トークンが無効です」と表示する

#### Scenario: 404 Not Found
- **WHEN** APIが404を返す
- **THEN** 「リポジトリまたはIssueが見つかりません」と表示する

#### Scenario: 422 Validation Error
- **WHEN** APIが422を返す
- **THEN** バリデーションエラーの内容をユーザーに表示する

#### Scenario: ネットワーク接続エラー
- **WHEN** ネットワーク接続に失敗する
- **THEN** 「ネットワークに接続できません」と表示する

### Requirement: APIレスポンスのJSON解析
GitHub APIからのJSONレスポンスをアプリ内のデータモデル（Issue, Comment, Label）に変換しなければならない（MUST）。

#### Scenario: Issue一覧のJSON解析
- **WHEN** Issue一覧APIからJSONレスポンスを受信する
- **THEN** Issueモデルのリストに変換される
- **THEN** pull_requestフィールドを持つアイテムは除外される

#### Scenario: Comment一覧のJSON解析
- **WHEN** コメント一覧APIからJSONレスポンスを受信する
- **THEN** Commentモデルのリストに変換される
