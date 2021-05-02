import 'package:catememo/screen/login_screen.dart';
import 'package:catememo/widgets/AppBottomNavigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class CreateMemoScreen extends StatelessWidget {
  static final String routeName = "create-memo";
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('かてめも'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Hello ", style: TextStyle(fontSize: 50)),
            SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                await Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              },
              child: Text('Logout', style: TextStyle(fontSize: 50)),
            )
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(1),
    );
  }
}
