import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_forecasting/model/list_item.dart';
import '../model/multi_weather_forecast.dart';
import '../utils/constants.dart';
import '../utils/functions.dart';

class ListProvider with ChangeNotifier {
  bool _hasError = false;
  String _errorMessage = '';
  bool _listLoaded = false;
  bool _listLoading = false;
  ForecastResponse? _forecastResponse;
  List<Item> list = [];

  bool get hasError => _hasError;

  bool get listLoaded => _listLoaded;

  bool get listLoading => _listLoading;

  String get errorMessage => _errorMessage;

  ForecastResponse? get forecastResponse => _forecastResponse;

  Future<void> changeUnit() async {
    fetchWeatherListData("0.0", "0.0", true);
  }

  Future<void> search(String lat, String long) async {
    await Functions.setLat(lat);
    await Functions.setLong(long);
    fetchWeatherListData(lat, long, false);
  }

  Future<void> fetchWeatherListData(
      String lat, String long, bool initial) async {
    list = [];
    _hasError = false;
    _errorMessage = '';
    _listLoaded = false;
    _listLoading = true;

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
      var urlList =
          "${Constants.url}/data/2.5/forecast?lat=$inpLat&lon=$inpLon&appid=${Constants.token}";
      final responseList = await http.get(Uri.parse(urlList));

      if (responseList.statusCode == 200) {
        final dataList = jsonDecode(responseList.body);
        _forecastResponse = ForecastResponse.fromJson(dataList);
        _listLoaded = true;
        _listLoading = false;

        int length = 0;
        if (_forecastResponse != null ) {
          length = _forecastResponse!.list.length;
        }
        list = [];
        for (int i = 0; i < length; i++) {
          String temp = "0.0";

          if (_forecastResponse!.list[i].weather.isNotEmpty) {
            list.add(Item(
                icon: _forecastResponse!.list[i].weather[0].icon,
                date: Functions.formatDateString(
                    _forecastResponse!.list[i].dtTxt),
                description: _forecastResponse!.list[i].weather[0].description,
                temp: await Functions.calculateTemp(
                    _forecastResponse!.list[i].main.temp)));
          }
        }

        notifyListeners();
      } else {
        _hasError = true;
        _errorMessage = 'Error while loading data';
        notifyListeners();
      }
    } on SocketException catch (_) {
      _hasError = false;
      _errorMessage = 'No Internet connection. Please try again later.';
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Something went wrong: $e';
      notifyListeners();
    } finally {
      _listLoading = false;
      notifyListeners();
    }
  }
}
