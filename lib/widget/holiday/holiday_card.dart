import 'package:flutter/material.dart';

class HolidayCard extends StatelessWidget {
  const HolidayCard({
    super.key,
    required this.name,
    required this.city,
    required this.country,
    this.cardSize = const Size(340, 200),
    this.onTap,
  });

  final String name;
  final String city;
  final String country;
  final Size cardSize;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          splashColor: Colors.white.withOpacity(0.3),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: cardSize.width,
              maxHeight: cardSize.height,
            ),
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://picsum.photos/seed/$name/300/300"),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  children: [
                    Positioned(
                      bottom: 16,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Text(name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Text("$city, $country",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(220, 255, 255, 255))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
