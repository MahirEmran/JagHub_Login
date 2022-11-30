import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as prefix;
import 'user.dart';

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
  static const String gradeKey = "grades";
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

  Future<List<User>> getUserList() async {
    List<User> users = [];
    QuerySnapshot userInfo = await database.collection(usersCollection).get();
    for (QueryDocumentSnapshot user in userInfo.docs) {
      users.add(
        User(
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

  Future<User> getUserData(String id) async {
    DocumentSnapshot userInfo =
        await database.collection(usersCollection).doc(id).get();
    return User(
      userId: userInfo.id,
      name: userInfo.get(nameKey) as String,
      email: userInfo.get(emailKey) as String,
      profilePic: userInfo.get(profilePicKey) as String,
      currentEvents: userInfo.get(currentEventsKey) as List<String>,
      pastEvents: userInfo.get(pastEventsKey) as List<String>,
      pastTotalPoints: userInfo.get(pastTotalPointsKey) as List<int>,
      points: userInfo.get(pointsKey) as int,
      grade: userInfo.get(gradeKey) as int,
    );
  }

  Future<void> modifyUserData(String id, User newUserData) async {
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
    database.collection(usersCollection).add(eventInfo);
  }
}
