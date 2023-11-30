import 'package:flutter/material.dart';
import 'package:helmoliday/model/activity.dart';

class ActivityFilter extends StatefulWidget {
  const ActivityFilter({super.key, required this.filters, required this.onCategorySelected});

  final Set<ActivityCategory> filters;
  final Function(ActivityCategory) onCategorySelected;

  @override
  State<ActivityFilter> createState() => _ActivityFilterState();
}

class _ActivityFilterState extends State<ActivityFilter> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Wrap(
        spacing: 5.0,
        children: ActivityCategory.values.map((ActivityCategory category) {
          return FilterChip(
            label: Text(category.label),
            selected: widget.filters.contains(category),
            onSelected: (selected) {
              widget.onCategorySelected(category);
            },
          );
        }).toList(),
      ),
    );
  }
}
