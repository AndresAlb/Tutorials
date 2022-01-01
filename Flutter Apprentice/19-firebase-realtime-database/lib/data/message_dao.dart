import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

class MessageDao
{
  // Gets an instance of FirebaseFirestore and then gets the root of the
  // messages collection by calling collection()
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('messages');

  void saveMessage(Message message)
  {
    // Adds the string to the Cloud Firestore collection. This updates the
    // database immediately
    collection.add(message.toJson());
  }

  Stream<QuerySnapshot> getMessageStream()
  {
    return collection.snapshots();
  }
}
