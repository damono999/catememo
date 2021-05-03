import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:catememo/widgets/accordion.dart';
import 'package:catememo/screens/login_screen.dart';
import 'package:catememo/widgets/appBottomNavigation.dart';

// ignore: must_be_immutable
class MemosScreen extends StatelessWidget {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  static final String routeName = "memos";
  List<Item> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                await googleLogin.signOut();

                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              },
              child: Text(
                "ログアウト",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._data
                .map((e) => Accordion(
                      headerText:
                          "アコーディオンアコーディオンアコーディオンアコーディオンアコーディオンアコーディオンアコーディオン",
                      body: "To delete this panel, tap the trash can icon",
                      icon: Icons.ac_unit,
                      iconColor: Colors.white,
                    ))
                .toList(),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(0),
    );
  }
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}
