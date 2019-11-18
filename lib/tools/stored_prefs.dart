import 'package:snacktrack/tools/http_request.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class Prefs {
  Prefs(StreamingSharedPreferences preferences) :
        kj = preferences.getInt("kj", defaultValue: 0),
        lastUpdateTime = preferences.getInt("lastUpdateTime", defaultValue: 0), // Milliseconds since epoch
        lastUpdateSuccessful = preferences.getBool("lastUpdateSuccessful", defaultValue: false),
        weights = preferences.getCustomValue<Weights>('weightsObject', defaultValue: Weights.empty(),
            adapter: JsonAdapter(deserializer: (value) => Weights.fromJson(value),
  ));

  final Preference<int> kj;
  final Preference<int> lastUpdateTime;
  final Preference<bool> lastUpdateSuccessful;
  final Preference<Weights> weights;
}

