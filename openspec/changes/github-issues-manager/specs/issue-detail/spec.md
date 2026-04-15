## ADDED Requirements

### Requirement: Issue詳細情報の表示
システムはIssue番号を指定してGitHub REST APIから詳細情報を取得し、画面に表示しなければならない（SHALL）。表示する情報はtitle、body、state、ラベル、作成日時とする。

#### Scenario: Issue詳細画面を表示する
- **WHEN** ユーザーがIssue一覧からIssueをタップする
- **THEN** そのIssueのtitle、body、state、ラベル、作成日時が詳細画面に表示される

#### Scenario: bodyがMarkdownの場合
- **WHEN** IssueのbodyにMarkdownが含まれている
- **THEN** bodyはMarkdownとしてレンダリングされる

#### Scenario: 読み込み中はローディング表示
- **WHEN** Issue詳細をAPIから取得中
- **THEN** ローディングインジケーターが表示される

### Requirement: 詳細画面からの操作導線
Issue詳細画面から編集画面への遷移、コメント一覧の表示が可能でなければならない（MUST）。

#### Scenario: 編集画面への遷移
- **WHEN** ユーザーが詳細画面で編集ボタンをタップする
- **THEN** Issue編集画面に遷移する

#### Scenario: コメントセクションの表示
- **WHEN** ユーザーがIssue詳細画面を表示する
- **THEN** コメント一覧がIssue詳細の下部に表示される
