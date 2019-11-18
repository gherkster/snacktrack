import 'package:cloud_firestore/cloud_firestore.dart';

class NetworkCheck {
  Future<bool> check() async {
    try {
      await Firestore.instance
          .runTransaction((Transaction tx) {})
          .timeout(Duration(seconds: 5));
      return true;
    } catch (_) {
      return false;
    }
  }
}