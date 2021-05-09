import 'package:catememo/models/Memo.dart';
import 'package:catememo/providers/auth_provider.dart';
import 'package:catememo/providers/memo_provider.dart';
import 'package:catememo/screens/edit_memo_screen.dart';
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
    final uid = context.watch<AuthProvider>().getUser?.uid ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () async {
                await googleLogin.signOut();
                await FirebaseAuth.instance.signOut();

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
      body: FutureBuilder<void>(
        future: context.read<MemoProvider>().fetchMemo(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Indicator();
          }

          return Selector<MemoProvider, List<Memo>>(
            selector: (_, model) => model.getMemos,
            builder: (ctx, memos, __) {
              print(memos);
              if (memos.length == 0) {
                return Center(
                  child: Text("メモがありません。"),
                );
              }

              return ListView.builder(
                itemCount: memos.length,
                itemBuilder: (_, index) {
                  return Accordion(
                    title: memos[index].title,
                    memo: memos[index].memo,
                    colorId: memos[index].colorId,
                    createdAt: memos[index].createdAt,
                    editFn: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditMemoScreen(
                            memo: memos[index],
                          ),
                        ),
                      );
                    },
                    removeFn: () async {
                      try {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        await FirebaseFirestore.instance
                            .collection("memos")
                            .doc(memos[index].id)
                            .delete();

                        ctx.read<MemoProvider>().removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("削除しました"),
                          ),
                        );
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("削除に失敗しました"),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(0),
    );
  }
}
