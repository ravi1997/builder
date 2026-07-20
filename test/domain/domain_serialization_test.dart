import 'package:builder/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final createdAt = DateTime.utc(2026, 7, 20, 10, 30);

  test('project round-trips goals and collection experiences', () {
    final project = Project(
      id: 'project-1',
      name: 'Customer Health',
      version: ArtifactVersion(
        id: 'project-v1',
        status: ArtifactVersionStatus.published,
        createdAt: createdAt,
      ),
      goals: const [
        Goal(
          id: 'goal-1',
          title: 'Improve retention',
          priority: GoalPriority.high,
          primary: true,
        ),
      ],
      experiences: [
        CollectionExperience(
          id: 'experience-1',
          type: CollectionExperienceType.survey,
          version: ArtifactVersion(id: 'experience-v1'),
          schema: const {'question_ids': ['q-satisfaction']},
          presentation: const {'layout': 'classic'},
        ),
      ],
    );

    final restored = Project.fromJson(project.toJson());

    expect(restored.id, project.id);
    expect(restored.goals.single.primary, isTrue);
    expect(restored.experiences.single.type, CollectionExperienceType.survey);
    expect(restored.version.status, ArtifactVersionStatus.published);
    expect(restored.version.createdAt, createdAt);
  });

  test('submission preserves raw answers and experience version', () {
    final submission = Submission(
      id: 'submission-1',
      experienceId: 'experience-1',
      experienceVersionId: 'experience-v1',
      submittedAt: createdAt,
      respondentMetadata: const {'channel': 'web'},
      answers: [
        Answer(
          id: 'answer-1',
          questionId: 'q-satisfaction',
          value: 3,
          capturedAt: createdAt,
        ),
      ],
    );

    final restored = Submission.fromJson(submission.toJson());

    expect(restored.experienceVersionId, 'experience-v1');
    expect(restored.answers.single.questionId, 'q-satisfaction');
    expect(restored.answers.single.value, 3);
  });

  test('data point and projection result preserve provenance and failure state', () {
    final point = DataPoint(
      id: 'datapoint-1',
      definitionId: 'customer-satisfaction',
      value: 3,
      source: const DataSource(
        type: DataSourceType.form,
        id: 'submission-1',
      ),
      observedAt: createdAt,
      confidence: 1,
    );
    final record = DataRecord(
      id: 'record-1',
      projectId: 'project-1',
      entityType: 'Customer',
      dataPoints: [point],
    );
    final rejected = ProjectionResult(
      id: 'projection-1',
      submissionId: 'submission-1',
      answerId: 'answer-1',
      questionId: 'q-satisfaction',
      projectionRuleVersion: 'projection-v1',
      status: ProjectionResultStatus.rejected,
      rejectionCode: 'invalid_type',
      rejectionReason: 'Expected a number',
      createdAt: createdAt,
    );

    final restoredRecord = DataRecord.fromJson(record.toJson());
    final restoredProjection = ProjectionResult.fromJson(rejected.toJson());

    expect(restoredRecord.dataPoints.single.source.id, 'submission-1');
    expect(restoredRecord.dataPoints.single.confidence, 1);
    expect(restoredProjection.status, ProjectionResultStatus.rejected);
    expect(restoredProjection.rejectionCode, 'invalid_type');
  });
}
