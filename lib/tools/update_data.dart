import 'package:snacktrack/tools/http_request.dart';
import 'package:snacktrack/tools/network_check.dart';
import 'package:snacktrack/tools/stored_prefs.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class UpdateData {
  static Future<void> updateDataIfNextDay() async { // TODO Try passing context to avoid creating new ssp instance

    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    Prefs prefs = new Prefs(preferences);

    DateTime now = DateTime.now();
    DateTime lastOpenTime = DateTime.fromMicrosecondsSinceEpoch(prefs.lastOpenTime.getValue());
    bool notOpenedRecently = (now.day != lastOpenTime.day) || (now.hour >= 6 && lastOpenTime.hour < 6);

    if (notOpenedRecently) {
      prefs.kj.setValue(0);
      prefs.lastOpenTime.setValue(DateTime.now().microsecondsSinceEpoch);
    }

    DateTime lastUpdateDateTime = DateTime.fromMicrosecondsSinceEpoch(prefs.lastSyncTime.getValue());
    bool notUpdatedRecently = (now.day != lastUpdateDateTime.day) || (now.hour >= 6 && lastUpdateDateTime.hour < 6);

    NetworkCheck networkCheck = new NetworkCheck();
    if ((notUpdatedRecently || !prefs.lastSyncSuccessful.getValue()) && await networkCheck.check()) {
      try {
        HttpRequest request = new HttpRequest();
        request.fetchNewWeightData();

        prefs.lastSyncTime.setValue(DateTime.now().microsecondsSinceEpoch);
        prefs.lastSyncSuccessful.setValue(true);
      } catch (_) {
        prefs.lastSyncSuccessful.setValue(false);
      }
    }

    // TODO Add kj to total kj online,
    // TODO Calculate new TDEE
    // TODO set last update time back

  }
}