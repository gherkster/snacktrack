import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacktrack/auth.dart';

abstract class BaseDatabase {
  Future<void> create(String collectionName, Map<String, dynamic> data);

  Future<int> read(String collectionName);

  //Future<void> update();

  Future<void> delete();
}

class Database implements BaseDatabase {

  Future<void> create(String collectionName, Map<String, dynamic> data) async {

    Auth auth = Auth();
    String userId = await auth.getCurrentUserUid();

    final kjRef = Firestore.instance.collection('users').document(userId).collection(collectionName);
    await kjRef.document().setData(data);

    // TODO Return error if failed
    // TODO Create one document with amount for whole day daily, not one for each tracked
  }

  Future<int> read(String collectionName) async {

    Auth auth = Auth();
    String userId = await auth.getCurrentUserUid();
    
    final dateRef = Firestore.instance.collection('users').document(userId).collection(collectionName);

    DateTime date = DateTime.now();
    bool afterMidnight = (date.hour >= 0) && (date.hour < 6);
    DateTime desiredDate = DateTime(date.year, date.month, afterMidnight ? date.day - 1 : date.day, 6, 0, 0);// Previous 6AM
    print(desiredDate.toLocal());

    int total = 0;
    QuerySnapshot query = await dateRef.where('date', isGreaterThanOrEqualTo: desiredDate).getDocuments();
    DocumentSnapshot doc = query.documents.elementAt(0);
    print(doc.metadata.isFromCache ? "GOT DOC FROM LOCAL" : "GOT DOC FROM NETWORK");
    query.documents.forEach((f) => (total += int.parse(f.data['kj'])));
    return total;
  }

  Future<void> delete() async { // TODO Remove later, this deletes whole collection of kj values
    Auth auth = Auth();
    String userId = await auth.getCurrentUserUid();

    Firestore.instance.collection('users').document(userId).collection('kj-intakes').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }
}
