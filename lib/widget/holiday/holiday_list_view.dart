import 'package:flutter/material.dart';

import '../../model/holiday.dart';
import 'holiday_card.dart';

class HolidayListView extends StatelessWidget {
  const HolidayListView({
    Key? key,
    required this.sectionTitle,
    required this.holidays,
    this.onCardTapped,
    this.cardSize = const Size(340, 200),
    this.axis = Axis.vertical,
  }) : super(key: key);

  final String sectionTitle;
  final Axis axis;
  final List<Holiday> holidays;
  final Function(String)? onCardTapped;
  final Size cardSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            height: axis == Axis.horizontal ? cardSize.height : null,
            color: Colors.transparent,
            child: holidays.isEmpty
                ? const Center(child: Text("Aucune vacances"))
                : ListView.separated(
                    scrollDirection: axis,
                    itemCount: holidays.length,
                    primary: axis == Axis.horizontal ? true : null,
                    physics: axis == Axis.horizontal
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final holiday = holidays[index];
                      final holidayAddress = holiday.address;
                      return HolidayCard(
                          onTap: () {
                            if (onCardTapped != null && holiday.id != null) {
                              onCardTapped!(holiday.id!);
                            }
                          },
                          cardSize: cardSize,
                          name: holiday.name,
                          city: holidayAddress.city,
                          country: holidayAddress.country);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                          width: axis == Axis.horizontal ? 16 : 0,
                          height: axis == Axis.vertical ? 16 : 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
