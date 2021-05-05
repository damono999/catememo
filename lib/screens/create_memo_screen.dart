import 'package:catememo/enums/color_enum.dart';
import 'package:catememo/providers/auth_provider.dart';
import 'package:catememo/screens/login_screen.dart';
import 'package:catememo/widgets/appBottomNavigation.dart';
import 'package:catememo/widgets/textfileds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class CreateMemoScreen extends StatefulWidget {
  static final String routeName = "create-memo";

  @override
  _CreateMemoScreenState createState() => _CreateMemoScreenState();
}

class _CreateMemoScreenState extends State<CreateMemoScreen> {
  TextEditingController _memoController;
  TextEditingController _titleController;
  String _memo = "";
  String _title = "";
  int _selectedColorId;
  var _isPreview = false;
  var _isSending = false;
  var _isFirstCall = true;
  final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstCall) {
      setState(() {
        _memoController = new TextEditingController(text: _memo);
        _titleController = new TextEditingController(text: _title);
        _isFirstCall = false;
        _selectedColorId = 99;
      });
    }
  }

  void _sendMessage(BuildContext ctx) async {
    setState(() {
      _isSending = true;
    });
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final now = DateTime.now();
      await FirebaseFirestore.instance.collection('memos').doc().set({
        'uid': ctx.read<AuthProvider>().getUser.uid,
        'colorId': _selectedColorId,
        'memo': _memo,
        'title': _title,
        'createdAt': now,
        'updatedAt': now,
      });

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('メモを保存しました'),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('メモの保存に失敗しました'),
        ),
      );
    }
    if (_isSending == null) return;
    setState(() {
      _memo = "";
      _title = "";
      _memoController.clear();
      _titleController.clear();
      _isSending = false;
    });
  }

  bool _checkSending() {
    return _isSending || _memo.trim().isEmpty || _title.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メモ作成'),
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
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  color: _checkSending()
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_checkSending()) return;
                    _sendMessage(context);
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButton<int>(
                      value: _selectedColorId,
                      dropdownColor: Colors.grey[50],
                      underline: Container(),
                      onChanged: (int value) {
                        setState(() {
                          _selectedColorId = value;
                        });
                      },
                      selectedItemBuilder: (context) {
                        return ColorEnumList.getEnum.map((ColorEnum color) {
                          return Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: color.color,
                                maxRadius: 13,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              DefaultTextStyle(
                                style: TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                child: Text(
                                  color.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                      items: ColorEnumList.getEnum.map((ColorEnum color) {
                        return DropdownMenuItem(
                          value: color.id,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: color.color,
                                maxRadius: 11,
                              ),
                              SizedBox(width: 16),
                              Text(
                                color.name,
                                style: color.id == _selectedColorId
                                    ? TextStyle(fontWeight: FontWeight.bold)
                                    : TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: _isPreview,
                  onChanged: (bool value) {
                    setState(() {
                      _isPreview = value;
                    });
                  },
                ),
              ],
            ),
            _isPreview
                ? Container(
                    padding: EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    child: MarkdownBody(
                      data: "# " + _title,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getTextField(
                      _titleController,
                      (value) {
                        print(value);
                        setState(() {
                          _title = value;
                        });
                      },
                      maxLines: 1,
                      hintText: "タイトル",
                    ),
                  ),
            _isPreview
                ? Container(
                    padding: EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    child: MarkdownBody(
                      data: _memo,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(8),
                    child: getTextField(
                      _memoController,
                      (value) {
                        print(value);
                        setState(() {
                          _memo = value;
                        });
                      },
                      maxLines: null,
                      hintText: "メモ",
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(1),
    );
  }
}
