import 'package:flutter/material.dart';

import 'authentication.dart';
import 'google_sign_in_button.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
        255,
        76,
        56,
        239,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      'MAD 2.0',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 35,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                      ),
                      textScaleFactor: 1.25,
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                    child: Text(
                      'The app for tracking your club attendance and points earned',
                      style: TextStyle(
                        color: Color.fromARGB(255, 199, 198, 198),
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                      ),
                      textScaleFactor: 1.25,
                    ),
                  )),
              Expanded(
                child: Image(
                  image: AssetImage("assets/signinscreendesign.png"),
                  height: 200.0,
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: (FutureBuilder(
                    future: Authentication.initializeFirebase(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error initializing Firebase');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return GoogleSignInButton();
                      }
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 255, 255, 255),
                        ),
                      );
                    },
                  ))),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
