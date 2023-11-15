import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../service/export_service.dart';

class ExportServiceImpl implements ExportService {

  Future<void> importICSFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ics'],
    );

    if (result != null && result.files.isNotEmpty) {
      String icsContent = String.fromCharCodes(result.files.first.bytes!);

      List<Map<String, dynamic>> events = parseICS(icsContent);

      for (var event in events) {
        String summary = event['SUMMARY'] ?? 'No Title';
        String description = event['DESCRIPTION'] ?? 'No Description';
        DateTime startDate = DateTime.parse(event['DTSTART']);
        DateTime endDate = DateTime.parse(event['DTEND']);

        _addEventToCalendar(summary, description, startDate, endDate);
      }

      Fluttertoast.showToast(msg: 'ICS File Imported');
    }
  }

  List<Map<String, dynamic>> parseICS(String icsContent) {
    List<Map<String, dynamic>> events = [];

    List<String> lines = LineSplitter.split(icsContent).toList();
    Map<String, dynamic> currentEvent = {};

    for (var line in lines) {
      if (line.startsWith('BEGIN:VEVENT')) {
        currentEvent = {};
      } else if (line.startsWith('END:VEVENT')) {
        events.add(currentEvent);
      } else {
        var parts = line.split(':');
        if (parts.length == 2) {
          currentEvent[parts[0]] = parts[1];
        }
      }
    }

    return events;
  }

  void _addEventToCalendar(String summary, String description,
      DateTime startDate, DateTime endDate) {
    setState(() {
      _events[DateTime(startDate.year, startDate.month, startDate.day)] ??= [];
      _events[DateTime(startDate.year, startDate.month, startDate.day)].add({
        'summary': summary,
        'description': description,
        'start': startDate,
        'end': endDate,
      });
    });
  }

}
