---
name: plan-and-review
description: >
  Flutter アプリの実装計画を作成し、AIレビューで品質を担保するワークフロー。
  「計画を作って」「plan 作って」「実装計画」「plan-and-review」
  などのキーワードが出たら使用すること。
argument-hint: "[Issue番号 or 要件の概要]"
---

## 概要

実装計画を作成し、独立したレビュワーエージェント（plan-reviewer）による客観的レビューと修正を経て、品質の担保された計画をユーザーに提示するワークフロー。

計画作成からAIレビュー・修正まで一気通貫で実行し、ユーザーが確認するのは「AIレビューを通過した計画」のみ。

## 手順

### 1. 要件の整理

引数として渡された Issue 番号や要件の概要をもとに、要件を整理する。

- Issue 番号が指定された場合は `gh issue view <番号>` で内容を取得する
- 以下を整理する:
  - 実装する機能の概要
  - 画面・操作フロー（該当する場合）
  - API 連携の有無
  - 既存コードへの影響
- 不明点がある場合のみユーザーに確認する（明らかな場合は止めずに進む）

### 2. 計画の作成

以下のスキルを参照しながら、実装計画を作成する。ファイルへの書き出しは不要（コンテキスト内で保持する）。

**参照するスキル:**
- `layered-architecture` — レイヤー構成、依存方向、ディレクトリ構成
- `bloc` — BLoC/Cubit設計、Event/State構成
- `testing` — テスト方針

**計画に含める内容:**

```
# 実装計画: {機能名}

## 要件
- （要件の箇条書き）

## ファイル構成

### 共有層
- `lib/models/xxx.dart` — 説明
- `lib/repositories/xxx_repository.dart` — 説明
- `lib/data_providers/xxx_client.dart` — 説明

### Feature: {feature名}
- `lib/{feature}/bloc/xxx_bloc.dart` — 説明
- `lib/{feature}/bloc/xxx_event.dart` — 説明
- `lib/{feature}/bloc/xxx_state.dart` — 説明
- `lib/{feature}/view/xxx_page.dart` — 説明（BlocProvider配置）
- `lib/{feature}/view/xxx_view.dart` — 説明（BlocBuilder でUI構築）
- `lib/{feature}/widgets/xxx.dart` — 説明

## 依存関係と実装順序
1. （順序付きリスト: models → data_providers → repositories → bloc → view）

## 状態管理設計
- BLoC/Cubit の選択理由
- Event/State の設計概要
- BlocProvider の構成

## テスト方針
- BLoC テスト: blocTest() で状態遷移を検証
- Repository テスト: Data Provider をモックして検証
- ウィジェットテスト: BLoC をモックしてUI表示を検証
```

### 3. AIレビュー

**ユーザーに提示せず**、そのまま Agent ツールで `plan-reviewer` エージェントを呼び出す。

プロンプトに計画の全文を含めて渡す。plan-reviewer は独立したコンテキストで計画を客観評価し、指摘事項を返す。

### 4. 指摘の修正

plan-reviewer から NEEDS_REVISION が返された場合、指摘に基づいて計画を修正する。

- 重要度「高」の指摘は必ず反映する
- 重要度「中」「低」も合理的であれば反映する
- 修正後、再度 plan-reviewer を呼び出して再レビューする（最大2回まで）

### 5. ユーザーへの提示

AIレビューを通過した（APPROVED された）計画をユーザーに提示する。

**提示内容:**
- 計画の全文
- plan-reviewer のレビュー結果サマリー（修正があった場合はその内容も）

ユーザーの判断を仰ぐ:
- **承認**: 次のステップ（`/impl-and-review` での実装）に進む
- **修正要求**: ユーザーのフィードバックに基づいて計画を修正し、必要に応じて再レビュー
