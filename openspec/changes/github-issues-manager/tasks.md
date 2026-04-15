## 1. プロジェクト基盤セットアップ

- [ ] 1.1 flutter_bloc, http, flutter_markdown 等の依存パッケージをpubspec.yamlに追加
- [ ] 1.2 ディレクトリ構成を作成（config, models, repositories, blocs, screens, widgets）
- [ ] 1.3 dart-define-from-file用のdart_defines.jsonファイルテンプレートと.gitignore設定を追加
- [ ] 1.4 コンパイル定数の定義（GITHUB_TOKEN, GITHUB_OWNER, GITHUB_REPO）をconfig/に実装

## 2. データモデル

- [ ] 2.1 Issueモデルの作成（title, body, state, number, labels, createdAt, pullRequest）
- [ ] 2.2 Commentモデルの作成（body, user, createdAt）
- [ ] 2.3 Labelモデルの作成（name, color, description）

## 3. API通信基盤（github-api）

- [ ] 3.1 GitHub APIクライアントの作成（PAT認証ヘッダー、ベースURL構築）
- [ ] 3.2 APIエラーハンドリングの実装（401, 404, 422, ネットワークエラー）
- [ ] 3.3 Issue用Repository（一覧取得、詳細取得、作成、更新）の実装
- [ ] 3.4 Comment用Repository（一覧取得、投稿）の実装
- [ ] 3.5 Label用Repository（一覧取得）の実装

## 4. Issue一覧機能（issue-list）

- [ ] 4.1 IssueList BLoCの作成（Event: 取得, フィルタ変更, 次ページ読み込み / State: loading, loaded, error）
- [ ] 4.2 Issue一覧画面の作成（リスト表示、各Issueのtitle・state・ラベル・作成日時）
- [ ] 4.3 stateフィルタ（open/closed/all）の切り替えUIと連携
- [ ] 4.4 ラベルフィルタのUIと連携（ラベル一覧取得、選択、絞り込み）
- [ ] 4.5 無限スクロール（ページネーション）の実装
- [ ] 4.6 Pull Requestの除外フィルタリング
- [ ] 4.7 空リスト・ローディング・エラー状態の表示

## 5. Issue詳細機能（issue-detail）

- [ ] 5.1 IssueDetail BLoCの作成（Event: 取得 / State: loading, loaded, error）
- [ ] 5.2 Issue詳細画面の作成（title, body, state, ラベル, 作成日時の表示）
- [ ] 5.3 bodyのMarkdownレンダリング
- [ ] 5.4 編集画面への遷移ボタン

## 6. Issue作成機能（issue-create）

- [ ] 6.1 IssueCreate BLoCの作成（Event: 作成 / State: initial, submitting, success, error）
- [ ] 6.2 Issue作成画面の作成（title入力、body入力、作成ボタン）
- [ ] 6.3 入力バリデーション（title必須）の実装
- [ ] 6.4 作成成功後のIssue一覧画面への遷移と一覧の更新

## 7. Issue更新機能（issue-update）

- [ ] 7.1 IssueUpdate BLoCの作成（Event: 更新 / State: initial, submitting, success, error）
- [ ] 7.2 Issue編集画面の作成（title・body編集、保存ボタン）
- [ ] 7.3 入力バリデーション（title必須）の実装
- [ ] 7.4 Issue詳細画面でのOpen/Closeトグルボタンの実装
- [ ] 7.5 更新成功後の詳細画面への反映

## 8. コメント機能（issue-comments）

- [ ] 8.1 Comment BLoCの作成（Event: 取得, 投稿 / State: loading, loaded, posting, error）
- [ ] 8.2 Issue詳細画面内のコメント一覧表示（body, 作成者名, 作成日時）
- [ ] 8.3 コメント投稿フォーム（入力欄、送信ボタン、空入力ガード）
- [ ] 8.4 投稿成功後のコメント一覧の更新

## 9. アプリ統合・画面遷移

- [ ] 9.1 MaterialAppのルーティング設定（一覧→詳細→編集、一覧→作成）
- [ ] 9.2 BlocProviderの設定と依存注入の構成
- [ ] 9.3 アプリ全体のテーマ・スタイル設定
