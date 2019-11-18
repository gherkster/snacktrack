import 'package:snacktrack/tools/http_request.dart';
import 'package:snacktrack/tools/network_check.dart';
import 'package:snacktrack/tools/stored_prefs.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class UpdateData {
  static Future<void> updateDataIfNextDay() async {

    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    Prefs prefs = new Prefs(preferences);

    DateTime now = DateTime.now();
    DateTime lastUpdateDateTime = DateTime.fromMicrosecondsSinceEpoch(prefs.lastUpdateTime.getValue());
    bool notUpdatedRecently = (now.hour > 6 && lastUpdateDateTime.subtract(new Duration(hours: 6)).day != now.day);

    NetworkCheck networkCheck = new NetworkCheck();

    // Update if past 6AM and not updated today OR last check was unsuccessful, AND currently has internet
    if ((notUpdatedRecently || !prefs.lastUpdateSuccessful.getValue()) && await networkCheck.check()) {
      try {
        HttpRequest request = new HttpRequest();
        request.fetchNewWeightData(); // TODO Update Weight Graph

        prefs.lastUpdateTime.setValue(DateTime.now().microsecondsSinceEpoch);
        prefs.lastUpdateSuccessful.setValue(true);
      } catch (_) {
        prefs.lastUpdateSuccessful.setValue(false);
      }
    }

    // TODO Add kj to total kj online,
    // TODO Calculate new TDEE
    // TODO set last update time back

  }
}