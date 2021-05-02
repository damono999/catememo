import 'package:catememo/screen/login_screen.dart';
import 'package:catememo/screen/create_memo_screen.dart';
import 'package:catememo/screen/memos_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return MemosScreen();
          }
          return LoginScreen();
        },
      ),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        MemosScreen.routeName: (ctx) => MemosScreen(),
        CreateMemoScreen.routeName: (ctx) => CreateMemoScreen(),
      },
    );
  }
}
