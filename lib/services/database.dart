import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/models/brew.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({ this.uid});
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  Future<void> updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
  'Name': name,
  'Sugars': sugars,
  'Strength': strength,
    });
}


//brew list from snapshot
List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((docz){
    final dataz = docz.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
    return Brew(
      name: dataz["Name"] ?? '',
      strength: dataz['Strength'] ?? 0,
      sugars: dataz['Sugars'] ?? '0',
    );
  }).toList();
}
  //get brews stream
  Stream<List<Brew>> get brews{
    return brewCollection.snapshots().map(_brewListFromSnapshot );
  }
}