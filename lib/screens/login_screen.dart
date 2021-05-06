import 'package:catememo/screens/memos_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  static final routeName = "login";
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("カテメモ"),
      ),
      body: Center(
        child: GestureDetector(
          child: Image.asset("assets/google_button.png"),
          onTap: () async {
            GoogleSignInAccount signinAccount = await googleLogin.signIn();
            if (signinAccount == null) return;
            GoogleSignInAuthentication auth =
                await signinAccount.authentication;
            final GoogleAuthCredential credential =
                GoogleAuthProvider.credential(
              idToken: auth.idToken,
              accessToken: auth.accessToken,
            );
            await FirebaseAuth.instance.signInWithCredential(credential);
            Navigator.of(context).pushReplacementNamed(MemosScreen.routeName);
          },
        ),
      ),
    );
  }
}
