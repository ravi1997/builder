enum QuestionType {
  text,
  email,
  number,
  dropdown,
  radio,
  checkbox,
  date,
  fileUpload,
  longText,
}

class FormQuestion {
  final String id;
  final String label;
  final QuestionType type;
  final List<String>? options;
  final bool required;
  final String? placeholder;
  final String? dependencyFieldId;
  final dynamic dependencyValue;

  const FormQuestion({
    required this.id,
    required this.label,
    required this.type,
    this.options,
    this.required = false,
    this.placeholder,
    this.dependencyFieldId,
    this.dependencyValue,
  });
}

class FormSection {
  final String id;
  final String title;
  final String description;
  final List<FormQuestion> questions;

  const FormSection({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });
}

class FormSchema {
  final String title;
  final String description;
  final List<FormSection> sections;

  const FormSchema({
    required this.title,
    required this.description,
    required this.sections,
  });

  static FormSchema get mock {
    return const FormSchema(
      title: 'Employee Registration',
      description: 'Design workspace preview form capture.',
      sections: [
        FormSection(
          id: 'personal',
          title: 'Personal Information',
          description: 'Basic identity details',
          questions: [
            FormQuestion(
              id: 'full_name',
              label: 'Full Name',
              type: QuestionType.text,
              required: true,
              placeholder: 'Enter your legal full name',
            ),
            FormQuestion(
              id: 'dob',
              label: 'Date of Birth',
              type: QuestionType.date,
              required: true,
            ),
            FormQuestion(
              id: 'gender',
              label: 'Gender',
              type: QuestionType.radio,
              options: ['Male', 'Female', 'Non-binary', 'Prefer not to say'],
            ),
          ],
        ),
        FormSection(
          id: 'contact',
          title: 'Contact Details',
          description: 'Communication channels',
          questions: [
            FormQuestion(
              id: 'email',
              label: 'Email Address',
              type: QuestionType.email,
              required: true,
              placeholder: 'name@domain.com',
            ),
            FormQuestion(
              id: 'salary_expectation',
              label: 'Salary Expectation (k\$)',
              type: QuestionType.number,
              required: false,
              placeholder: '120',
            ),
          ],
        ),
        FormSection(
          id: 'address',
          title: 'Address',
          description: 'Physical location details',
          questions: [
            FormQuestion(
              id: 'street',
              label: 'Street Address',
              type: QuestionType.text,
              placeholder: '123 Main St, Apt 4B',
            ),
            FormQuestion(
              id: 'city',
              label: 'City',
              type: QuestionType.text,
            ),
            FormQuestion(
              id: 'zip',
              label: 'Zip Code',
              type: QuestionType.text,
            ),
          ],
        ),
        FormSection(
          id: 'employment',
          title: 'Employment Details',
          description: 'Current occupation history',
          questions: [
            FormQuestion(
              id: 'occupation',
              label: 'Current Occupation',
              type: QuestionType.dropdown,
              options: ['Software Engineer', 'Product Manager', 'Designer', 'Student', 'Other'],
            ),
            FormQuestion(
              id: 'experience',
              label: 'Years of Experience',
              type: QuestionType.dropdown,
              options: ['0-2 years', '3-5 years', '5-10 years', '10+ years'],
            ),
          ],
        ),
        FormSection(
          id: 'preferences',
          title: 'Preferences',
          description: 'System notification setup',
          questions: [
            FormQuestion(
              id: 'newsletter',
              label: 'Subscribe to newsletter updates',
              type: QuestionType.checkbox,
            ),
            FormQuestion(
              id: 'notif_channel',
              label: 'Preferred notification channel',
              type: QuestionType.radio,
              options: ['Email', 'SMS', 'Push Notifications'],
            ),
          ],
        ),
        FormSection(
          id: 'documents',
          title: 'Documents',
          description: 'Identity verification files',
          questions: [
            FormQuestion(
              id: 'has_id',
              label: 'I have a government issued ID card',
              type: QuestionType.checkbox,
              required: true,
            ),
            FormQuestion(
              id: 'id_type',
              label: 'Select ID Type',
              type: QuestionType.dropdown,
              options: ['Passport', 'Driver License', 'National ID'],
              dependencyFieldId: 'has_id',
              dependencyValue: true,
            ),
            FormQuestion(
              id: 'id_file',
              label: 'Upload ID Document',
              type: QuestionType.fileUpload,
              required: true,
              dependencyFieldId: 'has_id',
              dependencyValue: true,
            ),
          ],
        ),
        FormSection(
          id: 'review',
          title: 'Review & Verify',
          description: 'Acknowledge information correctness',
          questions: [
            FormQuestion(
              id: 'cover_letter',
              label: 'Cover Letter / Bio Notes',
              type: QuestionType.longText,
              placeholder: 'Tell us about yourself...',
            ),
            FormQuestion(
              id: 'agree_terms',
              label: 'I certify that the information provided is accurate and true.',
              type: QuestionType.checkbox,
              required: true,
            ),
          ],
        ),
      ],
    );
  }
}
