import 'package:snacktrack/tools/http_request.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class Prefs {
  Prefs(StreamingSharedPreferences preferences) :
        kj = preferences.getInt("kj", defaultValue: 0);
        //weights = preferences.getCustomValue<List<Weight>>("weights", defaultValue: [], adapter: null);

  final Preference<int> kj;
  //final Preference<List<Weight>> weights;
}