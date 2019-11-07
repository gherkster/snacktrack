import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacktrack/auth.dart';
import 'package:snacktrack/totalValueBloc.dart';
import 'package:fit_kit/fit_kit.dart';

abstract class BaseDatabase {
  Future<void> create(String collectionName, Map<String, dynamic> data);

  Future<int> read(String collectionName);

  Future<void> getWeight();

  //Future<void> update();

  Future<void> delete();

  Future<void> updateTotal();
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
    query.documents.forEach((f) => (total += int.parse(f.data['kj'])));
    return total;
  }

  Future<void> getWeight() async {

    List<FitData> results = await FitKit.read(
        DataType.WEIGHT,
        DateTime.now().subtract(Duration(days: 7)),
        DateTime.now());

    print("Weight:");
    print(results); // TODO Not working
    for (FitData result in results) {
      print(result.value);
      print("Hello there!");
    }
  }

  Future<void> updateTotal() async { // TODO Fix this
    int intake = await read('kj-intakes');
    totalValueBloc.updateTotalValue(intake.toString());
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
