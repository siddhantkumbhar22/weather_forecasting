import 'package:shared_preferences/shared_preferences.dart';

class UnitPreference {
  static const String _keyUnit = 'unit';
  static const String celsius = 'Celsius';
  static const String fahrenheit = 'Fahrenheit';

  static Future<String> getUnit() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString(_keyUnit) == null){
      setUnit(celsius);
    }
    return prefs.getString(_keyUnit).toString();
  }

  static Future<void> setUnit(String newUnit) async {
    if (newUnit != celsius && newUnit != fahrenheit) {
      throw ArgumentError("Only '$celsius' or '$fahrenheit' are allowed.");
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUnit, newUnit);
  }
}