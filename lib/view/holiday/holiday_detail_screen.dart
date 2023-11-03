import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helmoliday/widget/holiday/holiday_banner.dart';
import 'package:provider/provider.dart';

import '../../view_model/holiday/holiday_detail_view_model.dart';

class HolidayDetailScreen extends StatelessWidget {
  const HolidayDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HolidayDetailViewModel>(
      create: (nContext) => HolidayDetailViewModel(nContext, id),
      child: Consumer<HolidayDetailViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Détails de la vacance'),
            actions: [
              IconButton(
                onPressed: () {
                  model.goToEditHoliday();
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  // set up the buttons
                  Widget cancelButton = TextButton(
                    child: const Text("Annuler"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                  Widget continueButton = TextButton(
                    child: const Text("Supprimer"),
                    onPressed: () {
                      model.removeHoliday();
                      Navigator.of(context).pop();
                    },
                  );

                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: const Text("Êtes-vous sûr ?"),
                    content: const Text(
                        "Une fois supprimé, la période de vacance ne pourra plus être restaurée."),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );

                  // show the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('En cours de développement'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Icon(Icons.chat),
          ),
          body: FutureBuilder(
              future: model.holiday,
              builder: (context, snapshot) {
                var holiday = snapshot.data;
                return snapshot.hasData
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            HolidayBanner(
                              name: holiday!.name,
                              image:
                              "https://picsum.photos/seed/${holiday.id}/300/300",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Description",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(holiday.description),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
