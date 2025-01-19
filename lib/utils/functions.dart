import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecasting/model/location.dart';
import 'package:weather_forecasting/utils/unit_prefrence.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class Functions {
  static double kelvinToFahrenheit(double kelvin) {
    return (kelvin - 273.15) * 9 / 5 + 32;
  }

  static double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  static String getFormattedDate() {
    final now = DateTime.now();
    final day = now.day;
    final suffix = _getDaySuffix(day);

    final dayOfWeek = DateFormat('EEEE').format(now);
    final monthAbbr = DateFormat('MMM').format(now);

    return '$dayOfWeek, $monthAbbr $day$suffix ${now.year}';
  }

  static String _getDaySuffix(int day) {
    if (day % 100 >= 11 && day % 100 <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static Future<String> calculateTemp(
    double temperature,
  ) async {
    String temp = "0.0";
    if (await UnitPreference.getUnit() == 'Celsius') {
      temp = "${Functions.kelvinToCelsius(temperature).toStringAsFixed(2)}°C";
    }
    if (await UnitPreference.getUnit() == 'Fahrenheit') {
      temp =
          "${Functions.kelvinToFahrenheit(temperature).toStringAsFixed(2)}°F";
    }
    return temp;
  }

  static Future<bool> isCelsius() async {
    if (await UnitPreference.getUnit() == 'Celsius') {
      return true;
    }

    return false;
  }

  static String formatDateString(String input) {
    final dateTime = DateTime.parse(input);

    return DateFormat('dd-MMM-yyyy').format(dateTime);
  }

  static Future<List<LocationItem>> search(String inp) async {
    List<LocationItem> list = [];
    try {
      var url =
          "${Constants.url}/geo/1.0/direct?q=$inp&limit=5&appid=${Constants.token}";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        list = parseLocationList(decoded);
      } else {
        list = [];
      }
    } catch (e) {
      list = [];
    }
    return list;
  }

  static const String _lat = 'lat';
  static const String _long = 'long';
  static const String _city = 'city';

  static Future<String> getLat() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString(_lat) == null) {
      await setLat("19.0785451");
    }
    return prefs.getString(_lat).toString();
  }

  static Future<void> setLat(String lat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lat, lat);
  }

  static Future<String> getLong() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString(_long) == null) {
      await setLong("72.878176");
    }
    return prefs.getString(_long).toString();
  }

  static Future<void> setLong(String long) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_long, long);
  }

  static Future<void> setSearchedCity(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_city, name);
  }

  static Future<String> getSearchedCity() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString(_city) == null) {
      await setSearchedCity("Mumbai");
    }
    return prefs.getString(_city).toString();
  }
}
