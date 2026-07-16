import '../models/form_element.dart';
import '../models/form_section.dart';

class BackendPayloadBuilder {
  const BackendPayloadBuilder._();

  static Map<String, dynamic> buildCurrentSavePreview({
    required List<FormSection> sections,
  }) {
    return buildFormPayload(
      projectUuid: 'project-crud-0001',
      formUuid: 'form-crud-0001',
      formVersionUuid: 'form-v1',
      sections: sections,
    );
  }

  static Map<String, dynamic> buildProjectPayload({
    String projectUuid = 'project-crud-0001',
    String projectName = 'Project CRUD',
  }) {
    return <String, dynamic>{
      'uuid': projectUuid,
      'name': projectName,
      'versions': <Map<String, dynamic>>[
        buildVersionPayload(versionUuid: 'project-v1', status: 'draft'),
      ],
      'admins': <dynamic>[],
      'members': <dynamic>[],
      'viewers': <dynamic>[],
      'forms': <dynamic>[],
      'organizations': <dynamic>[],
      'tags': <dynamic>[],
      'status': 'active',
    };
  }

  static Map<String, dynamic> buildFormPayload({
    required String projectUuid,
    required String formUuid,
    required String formVersionUuid,
    required List<FormSection> sections,
  }) {
    return <String, dynamic>{
      'uuid': formUuid,
      'versions': <Map<String, dynamic>>[
        buildVersionPayload(versionUuid: formVersionUuid, status: 'draft'),
      ],
      'sections': <String, dynamic>{
        formVersionUuid: sections
            .map((section) => _sectionPayload(section))
            .toList(growable: false),
      },
      'editors': <dynamic>[],
      'viewers': <dynamic>[],
      'reviewers': <dynamic>[],
      'approvers': <dynamic>[],
      'submitters': <dynamic>[],
      'requires_reviewer': false,
      'requires_approver': false,
      'min_reviewers_required': 0,
      'min_approvers_required': 0,
      'validation_conditions': <dynamic>[],
      'validation_condition_messages': <String, dynamic>{},
      'child_sections': <dynamic>[],
      'tags': <dynamic>[],
      'icon': null,
      'theme_template_uuid': null,
      'theme_revision_uuid': null,
      'layout_template_uuid': null,
      'layout_revision_uuid': null,
      'ui_overrides': <String, dynamic>{},
      'is_public': false,
      'status': 'active',
    };
  }

  static Map<String, dynamic> buildSectionPayload({
    String sectionUuid = 'section-nested-0001',
    String sectionVersionUuid = 'section-v1-nested',
    bool addButton = true,
    String? title,
    String? description,
  }) {
    return <String, dynamic>{
      'uuid': sectionUuid,
      'versions': <Map<String, dynamic>>[
        buildVersionPayload(versionUuid: sectionVersionUuid, status: 'draft'),
      ],
      'questions': <String, dynamic>{sectionVersionUuid: <dynamic>[]},
      'add_button': addButton,
      'is_repeatable': false,
      'repeatable_condition': null,
      'check_repeat_on': null,
      'min_repeatable_count': null,
      'max_repeatable_count': null,
      'title': title,
      'description': description,
      'isDeleted': false,
      'deletedBy': null,
      'deletedAt': null,
      'deleted_at': null,
      'deleted_by': null,
      'visibility_condition': null,
      'validation_conditions': <dynamic>[],
      'validation_condition_messages': <String, dynamic>{},
      'tags': <dynamic>[],
      'icon': null,
      'status': 'active',
    };
  }

  static Map<String, dynamic> buildQuestionPayload({
    String questionUuid = 'question-nested-0001',
    String questionVersionUuid = 'question-v1-nested',
    String type = 'text',
    String label = 'Question',
    String? placeholder,
    String? description,
    Object? defaultValue,
    Object? helpText,
    Object? tooltip,
    List<dynamic>? validationConditions,
    Map<String, dynamic>? validationConditionMessages,
    List<dynamic>? visibilityConditions,
    bool addButton = false,
    bool isRepeatable = false,
    Object? repeatableCondition,
    Object? checkRepeatOn,
    Object? minRepeatableCount,
    Object? maxRepeatableCount,
    bool isAction = false,
    Object? actionButtonType,
    Object? actionType,
    Object? actionLabel,
    List<dynamic>? actions,
    List<dynamic>? tags,
    List<dynamic>? choices,
    bool hideButton = false,
    Object? actionIcon,
    String status = 'active',
  }) {
    return <String, dynamic>{
      'uuid': questionUuid,
      'versions': <Map<String, dynamic>>[
        buildVersionPayload(versionUuid: questionVersionUuid, status: 'draft'),
      ],
      'type': type,
      'label': label,
      'placeholder': placeholder,
      'description': description,
      'default_value': defaultValue,
      'help_text': helpText,
      'tooltip': tooltip,
      'validation_conditions': validationConditions ?? <dynamic>[],
      'validation_condition_messages': validationConditionMessages ?? <String, dynamic>{},
      'visibility_conditions': visibilityConditions ?? <dynamic>[],
      'add_button': addButton,
      'is_repeatable': isRepeatable,
      'repeatable_condition': repeatableCondition,
      'check_repeat_on': checkRepeatOn,
      'min_repeatable_count': minRepeatableCount,
      'max_repeatable_count': maxRepeatableCount,
      'isAction': isAction,
      'actionButtonType': actionButtonType,
      'actionType': actionType,
      'actionLabel': actionLabel,
      'actions': actions ?? <dynamic>[],
      'tags': tags ?? <dynamic>[],
      'choices': choices ?? <dynamic>[],
      'hideButton': hideButton,
      'actionIcon': actionIcon,
      'status': status,
    };
  }

  static Map<String, dynamic> buildVersionPayload({
    required String versionUuid,
    int major = 1,
    int minor = 0,
    int patch = 0,
    String status = 'draft',
    Object? createdBy,
  }) {
    return <String, dynamic>{
      'uuid': versionUuid,
      'major': major,
      'minor': minor,
      'patch': patch,
      'status': status,
      'created_by': createdBy,
    };
  }

  static Map<String, dynamic> _sectionPayload(FormSection section) {
    final sectionVersionUuid = _stableSectionVersionUuid(section.id);
    return <String, dynamic>{
      'uuid': section.id,
      'versions': <Map<String, dynamic>>[
        buildVersionPayload(versionUuid: sectionVersionUuid),
      ],
      'questions': <String, dynamic>{
        sectionVersionUuid: section.elements
            .map((element) => _questionPayload(element))
            .toList(growable: false),
      },
      'add_button': true,
      'is_repeatable': false,
      'repeatable_condition': null,
      'check_repeat_on': null,
      'min_repeatable_count': null,
      'max_repeatable_count': null,
      'title': section.title,
      'description': null,
      'isDeleted': false,
      'deletedBy': null,
      'deletedAt': null,
      'deleted_at': null,
      'deleted_by': null,
      'visibility_condition': null,
      'validation_conditions': <dynamic>[],
      'validation_condition_messages': <String, dynamic>{},
      'tags': <dynamic>[],
      'icon': null,
      'status': 'active',
    };
  }

  static Map<String, dynamic> _questionPayload(FormElement element) {
    final questionVersionUuid = _stableQuestionVersionUuid(element.id);
    return <String, dynamic>{
      'uuid': element.id,
      'versions': <Map<String, dynamic>>[
        buildVersionPayload(versionUuid: questionVersionUuid),
      ],
      'type': element.type,
      'label': element.label,
      'placeholder': _nullString(element.properties['placeholder']),
      'description': _nullString(element.properties['description']),
      'default_value': element.properties.containsKey('defaultValue')
          ? element.properties['defaultValue']
          : null,
      'help_text': null,
      'tooltip': null,
      'validation_conditions': _listOrEmpty(element.properties['validationConditions']),
      'validation_condition_messages': _mapOrEmpty(element.properties['validationConditionMessages']),
      'visibility_conditions': <dynamic>[],
      'add_button': false,
      'is_repeatable': false,
      'repeatable_condition': null,
      'check_repeat_on': null,
      'min_repeatable_count': null,
      'max_repeatable_count': null,
      'isAction': false,
      'actionButtonType': null,
      'actionType': null,
      'actionLabel': null,
      'actions': <dynamic>[],
      'tags': <dynamic>[],
      'choices': _listOrEmpty(element.properties['options']),
      'hideButton': false,
      'actionIcon': null,
      'status': 'active',
    };
  }

  static String _stableSectionVersionUuid(String sectionId) {
    return '${sectionId}_v1';
  }

  static String _stableQuestionVersionUuid(String questionId) {
    return '${questionId}_v1';
  }

  static String? _nullString(Object? value) {
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }

  static List<dynamic> _listOrEmpty(Object? value) {
    if (value is List) return List<dynamic>.from(value);
    return <dynamic>[];
  }

  static Map<String, dynamic> _mapOrEmpty(Object? value) {
    if (value is Map<String, dynamic>) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }
}
