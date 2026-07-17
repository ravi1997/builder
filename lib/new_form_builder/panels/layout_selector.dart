import 'package:flutter/material.dart';
import '../pages/new_form_builder_page.dart';
import '../widgets/reusable_widgets.dart';

class LayoutSelectorPanel extends StatelessWidget {
  final List<LayoutOption> layouts;
  final String selectedLayoutId;
  final String selectedCategory;
  final String searchQuery;
  final ValueChanged<String> onLayoutSelected;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onContinue;

  const LayoutSelectorPanel({
    super.key,
    required this.layouts,
    required this.selectedLayoutId,
    required this.selectedCategory,
    required this.searchQuery,
    required this.onLayoutSelected,
    required this.onCategorySelected,
    required this.onSearchChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Single Page', 'Wizard / Step', 'Navigation', 'Progress', 'Card', 'Advanced'];
    
    final filtered = layouts.where((l) {
      final matchesSearch = l.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          l.description.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'All' || l.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Container(
      width: 340,
      color: AdiyogiColors.shellWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Form Design Controls',
              style: AdiyogiTextStyles.sectionHeading(context).copyWith(fontSize: 16, color: AdiyogiColors.shellCharcoal),
            ),
          ),
          const Divider(height: 1, color: AdiyogiColors.shellBorder),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search layouts...',
                prefixIcon: const Icon(Icons.search, size: 18),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories.map((cat) {
                final active = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat, style: const TextStyle(fontSize: 11)),
                    selected: active,
                    onSelected: (selected) {
                      if (selected) onCategorySelected(cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final l = filtered[index];
                final selected = selectedLayoutId == l.id;
                return Material(
                  color: selected ? AdiyogiColors.shellBackground : Colors.transparent,
                  child: ListTile(
                    leading: Icon(l.icon, color: selected ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyMuted),
                    title: Text(l.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text(l.description, style: const TextStyle(fontSize: 11)),
                    onTap: () => onLayoutSelected(l.id),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AdiyogiColors.shellCharcoal,
                foregroundColor: AdiyogiColors.shellWhite,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Continue to Style Config'),
            ),
          ),
        ],
      ),
    );
  }
}
