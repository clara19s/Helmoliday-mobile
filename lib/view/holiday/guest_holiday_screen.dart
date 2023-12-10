import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:helmoliday/view/holiday/holiday_detail_screen.dart';
import 'package:helmoliday/view_model/holiday/holiday_detail_view_model.dart';
import 'package:provider/provider.dart';

import '../../model/guest.dart';

class GuestHolidayScreen extends StatefulWidget {
  const GuestHolidayScreen({super.key, required this.guests});

  final List<Guest> guests;

  @override
  State<GuestHolidayScreen> createState() => _GuestHolidayScreen();
}

class _GuestHolidayScreen extends State<GuestHolidayScreen> {
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: const Text(
        'Participants',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      collapsed: const Text(""),
      expanded: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.guests.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.guests[index].profilePicture),
            ),
            title: Text(widget.guests[index].firstName +
                ' ' +
                widget.guests[index].lastName),
          );
        },
      ),
    );
  }
}
