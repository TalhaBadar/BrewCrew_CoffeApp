import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/models/brew.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
  'Name': name,
  'Sugars': sugars,
  'Strength': strength,
    });
}
 Future<void> checkAndCreateUserData() async {
    DocumentSnapshot doc = await brewCollection.doc(uid).get();
    if (!doc.exists) {
      // Create a new document if it doesn't exist
      await updateUserData('0', 'new crew member', 100);
    }
  }

//brew list from snapshot
List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc){
    final data = doc.data() as Map<String, dynamic>?;
    return Brew(
     name: data?["Name"]?? '',
     strength:data?['Strength']?? 0,
     sugars: data?['Sugars']?? '0',
     
    );
  }).toList();
}

  //get brews stream
  Stream<List<Brew>> get brews{
    return brewCollection.snapshots().map(_brewListFromSnapshot );
  }
}