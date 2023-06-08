import 'dart:convert';

import 'package:seventv_for_whatsapp/models/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  String defaultPublisher = '7TV for WhatsApp';

  Settings();

  Settings.fromJson(Map<String, dynamic> json)
    : defaultPublisher = json['defaultPublisher'];

  Map<String, dynamic> toJson() => {
    'defaultPublisher': defaultPublisher,
  };
}

class SettingsManager {
  static Future<Settings> load() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = sharedPreferences.getString(SharedPreferencesKeys.settings);
    if(jsonString == null) {
      return Settings();
    }
    return Settings.fromJson(jsonDecode(jsonString));
  }

  static Future<void> save(Settings settings) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
      SharedPreferencesKeys.settings,
      jsonEncode(settings.toJson()),
    );
  }
}