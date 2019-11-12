import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class Prefs {
  Prefs(StreamingSharedPreferences preferences) :
        kj = preferences.getInt("kj", defaultValue: 0);

  final Preference<int> kj;
}