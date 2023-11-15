import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/weather.dart';
import '../view_model/weather_view_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, required this.id});

  final String id;

  @override
  State<WeatherScreen> createState() => _MeteoScreen();
}
class _MeteoScreen extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext nContext) =>
            WeatherViewModel(nContext, widget.id),
        child: Consumer<WeatherViewModel>(
            builder: (context, viewModel, child) => FutureBuilder(
                future: viewModel.weather,
                builder: (context, AsyncSnapshot<Weather> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var weather = snapshot.data;
                    if (weather == null) {
                      return const Center(
                        child: Text('Aucune météo'),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                        child: Row(
                          children: [
                            Image.network(weather.icon, width: 50, height: 50),
                            Text("${weather.temperature}°C"),

                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }
}
