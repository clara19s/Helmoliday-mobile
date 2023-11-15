import 'package:flutter/material.dart';
import 'package:helmoliday/theme.dart';
import 'package:helmoliday/view/activity/activity_list_screen.dart';
import 'package:helmoliday/view/holiday/guest_holiday_screen.dart';
import 'package:helmoliday/view/weather_screen.dart';
import 'package:helmoliday/widget/holiday/holiday_banner.dart';
import 'package:provider/provider.dart';

import '../../model/holiday.dart';
import '../../view_model/holiday/holiday_detail_view_model.dart';

class HolidayDetailScreen extends StatelessWidget {
  HolidayDetailScreen({super.key, required this.id});

  final String id;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HolidayDetailViewModel>(
      create: (nContext) => HolidayDetailViewModel(nContext, id),
      child: Consumer<HolidayDetailViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Détails'),
            actions: [
              IconButton(
                onPressed: () {
                  viewModel.goToEditHoliday();
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  Widget cancelButton = TextButton(
                    child: const Text("Annuler"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                  Widget continueButton = TextButton(
                    child: const Text("Supprimer"),
                    onPressed: () {
                      viewModel.removeHoliday();
                      Navigator.of(context).pop();
                    },
                  );

                  AlertDialog alert = AlertDialog(
                    title: const Text("Êtes-vous sûr ?"),
                    content: const Text(
                        "Une fois supprimé, la période de vacance ne pourra plus être restaurée."),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                icon: const Icon(Icons.delete),
              ),
              FutureBuilder<Holiday>(
                future: viewModel.holiday,
                // Future de l'état de la période de vacances
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "publier") {
                          Widget cancelButton = TextButton(
                            child: const Text("Annuler"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          Widget continueButton = TextButton(
                            child: const Text("Confirmer"),
                            onPressed: () {
                              viewModel.publishHoliday();
                              Navigator.of(context).pop();
                            },
                          );
                          AlertDialog alert = AlertDialog(
                            title: const Text("Publier la période de vacance"),
                            content: const Text(
                                "Êtes-vous sur de vouloir publier la période de vacance ?"),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        } else if (value == "exporter") {
                          // TODO : export a implémenter
                        } else if (value == "ajouterParticipant") {
                          // TODO : ajouter vérification si l'utilisateur existe
                          Widget cancelButton = TextButton(
                            child: const Text("Annuler"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          Widget continueButton = TextButton(
                            child: const Text("Confirmer"),
                            onPressed: () {
                              viewModel.addParticipant(_controller.text);
                              Navigator.of(context).pop();
                            },
                          );
                          AlertDialog alert = AlertDialog(
                            title: const Text("Ajouter un participant"),
                            content: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                            ),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        } else if (value == "quitter") {
                          Widget cancelButton = TextButton(
                            child: const Text("Annuler"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          Widget continueButton = TextButton(
                            child: const Text("Quitter"),
                            onPressed: () {
                              viewModel.exitHoliday();
                              Navigator.of(context).pop();
                            },
                          );
                          AlertDialog alert = AlertDialog(
                            title: const Text(
                                "Êtes-vous sûr de vouloir quitter ?"),
                            content: const Text(
                                "Attention, une fois que vous aurez quitté la période de vacance, vous ne pourrez plus y accéder."),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          if (!snapshot.data!.published)
                            const PopupMenuItem<String>(
                              value: "publier",
                              child: Text("Publier"),
                            ),
                          const PopupMenuItem<String>(
                            value: "exporter",
                            child: Text("Exporter"),
                          ),
                          const PopupMenuItem<String>(
                            value: "ajouterParticipant",
                            child: Text("Ajouter des participants"),
                          ),
                          const PopupMenuItem<String>(
                            value: "quitter",
                            child: Text("Quitter la période de vacances"),
                          ),
                        ];
                      },
                    );
                  } else {
                    // Affichez un widget alternatif (comme un spinner de chargement) si les données ne sont pas encore disponibles
                    return const Placeholder(
                      fallbackHeight: 1,
                      fallbackWidth: 1,
                    );
                  }
                },
              )
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
              future: viewModel.holiday,
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
                              dateRange: DateTimeRange(
                                start: holiday.startDate,
                                end: holiday.endDate,
                              ),
                            ),
                            Ink(
                              decoration: const ShapeDecoration(
                                color: HelmolidayTheme.primaryColor,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.map),
                                color: Colors.white,
                                onPressed: () {
                                  viewModel.goToHolidayMap();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Description",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          WeatherScreen(id: id),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(holiday.description),
                                      const SizedBox(height: 16),
                                      GuestHolidayScreen( guests: holiday.guests!),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 0),
                                            child: Text(
                                              "Activités",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              viewModel.goToCreateActivity();
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                     ActivityListScreen(id: id, activities: viewModel.activities, onUpdated: viewModel.refreshData()),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 64,
                            )
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
