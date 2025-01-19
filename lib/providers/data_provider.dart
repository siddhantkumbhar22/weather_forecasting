import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_forecasting/utils/unit_prefrence.dart';
import '../model/multi_weather_forecast.dart';
import '../model/weather.dart';
import '../utils/constants.dart';
import '../utils/functions.dart';

class DataProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isListLoading = false;
  WeatherResponse? _weather;
  bool _dataLoaded = false;
  bool _listLoaded = false;
  ForecastResponse? _forecastResponse;
  String _greetings = "";
  String _date = "";
  String _temperature = "0.0";
  bool _isCelsius = false;
  String _cityName = "";

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  bool get dataLoaded => _dataLoaded;

  bool get listLoaded => _listLoaded;

  bool get isListLoading => _isListLoading;

  String get errorMessage => _errorMessage;

  String get greetings => _greetings;

  String get temperature => _temperature;

  bool get isCelsius => _isCelsius;

  WeatherResponse? get weather => _weather;

  ForecastResponse? get forecastResponse => _forecastResponse;

  String get date => _date;

  String get cityName => _cityName;

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good \nmorning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good \nAfternoon';
    } else if (hour >= 17 && hour < 22) {
      return 'Good \nEvening';
    } else {
      return 'Good \nNight';
    }
  }

  Future<void> changeUnit() async {
    _isCelsius = !_isCelsius;
    if (_isCelsius) {
      await UnitPreference.setUnit('Celsius');
    } else {
      await UnitPreference.setUnit('Fahrenheit');
    }
    fetchWeatherData("0.0", "0.0", true);
  }

  Future<void> search(String lat, String long, String name) async {
    await Functions.setLat(lat);
    await Functions.setLong(long);
    await Functions.setSearchedCity(name);
    fetchWeatherData(lat, long, false);
  }

  Future<void> fetchWeatherData(String lat, String long, bool initial) async {
    _isLoading = true;
    _isListLoading = true;
    _hasError = false;
    _errorMessage = '';
    _dataLoaded = false;
    _listLoaded = false;
    _cityName = await Functions.getSearchedCity();
    notifyListeners();
    String inpLat;
    String inpLon;
    if (initial) {
      inpLat = await Functions.getLat();
      inpLon = await Functions.getLong();
    } else {
      inpLat = lat;
      inpLon = long;
    }

    try {
      var url =
          "${Constants.url}/data/2.5/weather?lat=$inpLat&lon=$inpLon&appid=${Constants.token}";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _weather = WeatherResponse.fromJson(data);
        _dataLoaded = true;
        _greetings = getGreeting();
        _date = Functions.getFormattedDate();
        _isCelsius = await Functions.isCelsius();
        _temperature = await Functions.calculateTemp(_weather!.main.temp);

        notifyListeners();
      } else {
        _hasError = true;
        _errorMessage = 'Something went wrong';
        notifyListeners();
      }
    } on SocketException catch (_) {
      _hasError = true;
      _errorMessage = 'No Internet connection. Please try again later.';
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Something went wrong: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
