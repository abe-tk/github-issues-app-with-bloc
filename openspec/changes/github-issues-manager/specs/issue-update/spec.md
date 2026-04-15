## ADDED Requirements

### Requirement: Issueのtitleとbodyの編集
ユーザーは既存IssueのtitleとbodyをIssue編集画面から変更できなければならない（MUST）。変更はGitHub REST APIのPATCHエンドポイントを使用する。

#### Scenario: titleを変更する
- **WHEN** ユーザーが編集画面でtitleを変更し、保存ボタンをタップする
- **THEN** GitHub APIでIssueのtitleが更新される
- **THEN** Issue詳細画面に戻り、更新されたtitleが表示される

#### Scenario: bodyを変更する
- **WHEN** ユーザーが編集画面でbodyを変更し、保存ボタンをタップする
- **THEN** GitHub APIでIssueのbodyが更新される

### Requirement: Issueのopen/close切り替え
ユーザーはIssueのstateをopen/closedに切り替えられなければならない（MUST）。

#### Scenario: IssueをCloseする
- **WHEN** ユーザーがopen状態のIssue詳細画面でCloseボタンをタップする
- **THEN** IssueのstateがclosedにAPIで更新される
- **THEN** 画面上のstate表示がclosedに変わる

#### Scenario: IssueをReopenする
- **WHEN** ユーザーがclosed状態のIssue詳細画面でReopenボタンをタップする
- **THEN** IssueのstateがopenにAPIで更新される
- **THEN** 画面上のstate表示がopenに変わる

### Requirement: 編集時の入力バリデーション
titleは必須入力としなければならない（MUST）。

#### Scenario: titleを空にして保存する
- **WHEN** ユーザーが編集画面でtitleを空にして保存ボタンをタップする
- **THEN** バリデーションエラーが表示され、更新は実行されない

### Requirement: 更新中のフィードバック
API通信中はユーザーに処理中であることを示し、二重送信を防がなければならない（MUST）。

#### Scenario: 更新処理中の表示
- **WHEN** Issue更新APIを呼び出し中
- **THEN** ローディングインジケーターが表示され、保存ボタンは無効化される

#### Scenario: 更新失敗時
- **WHEN** Issue更新APIがエラーを返す
- **THEN** エラーメッセージが表示され、ユーザーは編集内容を保持したまま再試行できる
