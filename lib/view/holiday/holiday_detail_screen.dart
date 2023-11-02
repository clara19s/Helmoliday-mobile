import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HolidayDetailScreen extends StatelessWidget {
  const HolidayDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la vacance'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Modifier la vacance'),
                  duration: Duration(seconds: 2),
                ),
              );
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
      body: Column(children: [
        Hero(
          tag: id,
          child: Image(
            image: NetworkImage(
                "https://picsum.photos/seed/$id/800/800"),
            width: double.infinity,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        MaterialButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Retour')),
      ]),
    );
  }
}
