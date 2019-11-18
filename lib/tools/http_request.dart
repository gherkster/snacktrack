import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snacktrack/auth.dart';
import 'package:http/http.dart';
import 'package:snacktrack/tools/stored_prefs.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class HttpRequest { // TODO Make abstract class since methods are very dependent

  Future<void> fetchNewWeightData() async {

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

    Map<String, dynamic> parsedJson = json.decode(response.body);

    List<Weight> weightList = [];
    for (Map<String, dynamic> point in parsedJson['point']) {

      String timeInMs = point['startTimeNanos']; // TODO change to int

      int date = int.parse(timeInMs.substring(0, timeInMs.length - 3)); // Time stored in microseconds since epoch
      double weight = point['value'][0]['fpVal'];

      weightList.add(new Weight(date, weight));
    }

    prefs.weights.setValue(new Weights(weightList));
  }
}

class Weight {
  final int date;
  final double weight;

  Weight(this.date, this.weight);

  Weight.fromJson(Map<String, dynamic> json) :
        date = json['date'],
        weight = json['weight'];

  Map<String, dynamic> toJson() => { 'date': date, 'weight': weight};
}

class Weights {
  List<Weight> weightList;

  Weights(this.weightList);

  Weights.fromJson(Map<String, dynamic> json) : // parse each member of list using Weight.fromJson and add to list
    weightList = (json['weights'] as List).map((value) => Weight.fromJson(value)).toList();

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> weights = weightList.map((value) => value.toJson()).toList();
    return <String, dynamic>{
      'weights': weights
    };
  }

  bool isEmpty() {
    return weightList.isEmpty;
  }

  static Weights empty() => new Weights([]);
}
