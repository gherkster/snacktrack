import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class Prefs {
  Prefs(StreamingSharedPreferences preferences) :
        kj = preferences.getInt("kj", defaultValue: 0),
        weights = preferences.getString("weights", defaultValue: "");

  final Preference<int> kj;
  final Preference<String> weights;
}