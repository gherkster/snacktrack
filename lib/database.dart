import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacktrack/auth.dart';

abstract class BaseDatabase {
  Future<void> create(String collectionName, Map<String, dynamic> data);

  Future<int> read(String collectionName);

  //Future<void> update();

  //Future<void> delete();
}

class Database implements BaseDatabase {

  Future<void> create(String collectionName, Map<String, dynamic> data) async {

    Auth auth = Auth();
    String userId = await auth.getCurrentUserUid();

    final kjRef = Firestore.instance.collection('users').document(userId).collection(collectionName);
    await kjRef.document().setData(data);

    // TODO Return error if failed
  }

  Future<int> read(String collectionName) async {

    Auth auth = Auth();
    String userId = await auth.getCurrentUserUid();
    
    final dateRef = Firestore.instance.collection('users').document(userId).collection(collectionName);

    DateTime date = DateTime.now();
    DateTime desiredDate = DateTime(date.year, date.month, date.day, 6, date.minute, date.second);// 6AM Today

    int total = 0;
    QuerySnapshot query = await dateRef.where('date', isGreaterThanOrEqualTo: desiredDate).getDocuments();
    query.documents.forEach((f) => (total += int.parse(f.data['kj'])));
    return total;
  }
}
