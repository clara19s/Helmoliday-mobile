import 'package:flutter/material.dart';
import 'package:helmoliday/theme.dart';
import 'package:helmoliday/view/activity/activity_list_screen.dart';
import 'package:helmoliday/widget/holiday/holiday_banner.dart';
import 'package:provider/provider.dart';

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
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Détails'),
            actions: [
              IconButton(
                onPressed: () {
                  model.goToEditHoliday();
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
                      model.removeHoliday();
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
              PopupMenuButton(
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "publier",
                          child: Text("Publier"),
                        ),
                        const PopupMenuItem(
                          value: "exporter",
                          child: Text("Exporter"),
                        ),
                        const PopupMenuItem(
                          value: "ajouterParticipant",
                          child: Text("Ajouter des participants"),
                        ),
                        const PopupMenuItem(
                          value: "quitter",
                          child: Text("Quitter la période de vacance"),
                        ),
                      ],
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
                          model.publishHoliday(model.id);
                          Navigator.of(context).pop();
                        },
                      );
                      AlertDialog alert = AlertDialog(
                        title: const Text("Publier la periode de vacance"),
                        content:  const Text("etes vous sur de vouloir publier la periode de vacance ?"),
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
                      // TODO : export a impléméneter
                    } else if (value == "ajouterParticipant") {

                      Widget cancelButton = TextButton(
                        child: const Text("Annuler"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                      Widget continueButton = TextButton(
                        child: const Text("Confirmer"),
                        onPressed: () {
                          model.addParticipant(_controller.text);
                          Navigator.of(context).pop();
                        },
                      );
                      AlertDialog alert = AlertDialog(
                        title: const Text("Ajouter un participant"),
                        content:  TextField(
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
                        child: const Text("Confirmer"),
                        onPressed: () {
                          model.exitHoliday();
                          Navigator.of(context).pop();
                        },
                      );
                      AlertDialog alert = AlertDialog(
                        title: const Text("Quitter la periode de vacance"),
                        content:  const Text("etes vous sur de vouloir quitter la periode de vacance ?"),
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
                  }),
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
                              dateRange: DateTimeRange(
                                start: holiday.startDate,
                                end: holiday.endDate,
                              ),
                            ),
                            // J'aimerai que le bouton puisse déborder de la moitié de sa taille sur le widget du dessus
                            Ink(
                              decoration: const ShapeDecoration(
                                color: HelmolidayTheme.primaryColor,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.map),
                                color: Colors.white,
                                onPressed: () {
                                  model.goToHolidayMap();
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
                                      const Text(
                                        "Description",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(holiday.description),
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
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              model.goToCreateActivity();
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                      ActivityListScreen(id: id)
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
