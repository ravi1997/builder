import 'package:flutter/material.dart';

class FieldCategory {
  const FieldCategory({required this.name, required this.items});

  final String name;
  final List<FieldItem> items;
}

class FieldItem {
  const FieldItem({required this.type, required this.label, required this.icon});

  final String type;
  final String label;
  final IconData icon;
}

const List<FieldCategory> fieldCategories = <FieldCategory>[
  FieldCategory(
    name: 'Core Answer Fields',
    items: [
      FieldItem(type: 'text', label: 'Text', icon: Icons.short_text),
      FieldItem(type: 'textarea', label: 'Textarea', icon: Icons.notes),
      FieldItem(type: 'integer', label: 'Integer', icon: Icons.pin),
      FieldItem(type: 'decimal', label: 'Decimal', icon: Icons.calculate_outlined),
      FieldItem(type: 'boolean', label: 'Boolean', icon: Icons.toggle_on),
      FieldItem(type: 'radio', label: 'Radio', icon: Icons.radio_button_checked),
      FieldItem(type: 'checkbox', label: 'Checkbox', icon: Icons.check_box),
      FieldItem(type: 'dropdown', label: 'Dropdown', icon: Icons.arrow_drop_down_circle),
      FieldItem(type: 'date', label: 'Date', icon: Icons.event),
      FieldItem(type: 'datetime', label: 'Datetime', icon: Icons.schedule),
      FieldItem(type: 'time', label: 'Time', icon: Icons.access_time),
      FieldItem(type: 'file', label: 'File', icon: Icons.upload_file),
      FieldItem(type: 'signature', label: 'Signature', icon: Icons.draw),
      FieldItem(type: 'rating', label: 'Rating', icon: Icons.star_border),
      FieldItem(type: 'slider', label: 'Slider', icon: Icons.tune),
    ],
  ),
  FieldCategory(
    name: 'Advanced',
    items: [
      FieldItem(type: 'email', label: 'Email', icon: Icons.email),
      FieldItem(type: 'phone', label: 'Phone', icon: Icons.phone),
      FieldItem(type: 'url', label: 'URL', icon: Icons.link),
      FieldItem(type: 'address', label: 'Address', icon: Icons.home_work_outlined),
      FieldItem(type: 'location', label: 'Location', icon: Icons.place),
      FieldItem(type: 'currency', label: 'Currency', icon: Icons.payments_outlined),
      FieldItem(type: 'percentage', label: 'Percentage', icon: Icons.percent),
    ],
  ),
  FieldCategory(
    name: 'Common Additions',
    items: [
      FieldItem(type: 'toggle', label: 'Toggle', icon: Icons.toggle_off),
      FieldItem(type: 'yes_no', label: 'Yes / No', icon: Icons.how_to_vote_outlined),
      FieldItem(type: 'rich_text', label: 'Rich Text', icon: Icons.text_format),
      FieldItem(type: 'number_range', label: 'Number Range', icon: Icons.horizontal_rule),
      FieldItem(type: 'date_range', label: 'Date Range', icon: Icons.date_range),
      FieldItem(type: 'datetime_range', label: 'Datetime Range', icon: Icons.event_repeat),
      FieldItem(type: 'time_range', label: 'Time Range', icon: Icons.timelapse),
    ],
  ),
  FieldCategory(
    name: 'Structured Input',
    items: [
      FieldItem(type: 'name', label: 'Name', icon: Icons.badge),
      FieldItem(type: 'first_name', label: 'First Name', icon: Icons.person),
      FieldItem(type: 'last_name', label: 'Last Name', icon: Icons.person_outline),
      FieldItem(type: 'full_name', label: 'Full Name', icon: Icons.account_circle_outlined),
      FieldItem(type: 'organization', label: 'Organization', icon: Icons.apartment),
      FieldItem(type: 'country', label: 'Country', icon: Icons.public),
      FieldItem(type: 'state', label: 'State', icon: Icons.map),
      FieldItem(type: 'city', label: 'City', icon: Icons.location_city),
      FieldItem(type: 'postal_code', label: 'Postal Code', icon: Icons.markunread_mailbox),
      FieldItem(type: 'street_address', label: 'Street Address', icon: Icons.route),
      FieldItem(type: 'building', label: 'Building', icon: Icons.apartment_outlined),
      FieldItem(type: 'apartment', label: 'Apartment', icon: Icons.meeting_room),
      FieldItem(type: 'suite', label: 'Suite', icon: Icons.door_sliding),
      FieldItem(type: 'landmark', label: 'Landmark', icon: Icons.location_on_outlined),
      FieldItem(type: 'region', label: 'Region', icon: Icons.map_outlined),
      FieldItem(type: 'province', label: 'Province', icon: Icons.travel_explore),
      FieldItem(type: 'county', label: 'County', icon: Icons.terrain),
      FieldItem(type: 'district', label: 'District', icon: Icons.map_sharp),
      FieldItem(type: 'full_name_with_title', label: 'Full Name With Title', icon: Icons.manage_accounts),
      FieldItem(type: 'address_with_country', label: 'Address With Country', icon: Icons.language),
      FieldItem(type: 'contact_person', label: 'Contact Person', icon: Icons.contact_page),
      FieldItem(type: 'emergency_contact', label: 'Emergency Contact', icon: Icons.local_hospital),
    ],
  ),
  FieldCategory(
    name: 'Specialized Business Fields',
    items: [
      FieldItem(type: 'id_number', label: 'ID Number', icon: Icons.badge_outlined),
      FieldItem(type: 'tax_id', label: 'Tax ID', icon: Icons.receipt_long),
      FieldItem(type: 'passport_number', label: 'Passport Number', icon: Icons.airplane_ticket),
      FieldItem(type: 'employee_id', label: 'Employee ID', icon: Icons.work),
      FieldItem(type: 'payment_reference', label: 'Payment Reference', icon: Icons.payments),
      FieldItem(type: 'bank_account', label: 'Bank Account', icon: Icons.account_balance),
      FieldItem(type: 'iban', label: 'IBAN', icon: Icons.numbers),
      FieldItem(type: 'routing_number', label: 'Routing Number', icon: Icons.route_outlined),
    ],
  ),
  FieldCategory(
    name: 'Data / Technical',
    items: [
      FieldItem(type: 'ip_address', label: 'IP Address', icon: Icons.lan),
      FieldItem(type: 'mac_address', label: 'MAC Address', icon: Icons.memory),
      FieldItem(type: 'color', label: 'Color', icon: Icons.palette_outlined),
      FieldItem(type: 'currency_code', label: 'Currency Code', icon: Icons.attach_money),
      FieldItem(type: 'json', label: 'JSON', icon: Icons.data_object),
      FieldItem(type: 'uuid', label: 'UUID', icon: Icons.fingerprint),
      FieldItem(type: 'slug', label: 'Slug', icon: Icons.label_outline),
      FieldItem(type: 'ip_range', label: 'IP Range', icon: Icons.device_hub),
      FieldItem(type: 'network_cidr', label: 'Network CIDR', icon: Icons.router),
      FieldItem(type: 'url_list', label: 'URL List', icon: Icons.link_off),
      FieldItem(type: 'email_list', label: 'Email List', icon: Icons.mark_email_read),
      FieldItem(type: 'phone_list', label: 'Phone List', icon: Icons.contact_phone),
    ],
  ),
  FieldCategory(
    name: 'Capture / Workflow',
    items: [
      FieldItem(type: 'checkbox_group', label: 'Checkbox Group', icon: Icons.checklist),
      FieldItem(type: 'matrix', label: 'Matrix', icon: Icons.grid_view),
      FieldItem(type: 'photo', label: 'Photo', icon: Icons.photo_camera),
      FieldItem(type: 'video', label: 'Video', icon: Icons.videocam),
      FieldItem(type: 'audio', label: 'Audio', icon: Icons.mic),
      FieldItem(type: 'document', label: 'Document', icon: Icons.description),
      FieldItem(type: 'attachment', label: 'Attachment', icon: Icons.attach_file),
      FieldItem(type: 'barcode', label: 'Barcode', icon: Icons.qr_code_scanner),
      FieldItem(type: 'qr_code', label: 'QR Code', icon: Icons.qr_code),
    ],
  ),
  FieldCategory(
    name: 'Dates / Scheduling',
    items: [
      FieldItem(type: 'month', label: 'Month', icon: Icons.calendar_month),
      FieldItem(type: 'week', label: 'Week', icon: Icons.view_week),
      FieldItem(type: 'year', label: 'Year', icon: Icons.event_note),
      FieldItem(type: 'duration', label: 'Duration', icon: Icons.timer),
      FieldItem(type: 'deadline', label: 'Deadline', icon: Icons.flag),
      FieldItem(type: 'appointment_slot', label: 'Appointment Slot', icon: Icons.event_available),
      FieldItem(type: 'business_hours', label: 'Business Hours', icon: Icons.business_center),
    ],
  ),
  FieldCategory(
    name: 'Quantitative',
    items: [
      FieldItem(type: 'multiplier', label: 'Multiplier', icon: Icons.filter_1),
      FieldItem(type: 'score', label: 'Score', icon: Icons.score),
      FieldItem(type: 'percentage_range', label: 'Percentage Range', icon: Icons.percent_outlined),
      FieldItem(type: 'currency_range', label: 'Currency Range', icon: Icons.money),
      FieldItem(type: 'unit_price', label: 'Unit Price', icon: Icons.price_change),
      FieldItem(type: 'weight', label: 'Weight', icon: Icons.monitor_weight),
      FieldItem(type: 'distance', label: 'Distance', icon: Icons.social_distance),
      FieldItem(type: 'area', label: 'Area', icon: Icons.square_foot),
      FieldItem(type: 'volume', label: 'Volume', icon: Icons.view_in_ar),
    ],
  ),
  FieldCategory(
    name: 'Selection / Classification',
    items: [
      FieldItem(type: 'multi_radio', label: 'Multi Radio', icon: Icons.radio_button_unchecked),
      FieldItem(type: 'single_choice', label: 'Single Choice', icon: Icons.radio_button_checked),
      FieldItem(type: 'multi_choice', label: 'Multi Choice', icon: Icons.check_circle_outline),
      FieldItem(type: 'priority', label: 'Priority', icon: Icons.priority_high),
      FieldItem(type: 'rank', label: 'Rank', icon: Icons.emoji_events),
      FieldItem(type: 'country_state_city', label: 'Country State City', icon: Icons.account_tree),
    ],
  ),
  FieldCategory(
    name: 'Long-form / Document',
    items: [
      FieldItem(type: 'markdown', label: 'Markdown', icon: Icons.article),
      FieldItem(type: 'code_block', label: 'Code Block', icon: Icons.code),
      FieldItem(type: 'table', label: 'Table', icon: Icons.table_chart),
      FieldItem(type: 'list', label: 'List', icon: Icons.format_list_bulleted),
    ],
  ),
];
