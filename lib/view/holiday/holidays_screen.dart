import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/holiday.dart';
import '../../view_model/holiday/holidays_view_model.dart';

class HolidayScreen extends StatelessWidget {
  const HolidayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext nContext) => HolidaysViewModel(nContext),
      child: Consumer<HolidaysViewModel>(
          builder: (context, viewModel, child) => Scaffold(
                appBar: AppBar(
                  title: const Text('Mes vacances'),
                ),
                body: Consumer<HolidaysViewModel>(
                    builder: (context, viewModel, child) {
                  return RefreshIndicator(
                    onRefresh: () {
                      viewModel.refreshData();
                      return Future.value();
                    },
                    child: FutureBuilder(
                      future: context
                          .watch<HolidaysViewModel>()
                          .invitedHolidaysFuture,
                      builder:
                          (context, AsyncSnapshot<List<Holiday>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              var holiday = snapshot.data![index];
                              return Dismissible(
                                key: Key(holiday.id!),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  child: const Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 16),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) {
                                  viewModel.deleteHoliday(holiday.id!);
                                },
                                child: ListTile(
                                  leading: Image(
                                    image: NetworkImage(
                                        "https://picsum.photos/seed/${holiday.id}/300/300"),
                                    width: 60,
                                    height: 60,
                                  ),
                                  title: Text(holiday.name),
                                  subtitle: Text(holiday.description),
                                  onTap: () {
                                    viewModel.goToHolidayDetails(holiday.id!);
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  );
                }),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    viewModel.goToCreateHoliday();
                  },
                  child: const Icon(Icons.add),
                ),
              )),
    );
  }
}
