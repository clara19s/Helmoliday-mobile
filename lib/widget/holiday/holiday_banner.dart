import 'package:flutter/material.dart';
import 'package:helmoliday/util/date_util.dart';

class HolidayBanner extends StatelessWidget {
  const HolidayBanner(
      {super.key,
      required this.name,
      required this.image,
      required this.dateRange});

  final String name;
  final String image;
  final DateTimeRange dateRange;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints.expand(
            height: 145,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          "${DateUtility.toFormattedString(dateRange.start)} - ${DateUtility.toFormattedString(dateRange.end)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
