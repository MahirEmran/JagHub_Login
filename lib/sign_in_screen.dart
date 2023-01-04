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
                    SizedBox(height: 10),
                    Text(
                      'JagHub',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 40,
                        fontFamily: 'Rubik_bold',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.7,
                      ),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.25,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'An NCHS event, group, and points tracker that rewards you for showing your jaguar spirit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                      ),
                      textScaleFactor: 1.25,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .05),
                  ],
                ),
              ),
              Image(
                image: AssetImage("assets/signinscreendesign.png"),
                height: MediaQuery.of(context).size.height * .35,
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: (FutureBuilder(
                      future:
                          Authentication.initializeFirebase(context: context),
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
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
