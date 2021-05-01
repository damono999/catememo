import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'catememo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
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
        child: TextButton(
          onPressed: () async {
            GoogleSignInAccount signinAccount = await googleLogin.signIn();
            if (signinAccount == null) return;
            GoogleSignInAuthentication auth =
                await signinAccount.authentication;
            final GoogleAuthCredential credential =
                GoogleAuthProvider.credential(
              idToken: auth.idToken,
              accessToken: auth.accessToken,
            );
            User user =
                (await FirebaseAuth.instance.signInWithCredential(credential))
                    .user;
            if (user != null) {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LogoutPage(user);
                }),
              );
            }
          },
          child: Text(
            'login',
            style: TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }
}

class LogoutPage extends StatelessWidget {
  User user;
  LogoutPage(this.user);
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Hello ${user.displayName}", style: TextStyle(fontSize: 50)),
            SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                await googleLogin.signIn();
                await Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
              child: Text('Logout', style: TextStyle(fontSize: 50)),
            )
          ],
        ),
      ),
    );
  }
}
