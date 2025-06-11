import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c14_online_sun/data/data_model/categoryDM.dart';
import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:evently_c14_online_sun/data/data_model/userDM.dart';
import 'package:firebase_auth/firebase_auth.dart';

class fbservices {
  static CollectionReference<EventDM> getEventsCollection() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<EventDM> eventsCollection =
    db.collection("Events").withConverter<EventDM>(
      fromFirestore: (snapshot, options) =>
          EventDM.fromJson(snapshot.data()!),
      toFirestore: (event, options) => event.toJson(),
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
    // [snapshot, snapshot, snapshot, snapshot]
    var events = querySnapshotStream.map(
          (querySnapshot) => querySnapshot.docs
          .map(
            (docSnapshot) => docSnapshot.data(),
      )
          .toList(),
    );
    yield* events;
  }

  /// Users
  static CollectionReference<userDM> getUsersCollection() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<userDM> usersCollection =
    db.collection("Users").withConverter<userDM>(
      fromFirestore: (snapshot, options) =>
          userDM.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
    return usersCollection;
  }

  static Future<void> addUserToFireStore(userDM user) {
    CollectionReference<userDM> usersCollection = getUsersCollection();
    DocumentReference<userDM> userDoc = usersCollection.doc(user.id);
    return userDoc.set(user);
  }

  static Future<userDM> getUserFromFireStore(String uid) async {
    CollectionReference<userDM> usersCollection = getUsersCollection();
    DocumentReference<userDM> userDoc = usersCollection.doc(uid);
    DocumentSnapshot<userDM> docSnapshot = await userDoc.get();
    userDM user = docSnapshot.data()!;
    return user;
  }

  static Future<void> updateUser(userDM currentUser) {
    CollectionReference<userDM> usersCollection = getUsersCollection();
    DocumentReference<userDM> userDoc = usersCollection.doc(currentUser.id);
    return userDoc.set(currentUser);
  }

  static Future<void> addEventToFav(String eventId) async {
    userDM currentUser = userDM.currentUser!;
    currentUser.favouriteEventsIds.add(eventId);
    return updateUser(currentUser);
  }

  static Future<void> removeEventFromFav(String eventId) {
    userDM currentUser = userDM.currentUser!;
    currentUser.favouriteEventsIds.remove(eventId);
    return updateUser(currentUser);
  }

  static Future<List<EventDM>> getFavEvents() async {
    CollectionReference<EventDM> eventsCollection = getEventsCollection();

    QuerySnapshot<EventDM> favEventsSnapshot = await eventsCollection
        .where(FieldPath.documentId,
        whereIn: userDM.currentUser!.favouriteEventsIds)
        .get();
    List<EventDM> favEvents = favEventsSnapshot.docs
        .map(
          (docSnapshot) => docSnapshot.data(),
    )
        .toList();

    return favEvents;
  }

  static Future<void> signup(
      String email, String password, String name) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    userDM user = userDM(
        id: credential.user!.uid,
        name: name,
        email: email,
        favouriteEventsIds: []);

    await addUserToFireStore(user);
  }

  static Future<void> signin(String email, String password) async {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    userDM user = await getUserFromFireStore(credential.user!.uid);
    userDM.currentUser = user;
  }
}