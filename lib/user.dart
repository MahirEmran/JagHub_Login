import 'package:flutter/gestures.dart';

class User {
  late String _userId;
  late String _email;
  late String _profilePic;
  late String _name;
  late List<String> _currentEvents;
  late List<String> _pastEvents;
  late int _points;
  late int _grade;
  late List<int> _pastTotalPoints;

  User({
    required String userId,
    required String email,
    required String profilePic,
    required String name,
    required List<String> currentEvents,
    required List<String> pastEvents,
    required int points,
    required int grade,
    required List<int> pastTotalPoints,
  }) {
    _userId = userId;
    _email = email;
    _profilePic = profilePic;
    _name = name;
    _currentEvents = currentEvents;
    _pastEvents = pastEvents;
    _points = points;
    _grade = grade;
    _pastTotalPoints = pastTotalPoints;
  }

  String get userId {
    return _userId;
  }

  String get email {
    return _email;
  }

  String get profilePic {
    return _profilePic;
  }

  String get name {
    return _name;
  }

  List<String> get currentEvents {
    return _currentEvents;
  }

  List<String> get pastEvents {
    return _pastEvents;
  }

  int get points {
    return _points;
  }

  int get grade {
    return _grade;
  }

  List<int> get pastTotalPoints {
    return _pastTotalPoints;
  }
}
