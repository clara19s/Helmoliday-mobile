import 'package:flutter/material.dart';
import 'package:helmoliday/util/date_util.dart';

class DateTimeRangePicker extends StatefulWidget {
  const DateTimeRangePicker({
    super.key,
    required this.onChanged,
    this.initialDateRange,
  });

  final DateTimeRange? initialDateRange;
  final ValueChanged<DateTimeRange> onChanged;

  @override
  State<DateTimeRangePicker> createState() => _DateTimeRangePickerState();
}

class _DateTimeRangePickerState extends State<DateTimeRangePicker> {
  DateTimeRange? _dateRange;
  final _dateController = TextEditingController();

  String get _dateRangeText => _dateRange != null
      ? "Du ${DateUtility.toFormattedString(_dateRange!.start)} au ${DateUtility.toFormattedString(_dateRange!.end)}"
      : "Choisissez une période";

  @override
  void initState() {
    _dateRange = widget.initialDateRange;
    _dateController.text = _dateRangeText;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () async {
        DateTimeRange? dateRange = await showDateRangePicker(
          context: context,
          initialDateRange: widget.initialDateRange,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
        );

        if (context.mounted && dateRange != null) {
          TimeOfDay? startTime = await showTimePicker(
            context: context,
            initialTime: _dateRange != null
                ? TimeOfDay.fromDateTime(_dateRange!.start)
                : TimeOfDay.now(),
            helpText: "Heure d'arrivée",
          );

          if (context.mounted && startTime != null) {
            TimeOfDay? endTime = await showTimePicker(
              context: context,
              initialTime: _dateRange != null
                  ? TimeOfDay.fromDateTime(_dateRange!.end)
                  : TimeOfDay.now(),
              helpText: "Heure de départ",
            );

            if (endTime != null) {
              DateTime startDateTime = DateTime(
                dateRange.start.year,
                dateRange.start.month,
                dateRange.start.day,
                startTime.hour,
                startTime.minute,
              );

              DateTime endDateTime = DateTime(
                dateRange.end.year,
                dateRange.end.month,
                dateRange.end.day,
                endTime.hour,
                endTime.minute,
              );

              // Mettez à jour le controller avec les dates et heures choisies
              setState(() {
                _dateRange =
                    DateTimeRange(start: startDateTime, end: endDateTime);
                _dateController.text = _dateRangeText;
                widget.onChanged(_dateRange!);
              });
            }
          }
        }
      },
      controller: _dateController,
      decoration: const InputDecoration(
        labelText: "Période",
      ),
      readOnly: true,
    );
  }
}
