import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mad2_login/API.dart';
import 'package:mad2_login/landing_page.dart';

import 'authentication.dart';
import 'user_data.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 255, 255, 255)),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                User? user =
                    await Authentication.signInWithGoogle(context: context);
                if (user == null) {
                  return;
                }
                String email = user.email!;
                bool userExists = await API().doesUserExist(email);

                setState(() {
                  _isSigningIn = false;
                });

                if (!userExists) {
                  String userId = await API().getUserId(email);
                  UserData userData = await API().getUserData(userId);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LandingPage(
                        user: userData,
                      ),
                    ),
                  );
                } else {
                  await _inputGradeDialog(context, user);
                  String userId = await API().getUserId(user.email!);
                  UserData userData = await API().getUserData(userId);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LandingPage(
                        user: userData,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Rubik_bold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _inputGradeDialog(BuildContext context, User user) async {
    int dropdownvalue = 0;
    List<DropdownMenuItem<int>> buttons = [];
    buttons.addAll([
      DropdownMenuItem<int>(
          value: 9,
          child: Text(
            "9",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          )),
      DropdownMenuItem<int>(
          value: 10,
          child: Text(
            "10",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          )),
      DropdownMenuItem<int>(
          value: 11,
          child: Text(
            "11",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          )),
      DropdownMenuItem<int>(
          value: 12,
          child: Text(
            "12",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          )),
    ]);

    bool okPressed = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            title: Text(
              'Hi there!',
              style: TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'Rubik_bold',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 240,
                child: Column(
                  children: [
                    Text(
                      'You seem new to this app. To finish making your account, input your grade level below!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      dropdownColor: Color.fromARGB(255, 255, 255, 255),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: Text(
                        'Grade Level',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      items: buttons,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 0, 0, 0)),
                      onChanged: (newValue) {
                        setState(() {
                          dropdownvalue = newValue as int;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        elevation: 2,
                        backgroundColor: Color.fromARGB(255, 76, 56, 239),
                      ),
                      child: Text('Set'),
                      onPressed: () {
                        setState(() {
                          okPressed = true;
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).then((val) async {
      if (!okPressed) {
        dropdownvalue = 0;
        return;
      }
      API().addUser(user.displayName!, user.email!, user.photoURL!);
      String userId = await API().getUserId(user.email!);
      UserData currentUser = await API().getUserData(userId);
      UserData modifiedUser = UserData(
          userId: userId,
          email: currentUser.email,
          profilePic: currentUser.profilePic,
          name: currentUser.name,
          currentEvents: currentUser.currentEvents,
          pastEvents: currentUser.pastEvents,
          points: currentUser.points,
          grade: dropdownvalue,
          pastTotalPoints: currentUser.pastTotalPoints);
      API().modifyUserData(
        userId,
        modifiedUser,
      );

      setState(() {});
    });
  }
}
