## ADDED Requirements

### Requirement: 新規Issueの作成
ユーザーはtitleとbodyを入力して新しいIssueを作成できなければならない（MUST）。作成はGitHub REST APIのPOSTエンドポイントを使用する。

#### Scenario: 必須項目を入力してIssueを作成する
- **WHEN** ユーザーがtitleを入力し、作成ボタンをタップする
- **THEN** GitHub APIに新しいIssueが作成される
- **THEN** Issue一覧画面に戻り、作成したIssueが一覧に表示される

#### Scenario: bodyは任意入力
- **WHEN** ユーザーがtitleのみ入力しbodyを空のまま作成する
- **THEN** bodyが空のIssueが作成される

### Requirement: 入力バリデーション
titleは必須入力としなければならない（MUST）。titleが空の場合は作成を実行できない。

#### Scenario: titleが空の場合
- **WHEN** ユーザーがtitleを空のまま作成ボタンをタップする
- **THEN** バリデーションエラーが表示され、Issueは作成されない

### Requirement: 作成中のフィードバック
API通信中はユーザーに処理中であることを示し、二重送信を防がなければならない（MUST）。

#### Scenario: 作成処理中の表示
- **WHEN** Issue作成APIを呼び出し中
- **THEN** ローディングインジケーターが表示され、作成ボタンは無効化される

#### Scenario: 作成失敗時
- **WHEN** Issue作成APIがエラーを返す
- **THEN** エラーメッセージが表示され、ユーザーは入力内容を保持したまま再試行できる
