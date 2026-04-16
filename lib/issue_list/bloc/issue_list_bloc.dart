import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_list/bloc/issue_list_event.dart';
import 'package:app/issue_list/bloc/issue_list_state.dart';
import 'package:app/models/label.dart';
import 'package:app/repositories/issue_repository.dart';
import 'package:app/repositories/label_repository.dart';

/// Issue一覧画面のBLoC
class IssueListBloc extends Bloc<IssueListEvent, IssueListState> {
  final IssueRepository _issueRepository;
  final LabelRepository _labelRepository;

  static const _perPage = 30;

  IssueListBloc({
    required IssueRepository issueRepository,
    required LabelRepository labelRepository,
  }) : _issueRepository = issueRepository,
       _labelRepository = labelRepository,
       super(const IssueListState()) {
    on<IssueListFetched>(_onFetched);
    on<IssueListNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
    on<IssueListStateFilterChanged>(_onStateFilterChanged);
    on<IssueListLabelFilterChanged>(_onLabelFilterChanged);
  }

  /// 初回取得・再試行
  Future<void> _onFetched(
    IssueListFetched event,
    Emitter<IssueListState> emit,
  ) async {
    emit(state.copyWith(status: IssueListStatus.loading));

    try {
      // Issues と Labels を並行取得
      final (issues, labels) = await (
        _issueRepository.getIssues(
          state: state.stateFilter.toApiValue(),
          label: state.labelFilter,
        ),
        _fetchLabels(),
      ).wait;

      emit(
        state.copyWith(
          status: IssueListStatus.success,
          issues: issues,
          hasReachedMax: issues.length < _perPage,
          availableLabels: labels,
          errorMessage: null,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: IssueListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// 次ページ読み込み（droppable で二重リクエスト防止）
  Future<void> _onNextPageRequested(
    IssueListNextPageRequested event,
    Emitter<IssueListState> emit,
  ) async {
    if (state.hasReachedMax) return;

    final currentPage = (state.issues.length / _perPage).ceil() + 1;

    try {
      final issues = await _issueRepository.getIssues(
        state: state.stateFilter.toApiValue(),
        label: state.labelFilter,
        page: currentPage,
      );

      emit(
        state.copyWith(
          issues: [...state.issues, ...issues],
          hasReachedMax: issues.length < _perPage,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: IssueListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// stateフィルタ変更 → リセットして再取得
  Future<void> _onStateFilterChanged(
    IssueListStateFilterChanged event,
    Emitter<IssueListState> emit,
  ) async {
    emit(
      state.copyWith(
        stateFilter: event.filter,
        issues: [],
        hasReachedMax: false,
        status: IssueListStatus.loading,
      ),
    );

    try {
      final issues = await _issueRepository.getIssues(
        state: event.filter.toApiValue(),
        label: state.labelFilter,
      );

      emit(
        state.copyWith(
          status: IssueListStatus.success,
          issues: issues,
          hasReachedMax: issues.length < _perPage,
          errorMessage: null,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: IssueListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// ラベルフィルタ変更 → リセットして再取得
  Future<void> _onLabelFilterChanged(
    IssueListLabelFilterChanged event,
    Emitter<IssueListState> emit,
  ) async {
    emit(
      state.copyWith(
        labelFilter: event.label,
        issues: [],
        hasReachedMax: false,
        status: IssueListStatus.loading,
      ),
    );

    try {
      final issues = await _issueRepository.getIssues(
        state: state.stateFilter.toApiValue(),
        label: event.label,
      );

      emit(
        state.copyWith(
          status: IssueListStatus.success,
          issues: issues,
          hasReachedMax: issues.length < _perPage,
          errorMessage: null,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: IssueListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// ラベル一覧を取得する。失敗時は空リストを返す（Issue表示は継続）
  Future<List<Label>> _fetchLabels() async {
    try {
      return await _labelRepository.getLabels();
    } on Exception {
      return [];
    }
  }
}
