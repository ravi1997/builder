import 'package:flutter/material.dart';

import '../utils/field_registry.dart';

class ComponentLibrary extends StatefulWidget {
  const ComponentLibrary({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onDragStarted,
  });

  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onDragStarted;

  @override
  State<ComponentLibrary> createState() => _ComponentLibraryState();
}

class _ComponentLibraryState extends State<ComponentLibrary> {
  final Set<String> _expanded = <String>{'Core Answer Fields', 'Advanced'};

  void _toggleAll(List<FieldCategory> categories) {
    final allExpanded = categories.every((category) => _expanded.contains(category.name));
    setState(() {
      if (allExpanded) {
        _expanded.clear();
      } else {
        _expanded
          ..clear()
          ..addAll(categories.map((category) => category.name));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.searchQuery.toLowerCase().trim();
    final categories = fieldCategories
        .map((category) => FieldCategory(
              name: category.name,
              items: category.items.where((item) {
                if (query.isEmpty) return true;
                return item.label.toLowerCase().contains(query) || item.type.toLowerCase().contains(query);
              }).toList(),
            ))
        .where((category) => category.items.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          onChanged: widget.onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'Search fields',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: categories.isEmpty ? null : () => _toggleAll(categories),
            icon: Icon(
              categories.isNotEmpty && categories.every((category) => _expanded.contains(category.name))
                  ? Icons.unfold_less
                  : Icons.unfold_more,
            ),
            label: Text(
              categories.isNotEmpty && categories.every((category) => _expanded.contains(category.name))
                  ? 'Collapse all'
                  : 'Expand all',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isExpanded = _expanded.contains(category.name);
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => setState(() {
                        if (isExpanded) {
                          _expanded.remove(category.name);
                        } else {
                          _expanded.add(category.name);
                        }
                      }),
                      title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: category.items.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, itemIndex) {
                            final item = category.items[itemIndex];
                            return _LibraryTile(
                              item: item,
                              onDragStarted: () => widget.onDragStarted(item.type),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LibraryTile extends StatelessWidget {
  const _LibraryTile({required this.item, required this.onDragStarted});

  final FieldItem item;
  final VoidCallback onDragStarted;

  @override
  Widget build(BuildContext context) {
    return Draggable<FieldItem>(
      key: ValueKey('field-${item.type}'),
      data: item,
      onDragStarted: onDragStarted,
      rootOverlay: true,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 180,
          height: 180,
          child: _Tile(item: item, highlighted: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: _Tile(item: item),
      ),
      child: _Tile(item: item),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.item, this.highlighted = false});

  final FieldItem item;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: highlighted ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: SizedBox.expand(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(item.icon, size: 24),
          const SizedBox(height: 8),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            item.type,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600, fontSize: 10),
          ),
          const SizedBox(height: 8),
          const Icon(Icons.drag_indicator, size: 16),
        ],
        ),
      ),
    );
  }
}
