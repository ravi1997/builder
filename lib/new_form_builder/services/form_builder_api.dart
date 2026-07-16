import '../models/form_models.dart';

abstract class FormBuilderApi {
  Future<void> recordAuditEntry(AuditEntry entry);
  Future<void> recordFieldHistory(FieldHistoryEntry entry);
  Future<Map<String, dynamic>> fetchAnalytics(String formId);
  Future<VerificationStatus> verifyData(String fieldId, Object? value);
}

class MockFormBuilderApi implements FormBuilderApi {
  final List<AuditEntry> auditLog = [];
  final List<FieldHistoryEntry> history = [];

  @override
  Future<void> recordAuditEntry(AuditEntry entry) async => auditLog.add(entry);

  @override
  Future<void> recordFieldHistory(FieldHistoryEntry entry) async => history.add(entry);

  @override
  Future<Map<String, dynamic>> fetchAnalytics(String formId) async => {
        'formId': formId,
        'completionRate': 0.92,
        'dropOffPoints': <String>[],
        'fieldUsage': <String, int>{},
      };

  @override
  Future<VerificationStatus> verifyData(String fieldId, Object? value) async => VerificationStatus.pending;
}
