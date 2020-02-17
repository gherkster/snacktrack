import 'package:snacktrack/tools/http_request.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class Prefs { // TODO Data still used with different login
  Prefs(StreamingSharedPreferences preferences) :
        kj = preferences.getInt("kj", defaultValue: 0),
        lastOpenTime = preferences.getInt("lastOpenTime", defaultValue: 0),
        lastSyncTime = preferences.getInt("lastSyncTime", defaultValue: 0), // Milliseconds since epoch
        lastSyncSuccessful = preferences.getBool("lastSyncSuccessful", defaultValue: false),
        weight = preferences.getDouble("weight", defaultValue: 0),
        weights = preferences.getCustomValue<Weights>('weightsObject', defaultValue: Weights.empty(), adapter: JsonAdapter(deserializer: (value) => Weights.fromJson(value),)),
        weightTarget = preferences.getInt("weightTarget", defaultValue: 70);

  final Preference<int> kj;
  final Preference<int> lastOpenTime;
  final Preference<int> lastSyncTime;
  final Preference<bool> lastSyncSuccessful;
  final Preference<double> weight;
  final Preference<Weights> weights;
  final Preference<int> weightTarget;
}
