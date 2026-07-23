import '../../models/form_element.dart';
import '../../models/form_section.dart';
import '../adapters/legacy_structure_adapter.dart';
import '../collection/collection_experience.dart';
import '../project/project.dart';
import '../versioning/artifact_version.dart';

/// Domain aggregate -> serializer -> existing Flask/Mongo API boundary
/// (Domain Specification v0.1 section 4, Stage 3).
///
/// Each method here takes domain-only input and must stay byte-for-byte
/// equivalent to the corresponding legacy `BackendPayloadBuilder` method it
/// replaces, until `lib/utils/backend_payload_builder.dart` is retired.
class CollectionExperienceSerializer {
  const CollectionExperienceSerializer._();

  /// Must stay equivalent to legacy BackendPayloadBuilder.buildVersionPayload.
  static Map<String, dynamic> version(ArtifactVersion version) {
    return <String, dynamic>{
      'uuid': version.id,
      'major': version.major,
      'minor': version.minor,
      'patch': version.patch,
      'status': version.status.name,
      'created_by': version.createdBy,
    };
  }

  /// Must stay byte-for-byte equivalent to legacy BackendPayloadBuilder._questionPayload.
  static Map<String, dynamic> question(FormElement element) {
    String? nullString(Object? value) {
      if (value == null) return null;
      final text = value.toString();
      return text.isEmpty ? null : text;
    }

    List<dynamic> listOrEmpty(Object? value) =>
        value is List ? List<dynamic>.from(value) : <dynamic>[];

    Map<String, dynamic> mapOrEmpty(Object? value) =>
        value is Map<String, dynamic>
        ? Map<String, dynamic>.from(value)
        : <String, dynamic>{};

    final questionVersionUuid = '${element.id}_v1';

    return <String, dynamic>{
      'uuid': element.id,
      'versions': <Map<String, dynamic>>[
        version(ArtifactVersion(id: questionVersionUuid)),
      ],
      'type': element.type,
      'label': element.label,
      'placeholder': nullString(element.properties['placeholder']),
      'description': nullString(element.properties['description']),
      'default_value': element.properties.containsKey('defaultValue')
          ? element.properties['defaultValue']
          : null,
      'help_text': null,
      'tooltip': null,
      'validation_conditions': listOrEmpty(
        element.properties['validationConditions'],
      ),
      'validation_condition_messages': mapOrEmpty(
        element.properties['validationConditionMessages'],
      ),
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
      'choices': listOrEmpty(element.properties['options']),
      'hideButton': false,
      'actionIcon': null,
      'status': 'active',
    };
  }

  /// Must stay byte-for-byte equivalent to legacy BackendPayloadBuilder._sectionPayload.
  static Map<String, dynamic> section(FormSection section) {
    final sectionVersionUuid = '${section.id}_v1';
    return <String, dynamic>{
      'uuid': section.id,
      'versions': <Map<String, dynamic>>[
        version(ArtifactVersion(id: sectionVersionUuid)),
      ],
      'questions': <String, dynamic>{
        sectionVersionUuid: section.elements
            .map((element) => question(element))
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

  /// Must stay byte-for-byte equivalent to legacy BackendPayloadBuilder.buildFormPayload.
  static Map<String, dynamic> form(CollectionExperience experience) {
    final sections = LegacyStructureAdapter.sectionsFromExperience(experience);
    return <String, dynamic>{
      'uuid': experience.id,
      'versions': <Map<String, dynamic>>[
        {...version(experience.version), 'status': 'draft'},
      ],
      'sections': <String, dynamic>{
        experience.version.id: sections
            .map((s) => section(s))
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

  /// Must stay equivalent to legacy BackendPayloadBuilder.buildProjectPayload.
  static Map<String, dynamic> project(Project project) {
    return <String, dynamic>{
      'uuid': project.id,
      'name': project.name,
      'versions': <Map<String, dynamic>>[
        {...version(project.version), 'status': 'draft'},
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
}
