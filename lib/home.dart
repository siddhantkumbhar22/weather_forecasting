import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecasting/providers/data_provider.dart';
import 'package:weather_forecasting/providers/list_provider.dart';

import 'list_data.dart';
import 'main_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false)
          .fetchWeatherData("0.0", "0.0", true);
      Provider.of<ListProvider>(context, listen: false)
          .fetchWeatherListData("0.0", "0.0", true);
    });
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff72eafd),
              Color(0xFF1ba8f5),
            ],
            // Cyan to Blue gradient
            begin: Alignment.topCenter,
            // Start the gradient from top left
            end: Alignment.bottomLeft, // End the gradient at bottom right
          ),
        ),
        child: SafeArea(
          child: const SingleChildScrollView(
            child: Column(
              children: [
                MainView(),
                ListWeatherData(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

