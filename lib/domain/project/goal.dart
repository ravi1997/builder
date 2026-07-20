enum GoalPriority { low, normal, high, critical }

class Goal {
  const Goal({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = GoalPriority.normal,
    this.primary = false,
  });

  final String id;
  final String title;
  final String description;
  final GoalPriority priority;
  final bool primary;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'priority': priority.name,
        'primary': primary,
      };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        priority: GoalPriority.values.byName(
          json['priority'] as String? ?? GoalPriority.normal.name,
        ),
        primary: json['primary'] as bool? ?? false,
      );
}
