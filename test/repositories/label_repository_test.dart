import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/repositories/label_repository.dart';

import '../helpers/mocks.dart';

void main() {
  late MockGithubApiClient mockApiClient;
  late LabelRepository repository;

  setUp(() {
    mockApiClient = MockGithubApiClient();
    repository = LabelRepository(apiClient: mockApiClient);
  });

  group('LabelRepository', () {
    group('getLabels', () {
      test('ラベル一覧をLabelモデルのリストとして返す', () async {
        // Arrange
        when(() => mockApiClient.fetchLabels()).thenAnswer(
          (_) async => [
            {'name': 'bug', 'color': 'fc2929', 'description': 'バグ報告'},
            {'name': 'enhancement', 'color': '84b6eb', 'description': null},
          ],
        );

        // Act
        final labels = await repository.getLabels();

        // Assert
        expect(labels, hasLength(2));
        expect(labels[0].name, equals('bug'));
        expect(labels[1].name, equals('enhancement'));
      });

      test('ラベルが0件の場合は空リストを返す', () async {
        // Arrange
        when(() => mockApiClient.fetchLabels()).thenAnswer((_) async => []);

        // Act
        final labels = await repository.getLabels();

        // Assert
        expect(labels, isEmpty);
      });
    });
  });
}
