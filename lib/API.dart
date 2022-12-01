import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as prefix;
import 'user_data.dart';
import 'events.dart';

class API {
  late FirebaseFirestore database;

  API() {
    database = FirebaseFirestore.instance;
  }

  static const String usersCollection = "users";

  static const String nameKey = "name";
  static const String profilePicKey = "profilePic";
  static const String emailKey = "email";
  static const String pointsKey = "points";
  static const String gradeKey = "grade";
  static const String pastEventsKey = "pastEvents";
  static const String currentEventsKey = "currentEvents";
  static const String pastTotalPointsKey = "pastTotalPoints";

  static const String eventsCollection = "events";

  static const String titleKey = "title";
  static const String descriptionKey = "description";
  static const String dateKey = "date";
  static const String timeKey = "time";
  static const String pointRewardKey = "pointReward";
  static const String locationKey = "location";
  static const String sourceKey = "source";
  static const String typeKey = "type";

  Future<List<UserData>> getUserList() async {
    List<UserData> users = [];
    QuerySnapshot userInfo = await database.collection(usersCollection).get();
    for (QueryDocumentSnapshot user in userInfo.docs) {
      users.add(
        UserData(
          userId: user.id,
          name: user.get(nameKey) as String,
          email: user.get(emailKey) as String,
          profilePic: user.get(profilePicKey) as String,
          currentEvents: user.get(currentEventsKey) as List<String>,
          pastEvents: user.get(pastEventsKey) as List<String>,
          pastTotalPoints: user.get(pastTotalPointsKey) as List<int>,
          points: user.get(pointsKey) as int,
          grade: user.get(gradeKey) as int,
        ),
      );
    }
    return users;
  }

  Future<UserData> getUserData(String id) async {
    DocumentSnapshot userInfo =
        await database.collection(usersCollection).doc(id).get();
    return UserData(
      userId: userInfo.id,
      name: userInfo.get(nameKey) as String,
      email: userInfo.get(emailKey) as String,
      profilePic: userInfo.get(profilePicKey) as String,
      currentEvents: (userInfo.get(currentEventsKey) as List).cast<String>(),
      pastEvents: (userInfo.get(pastEventsKey) as List).cast<String>(),
      pastTotalPoints: (userInfo.get(pastTotalPointsKey) as List).cast<int>(),
      points: userInfo.get(pointsKey) as int,
      grade: userInfo.get(gradeKey) as int,
    );
  }

  Future<String> getUserId(String email) async {
    QuerySnapshot currentUsers = await database
        .collection(usersCollection)
        .where(emailKey, isEqualTo: email)
        .get();
    return currentUsers.docs[0].id;
  }

  Future<void> modifyUserData(String id, UserData newUserData) async {
    FirebaseFirestore.instance.collection(usersCollection).doc(id).update({
      nameKey: newUserData.name,
      profilePicKey: newUserData.profilePic,
      emailKey: newUserData.email,
      pointsKey: newUserData.points,
      gradeKey: newUserData.grade,
      pastEventsKey: newUserData.pastEvents,
      pastTotalPointsKey: newUserData.pastTotalPoints,
      currentEventsKey: newUserData.currentEvents,
    });
  }

  Future<bool> doesUserExist(String email) async {
    QuerySnapshot currentUsers = await database
        .collection(usersCollection)
        .where(emailKey, isEqualTo: email)
        .get();
    return currentUsers.docs.isEmpty;
  }

  void addUser(String name, String email, String profilePic) {
    Map<String, dynamic> userInfo = Map();
    userInfo[nameKey] = name;
    userInfo[emailKey] = email;
    userInfo[profilePicKey] = profilePic;
    userInfo[currentEventsKey] = [];
    userInfo[pastEventsKey] = [];
    userInfo[pointsKey] = 0;
    userInfo[gradeKey] = 0;
    userInfo[pastTotalPointsKey] = [];
    database.collection(usersCollection).add(userInfo);
  }

  Future<List<Events>> getEventList() async {
    List<Events> events = [];
    QuerySnapshot eventInfo = await database.collection(eventsCollection).get();
    for (QueryDocumentSnapshot event in eventInfo.docs) {
      events.add(
        Events(
          eventId: event.id,
          title: event.get(titleKey) as String,
          description: event.get(descriptionKey) as String,
          date: event.get(dateKey) as String,
          time: event.get(timeKey) as String,
          pointReward: event.get(pointRewardKey) as int,
          source: event.get(sourceKey) as String,
          type: event.get(typeKey) as String,
          location: event.get(locationKey) as String,
        ),
      );
    }
    return events;
  }

  void addEvent(Events newEvent) {
    Map<String, dynamic> eventInfo = Map();
    eventInfo[titleKey] = newEvent.title;
    eventInfo[descriptionKey] = newEvent.description;
    eventInfo[dateKey] = newEvent.date;
    eventInfo[timeKey] = newEvent.time;
    eventInfo[pointRewardKey] = newEvent.pointReward;
    eventInfo[locationKey] = newEvent.location;
    eventInfo[sourceKey] = newEvent.source;
    eventInfo[typeKey] = newEvent.type;
    database.collection(eventsCollection).add(eventInfo);
  }
}
