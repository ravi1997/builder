import '../models/form_models.dart';

class WorkflowEngine {
  const WorkflowEngine();

  WorkflowStatus next(WorkflowStatus current) {
    switch (current) {
      case WorkflowStatus.draft:
        return WorkflowStatus.submitted;
      case WorkflowStatus.submitted:
        return WorkflowStatus.reviewed;
      case WorkflowStatus.reviewed:
        return WorkflowStatus.approved;
      case WorkflowStatus.approved:
      case WorkflowStatus.rejected:
      case WorkflowStatus.completed:
        return current;
    }
  }
}
