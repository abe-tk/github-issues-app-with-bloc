import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/data_providers/github_api_client.dart';
import 'package:app/issue_list/bloc/issue_list_bloc.dart';
import 'package:app/issue_list/bloc/issue_list_event.dart';
import 'package:app/issue_list/bloc/issue_list_state.dart';
import 'package:app/repositories/comment_repository.dart';
import 'package:app/repositories/issue_repository.dart';
import 'package:app/repositories/label_repository.dart';

class MockGithubApiClient extends Mock implements GithubApiClient {}

class MockIssueRepository extends Mock implements IssueRepository {}

class MockCommentRepository extends Mock implements CommentRepository {}

class MockLabelRepository extends Mock implements LabelRepository {}

class MockIssueListBloc extends MockBloc<IssueListEvent, IssueListState>
    implements IssueListBloc {}
