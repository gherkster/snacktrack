import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snacktrack/auth.dart';
import 'package:http/http.dart';
import 'package:snacktrack/tools/stored_prefs.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class HttpRequest { // TODO Make abstract class since methods are very dependent

  Future<List<Weight>> getParsedWeightJson() async {

    final preferences = await StreamingSharedPreferences.instance;
    final prefs = Prefs(preferences);

    String jsonBody = prefs.weights.getValue();
    if (jsonBody == "") {
      jsonBody = await _fetchAndStoreWeightDataString();
    }

    Map<String, dynamic> parsedJson = json.decode(jsonBody);

    List<Weight> weights = [];
    for (Map<String, dynamic> point in parsedJson['point']) {

      String timeInMs = point['startTimeNanos'];
      timeInMs = timeInMs.substring(0, timeInMs.length - 3);

      DateTime date = new DateTime.fromMicrosecondsSinceEpoch(int.parse(timeInMs));
      double weight = point['value'][0]['fpVal'];

      weights.add(new Weight(date, weight));
    }
    return weights;
  }

  Future<String> _fetchAndStoreWeightDataString() async {

    var auth = new Auth();
    GoogleSignInAccount googleIdentity = await auth.getGoogleIdentity();

    final googleAuth = await googleIdentity.authentication;
    final token = googleAuth.accessToken;
    final headers = { 'Authorization': 'Bearer $token' };
    final nowNanoSeconds = DateTime.now().microsecondsSinceEpoch.toString() + "000";
    final weekAgoNanoSeconds = DateTime.now().subtract(Duration(days: 7)).microsecondsSinceEpoch.toString() + "000";
    final String pastWeek = "$weekAgoNanoSeconds-$nowNanoSeconds";

    final url = 'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.weight:com.google.android.gms:merge_weight/datasets/$pastWeek';
    final response = await get(url, headers: headers);

    final preferences = await StreamingSharedPreferences.instance;
    final prefs = Prefs(preferences);
    prefs.weights.setValue(response.body);

    return (response.body);
  }
}

class Weight {
  final DateTime date;
  final double weight;

  Weight(this.date, this.weight);
}
