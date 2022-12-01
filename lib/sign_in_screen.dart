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
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Text(
                      'Welcome',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 50,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                      textScaleFactor: 1.25,
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 0, 126, 255),
                    ),
                  );
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
