# A.D.I.Y.O.G.I Domain Specification v0.1

Status: architectural baseline

This document defines the first domain boundary for A.D.I.Y.O.G.I and its integration with the existing Flask/Mongo form backend. It is a design specification, not an implementation plan for rewriting the current builders or backend.

## 1. Purpose and principles

A.D.I.Y.O.G.I turns intent into structured data, interpretable signals, and explainable insight.

```text
Goal
  -> Knowledge
  -> Collection Experience
  -> Submission
  -> Projection
  -> Data Points
  -> Transformations
  -> Signals
  -> Insights
  -> Decisions or Actions
```

The governing invariants are:

- AI proposes; humans approve; domain artifacts execute.
- Collection events and raw answers are immutable.
- Intelligence is derived and can be recomputed.
- Every derived result has provenance and lineage.
- Published definitions are versioned and reproducible.
- Existing backend contracts remain compatible during migration.

## 2. System boundary

The primary backend authority is `/home/ravi/workspace/new/form`, a Flask/OpenAPI3 service using MongoEngine and MongoDB. It remains the system of record for organizations, users, projects, forms, sections, questions, conditions, responses, versions, workflow, and publication-related UI configuration.

The A.D.I.Y.O.G.I domain is introduced as an extension layer:

```text
Existing Flask/Mongo form service
  -> adapter and projection boundary
       -> A.D.I.Y.O.G.I knowledge, data, and intelligence contexts
```

The older or parallel backend repositories are comparison/legacy systems until explicitly promoted.

## 3. Core bounded contexts

```text
Organization
  -> Project
       -> Goals
       -> Knowledge references
       -> Collection Experiences
       -> Data Records
       -> Intelligence Workflows
       -> Publications
```

### Project and goals

`Project` remains the problem-space boundary. An eventual `Organization` or workspace owns projects.

Projects may have multiple goals with one optional primary goal. A goal records why the project exists and can reference concepts, data definitions, collection experiences, and intelligence workflows.

### Knowledge

Knowledge is reusable but explicitly versioned:

```text
Platform Knowledge Library
  -> Organization Knowledge Library
       -> Project-pinned reference
```

There is no automatic rebase. A project remains on its pinned version until a human compares and accepts an update.

Knowledge entities:

- `Concept`: a reusable thing the system understands.
- `DataPointDefinition`: a typed observable value associated with a concept.
- `KnowledgeModel`: a versioned package of concepts, data definitions, transformations, and signal definitions.

### Collection

`CollectionExperience` replaces `Form` as the product-level UI concept, while existing `Form` remains the backend compatibility entity.

```text
CollectionExperience
  -> ExperienceVersion
       -> Form structure
       -> Presentation configuration
       -> Validation configuration
       -> Source mappings
```

Experience types may include `form`, `survey`, `assessment`, `import`, `api`, and `integration`.

The current builders remain separate routes:

```text
Form Structure Editor
  -> sections, questions, choices, conditions

Experience Design Editor
  -> layout, theme, components, animation
```

Both eventually edit the same `CollectionExperience` aggregate.

### Data

The data model preserves both raw events and normalized project data:

```text
Submission
  -> Answer
       -> Projection
            -> DataRecord
                 -> DataPoint
```

- `Submission` is the immutable collection event.
- `Answer` is the raw value captured for a question or input definition.
- `DataRecord` is a project-level entity or observation.
- `DataPoint` is a normalized, typed observation with provenance.
- `DataPointDefinition` is the semantic contract for a data point.
- `ProjectionResult` records the outcome of mapping a submission answer into a data point, including successful, rejected, and failed outcomes.

### Intelligence

- `TransformationDefinition` computes values without assigning business meaning.
- `TransformationExecution` records one execution and its inputs/outputs.
- `SignalDefinition` interprets values into meaningful states.
- `SignalResult` records a signal evaluation and its lineage.
- `Insight` explains evidence and may include recommendations.

```text
Transformation: churn_probability = 0.78
Signal: churn_risk = high when churn_probability > 0.70
Insight: explain why risk increased and recommend an action
```

### Publication

`Publication` is the boundary between editing and runtime use. A publication pins an experience version and, when applicable, the versions of knowledge and intelligence definitions used by the published workflow.

Possible publication types include `web`, `embed`, `mobile`, and `api`.

## 4. Backend integration mappings

Initial adapters should map existing backend entities into domain interfaces without changing their storage contracts:

| Existing backend | Domain interpretation |
| --- | --- |
| `Project` | `Project` |
| `Form` | `CollectionExperience` of type `form` |
| Form version | `ExperienceVersion` |
| `Section` | Section definition |
| `Question` | `QuestionDefinition` |
| `Choice` | Choice definition |
| `Condition` | Validation, visibility, transformation, or signal rule candidate |
| `FormResponse` | `Submission` |
| `ResponseItem` | `Answer` |
| Existing `Version` | Base for `ArtifactVersion` |
| Theme/layout template revision | Presentation artifact revision |

The domain serializer, not a UI provider, becomes the future boundary for API payloads:

```text
Editor state
  -> domain aggregate
       -> adapter/serializer
            -> existing API contract
```

## 5. Condition to SignalRule adapter

The existing condition engine remains the deterministic execution layer. A `SignalDefinition` may reference a `SignalRule` whose executable predicate is represented by an existing `Condition` tree.

```text
SignalDefinition
  -> SignalRule
       -> condition_uuid
            -> Condition tree / DSL
                 -> existing ConditionEvaluator
```

The adapter must preserve the distinction between value production and interpretation:

```text
Transformation output: churn_probability = 0.78
Condition tree: churn_probability > 0.70
Signal result: churn_risk = high
```

Mapping rules:

1. A leaf `Condition` maps a data-point or transformation-output reference to an operator and operands.
2. A logical `Condition` maps `AND`/`OR` composition to a signal rule tree.
3. `targetField` resolves through a stable `DataPointDefinition.id` or transformation output id, never a question index.
4. `expression`, `operator`, `operands`, negation, priority, and stop-evaluation behavior remain owned by the backend condition model.
5. Signal metadata supplies the semantic output: signal id, value mapping, severity, and explanation metadata.
6. The adapter records the exact condition UUID and condition version used by each `SignalResult`.
7. AI may propose a condition tree, but it cannot execute until approved and versioned.

The first adapter should support existing comparison, logical, set, temporal, arithmetic, regex, and safe DSL condition types. Unsupported condition types must fail explicitly rather than being approximated.

## 6. ArtifactVersion and existing Version

The backend already has an embedded `Version` model with UUID, semantic major/minor/patch values, creator/updater fields, timestamps, and status. A.D.I.Y.O.G.I must extend that meaning rather than create a parallel generic version scheme.

Conceptually:

```text
Artifact
  -> ArtifactVersion
       -> existing Version-compatible identity and status
       -> lineage and approval metadata
```

`ArtifactVersion` adds domain-level metadata where the existing model does not provide it:

```text
ArtifactVersion
  id / uuid
  artifact_type
  major, minor, patch
  status: draft | review | approved | published | deprecated | archived
  created_by, created_at
  updated_by, updated_at
  approved_by, approved_at
  parent_version_id
  dependency_versions[]
  source_proposal_id?
  changelog
```

Rules:

- Existing Project/Form/Section/Question versions remain compatible with current API behavior.
- New KnowledgeModels, Transformations, SignalDefinitions, and CollectionExperiences use the same identity/status semantics.
- A published artifact is immutable; changes create a new version.
- A project pins dependency versions explicitly.
- Deprecating or archiving a dependency does not invalidate or silently stop a dependent artifact: the dependent remains executable against its pinned version, while publication of new dependent versions requires migration to an approved non-deprecated dependency.
- Runtime results store the definition versions used, but are not themselves mutable definitions.
- `Insight` results are immutable observations; reusable insight templates may be versioned artifacts.

## 7. Submission and projection contract

The existing response API provides the initial ingestion contract.

```text
POST /api/v1/projects/{project_uuid}/forms/{form_uuid}/responses
POST /api/v1/public/projects/{project_uuid}/forms/{form_uuid}/responses
```

The adapter creates:

```text
FormResponse
  -> Submission
       experience_id = form_uuid
       experience_version_id = form_version_uuid

ResponseItem
  -> Answer
       question_id = question_uuid
```

Projection rules map question/input ids to stable `DataPointDefinition` ids:

```text
Answer(question_customer_satisfaction, 3)
  -> ProjectionRule v1
       -> DataPoint(customer_satisfaction_score, 3)
```

Projection is repeatable and must record:

- source submission id
- source answer id/question id
- projection-rule version
- target data-point definition id
- observed and projected timestamps
- confidence, if applicable
- validation or rejection reason

Each attempted mapping produces a queryable `ProjectionResult`:

```text
ProjectionResult
  id
  submission_id
  answer_id / question_id
  projection_rule_version
  status: projected | rejected | failed
  data_point_id?
  rejection_code?
  rejection_reason?
  created_at
```

Rejected or failed projections do not create a `DataPoint`, but they remain available for diagnostics, metrics, correction, and reprocessing. A projection worker must be idempotent for the same submission, answer, and projection-rule version.

Reprocessing never mutates the original submission or answer. It creates a new projection result or a new derived data-point version.

## 8. Response retrieval and GAP-001

Current status in the primary backend:

- Authenticated response creation: closed.
- Public response creation: closed.
- Authenticated response list/detail retrieval: still open.
- Anonymous response retrieval: unsupported by default.

When retrieval endpoints are added, they must support the intelligence pipeline from the beginning:

```text
GET /projects/{project}/forms/{form}/responses
GET /projects/{project}/forms/{form}/responses/{response}
```

Required capabilities include:

- cursor or stable page-based pagination
- date/time range filtering
- form-version filtering
- submission status filtering
- deterministic ordering
- project/form authorization
- optional projection status filtering

Public retrieval remains closed unless a product requirement explicitly introduces respondent access.

## 9. Provenance and lineage

Every derived object must answer:

```text
What created it?
Which definition version was used?
Which inputs were used?
When was it produced?
Who approved the definition?
What confidence or execution status applies?
```

The lineage chain is:

```text
Insight
  -> SignalResult
       -> TransformationExecution
            -> DataPoint
                 -> ProjectionResult
                      -> Answer
                           -> Submission
                                -> ExperienceVersion
```

`ProvenanceRecord` should store source type, source id, definition/version references, timestamps, and optional model/prompt metadata for AI-assisted artifacts.

## 10. AI governance

AI is an authoring and interpretation layer, not an execution authority.

```text
AI proposal
  -> human review
       -> approved versioned artifact
            -> deterministic execution
```

AI proposals must preserve, where applicable:

- model identifier
- prompt or task context
- input references
- generated timestamp
- proposed artifact
- confidence
- approval status
- approving actor

Unapproved proposals cannot participate in published execution.

## 11. Flutter migration map

The current Flutter repository remains a prototype client during migration.

| Current file/module | Domain role |
| --- | --- |
| `lib/models/form_element.dart` | Question definition adapter |
| `lib/models/form_section.dart` | Section definition adapter |
| `lib/providers/form_builder_provider.dart` | Form structure editor adapter |
| `lib/widgets/component_library.dart` | Collection component palette |
| `lib/widgets/canvas.dart` | Collection structure editor |
| `lib/widgets/properties_panel.dart` | Question/section property editor |
| `lib/new_form_builder/models/form_schema.dart` | Temporary experience schema adapter |
| `lib/new_form_builder/models/form_layout_config.dart` | Presentation configuration |
| `lib/new_form_builder/models/form_theme_config.dart` | Presentation theme |
| `lib/new_form_builder/models/component_style_config.dart` | Component presentation configuration |
| `lib/new_form_builder/models/animation_config.dart` | Presentation animation configuration |
| `lib/new_form_builder/providers/form_builder_provider.dart` | Experience design editor adapter |
| `lib/utils/backend_payload_builder.dart` | Transitional domain/API serializer; retired after Stage 3 serializer parity is verified |

Do not delete either builder initially. Introduce domain interfaces and adapters first, then move save/export boundaries from provider state to domain aggregates.

## 12. Staged implementation plan

### Stage 0: Freeze and document

- Freeze new feature expansion in both builders.
- Keep current tests and payload behavior intact.
- Record the backend route and model contract.

### Stage 1: Domain skeleton

Add serialization-focused domain models without changing UI behavior:

```text
lib/domain/project/
lib/domain/knowledge/
lib/domain/collection/
lib/domain/data/
lib/domain/intelligence/
lib/domain/publishing/
```

Start with `Project`, `Goal`, `CollectionExperience`, `Submission`, `Answer`, `DataPointDefinition`, `DataRecord`, and `DataPoint`.

### Stage 2: Adapters

Map the legacy builder and new design builder into the shared collection-experience representation. Preserve separate UI routes.

### Stage 3: Serializer boundary

Replace provider-specific payload construction with:

```text
domain aggregate -> serializer -> existing Flask/Mongo API
```

After the new serializer produces equivalent verified payloads for all supported save/export variants, retire `lib/utils/backend_payload_builder.dart` rather than maintaining two serialization paths.

### Stage 4: Projection

Implement:

```text
FormResponse -> Submission -> Projection -> DataPoint
```

Add idempotency, provenance, version references, and reprocessing behavior.

### Stage 5: Intelligence execution

Adapt existing conditions into SignalRules, execute approved transformations/signals, and persist results with lineage.

### Stage 6: AI assistance

Add proposal generation only after domain artifacts, approval states, and deterministic execution are stable.

## 13. Non-goals for v0.1

- Replacing the Flask/Mongo backend
- Merging the two Flutter builder screens
- Introducing a separate intelligence microservice
- Building a knowledge marketplace
- Adding AI generation
- Adding collaboration features
- Exposing public response retrieval
- Replacing the existing condition evaluator

The purpose of v0.1 is to establish stable domain ownership, integration boundaries, lineage, and migration sequencing.
