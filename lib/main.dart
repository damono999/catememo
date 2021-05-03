import 'package:catememo/providers/auth_provider.dart';
import 'package:catememo/screens/login_screen.dart';
import 'package:catememo/screens/create_memo_screen.dart';
import 'package:catememo/screens/memos_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'catememo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              ctx.read<AuthProvider>().setUser(snapshot.data);
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
      ),
    );
  }
}
