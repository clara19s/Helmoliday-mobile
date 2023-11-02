import 'package:flutter/material.dart';
import 'package:helmoliday/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

import '../model/holiday.dart';
import '../widget/holiday/holiday_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (nContext) => HomeScreenViewModel(nContext),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HELMoliday'),
        ),
        body: Consumer<HomeScreenViewModel>(
          builder: (context, viewModel, child) {
            return RefreshIndicator(
              onRefresh: () {
                viewModel.refreshData();
                return Future.value();
              },
              child: ListView(scrollDirection: Axis.vertical, children: [
                FutureBuilder(
                  future: viewModel.invitedHolidaysFuture,
                  builder: (context, AsyncSnapshot<List<Holiday>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return HolidayListView(
                        sectionTitle: "Dernières vacances",
                        axis: Axis.horizontal,
                        holidays: snapshot.data ?? [],
                        onCardTapped: (holidayId) {
                          viewModel.goToHolidayDetails(holidayId);
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                FutureBuilder(
                  future: viewModel.publishedHolidaysFuture,
                  builder: (context, AsyncSnapshot<List<Holiday>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return HolidayListView(
                          sectionTitle: "Besoin d'inspiration ?",
                          axis: Axis.vertical,
                          holidays: snapshot.data ?? [],
                          onCardTapped: (holidayId) {
                            viewModel.goToHolidayDetails(holidayId);
                          },
                          cardSize: const Size(400, 200));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
