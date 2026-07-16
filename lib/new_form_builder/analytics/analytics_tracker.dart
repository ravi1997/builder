import '../models/form_models.dart';

class AnalyticsTracker {
  const AnalyticsTracker();

  AnalyticsEvent record(String name, {Map<String, dynamic> payload = const {}}) {
    return AnalyticsEvent(name: name, timestamp: DateTime.now(), payload: payload);
  }
}
