import 'package:catememo/providers/memo_provider.dart';
import 'package:catememo/widgets/Indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:catememo/widgets/accordion.dart';
import 'package:catememo/screens/login_screen.dart';
import 'package:catememo/widgets/appBottomNavigation.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MemosScreen extends StatelessWidget {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  static final String routeName = "memos";

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
      body: FutureBuilder<QuerySnapshot>(
          future: context.read<MemoProvider>().fetchMemo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Indicator();
            }

            if (snapshot.hasData) {
              final count = snapshot.data.docs.length;
              if (count > 0) {
                return ListView.builder(
                  itemCount: count,
                  itemBuilder: (context, index) {
                    final data = snapshot.data.docs[index].data();
                    return Accordion(
                      title: data["title"],
                      memo: data["memo"],
                      icon: Icons.ac_unit,
                      iconColor: Colors.white,
                    );
                  },
                );
              }
            }
            return Center(
              child: Text("メモがありません。"),
            );
          }),
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
