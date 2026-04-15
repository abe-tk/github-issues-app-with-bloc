## ADDED Requirements

### Requirement: Issue一覧の取得と表示
システムはGitHub REST APIからIssue一覧を取得し、リスト形式で表示しなければならない（SHALL）。各Issueはtitle、state、ラベル、作成日時を表示する。Pull Requestは一覧から除外しなければならない（MUST）。

#### Scenario: 初回表示でopen状態のIssueを取得する
- **WHEN** ユーザーがIssue一覧画面を開く
- **THEN** open状態のIssueがリストに表示される
- **THEN** Pull Requestは表示されない

#### Scenario: 読み込み中はローディング表示
- **WHEN** Issue一覧をAPIから取得中
- **THEN** ローディングインジケーターが表示される

#### Scenario: Issueが0件の場合
- **WHEN** 条件に合致するIssueが存在しない
- **THEN** 「Issueがありません」のメッセージが表示される

### Requirement: stateによるフィルタリング
ユーザーはIssue一覧をstate（open / closed / all）で切り替えられなければならない（MUST）。

#### Scenario: closed状態に切り替える
- **WHEN** ユーザーがフィルタをclosedに変更する
- **THEN** closed状態のIssueのみが表示される

#### Scenario: all状態に切り替える
- **WHEN** ユーザーがフィルタをallに変更する
- **THEN** open・closed両方のIssueが表示される

### Requirement: ラベルによるフィルタリング
ユーザーはリポジトリに存在するラベルを選択してIssue一覧を絞り込めなければならない（MUST）。ラベル一覧はGitHub APIから取得する。

#### Scenario: ラベルで絞り込む
- **WHEN** ユーザーがラベル「bug」を選択する
- **THEN** 「bug」ラベルが付いたIssueのみが表示される

#### Scenario: ラベルフィルタを解除する
- **WHEN** ユーザーがラベルフィルタを解除する
- **THEN** ラベルによる絞り込みなしでIssue一覧が表示される

### Requirement: ページネーション（無限スクロール）
Issue一覧はページネーションで取得し、ユーザーがリスト末尾までスクロールしたときに自動的に次のページを読み込まなければならない（SHALL）。

#### Scenario: スクロール末尾で次ページを読み込む
- **WHEN** ユーザーがリストの末尾までスクロールする
- **THEN** 次のページのIssueが自動的に読み込まれ、リストに追加される

#### Scenario: 全ページ読み込み完了
- **WHEN** 全てのIssueを読み込み済み
- **THEN** 追加の読み込みは発生しない

### Requirement: APIエラー時のハンドリング
API通信に失敗した場合、ユーザーにエラーメッセージを表示し、再試行の手段を提供しなければならない（MUST）。

#### Scenario: ネットワークエラー発生
- **WHEN** API呼び出しがネットワークエラーで失敗する
- **THEN** エラーメッセージと「再試行」ボタンが表示される
