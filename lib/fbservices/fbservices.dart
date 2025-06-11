import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c14_online_sun/data/data_model/categoryDM.dart';
import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:firebase_auth/firebase_auth.dart';

class fbservices {
  static CollectionReference<EventDM> getEventsCollection() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<EventDM> eventsCollection = db
        .collection("Events")
        .withConverter<EventDM>(
          fromFirestore: (snapshot, _) => EventDM.fromJson(snapshot.data()!),
          toFirestore: (event, _) => event.toJson(),
        );
    return eventsCollection;
  }

  static Future<void> addEventToFireStore(EventDM event) {
    CollectionReference<EventDM> eventsCollection = getEventsCollection();
    DocumentReference<EventDM> document = eventsCollection.doc();
    event.id = document.id;
    return document.set(event);
  }

  static Future<List<EventDM>> getEventsOnTimeRead(CategoryDM category) async {
    CollectionReference<EventDM> eventsCollection = getEventsCollection();
    QuerySnapshot querySnapshot = await eventsCollection
        .where("categoryId", isEqualTo: category.id == "0" ? null : category.id)
        .get();
    List<QueryDocumentSnapshot> documentsSnapShot = querySnapshot.docs;
    List<EventDM> events = documentsSnapShot
        .map(
          (docSnapshot) => docSnapshot.data() as EventDM,
        )
        .toList();

    return events;
  }

  static Stream<List<EventDM>> getEventsRealTimeUpdates(
      CategoryDM selectedCategory) async* {
    CollectionReference<EventDM> eventsCollection = getEventsCollection();
    var querySnapshotStream = eventsCollection
        .where("categoryId",
            isEqualTo: selectedCategory.id == '0' ? null : selectedCategory.id)
        .orderBy("date")
        .snapshots();
    var events = querySnapshotStream.map(
      (querySnapshot) => querySnapshot.docs
          .map(
            (docSnapshot) => docSnapshot.data(),
          )
          .toList(),
    );
    yield* events;
  }

  static Future<void> signUp(String email, String password) async {
    UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }
  static Future<void> signin(String email, String password) async
  {
    UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email:email.trim(),password:password );
  }
}
