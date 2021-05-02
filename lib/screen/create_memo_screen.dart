import 'package:catememo/enums/category_enum.dart';
import 'package:catememo/widgets/AppBottomNavigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_screen.dart';

// ignore: must_be_immutable
class CreateMemoScreen extends StatefulWidget {
  static final String routeName = "create-memo";
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  _CreateMemoScreenState createState() => _CreateMemoScreenState();
}

class _CreateMemoScreenState extends State<CreateMemoScreen> {
  TextEditingController _textController;
  String _enteredMessage = "";
  int _selectedCategoryId;
  var _isPreview = false;
  var _isSending = false;
  var _isFirstCall = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstCall) {
      setState(() {
        // _enteredMessage = initText;
        _textController = new TextEditingController(text: _enteredMessage);
        _isFirstCall = false;
      });
    }
  }

  void _sendMessage(BuildContext ctx) async {
    print(_enteredMessage);
    // setState(() {
    //   _isSending = true;
    // });
    // try {
    //   await Firestore.instance
    //       .collection('users')
    //       .document(authProvider.getUid)
    //       .collection('memos')
    //       .document(_videoMetaData.memo.videoId)
    //       .setData({
    //     'categoryId': _selectedCategoryId,
    //     'createdAt': _videoMetaData.memo.createdAt,
    //     'text': _enteredMessage,
    //     'time': _videoMetaData.memo.time ?? metaData.duration.inSeconds ?? 0,
    //     'title': _videoMetaData.memo.title ?? metaData.title ?? '',
    //     'videoId': _videoMetaData.memo.videoId,
    //   });
    //   Scaffold.of(ctx).showSnackBar(
    //     SnackBar(
    //       content: Text('メモを保存しました'),
    //     ),
    //   );
    //   final memosProvider = Provider.of<MemosProvider>(context, listen: false);
    //   int monthDataListsize = memosProvider.getMonthDataListCount;
    //   if (monthDataListsize != 0) {
    //     memosProvider.getTargetMonthData(monthDataListsize - 1).isFirst = true;
    //   }
    // } catch (e) {
    //   print(e);
    //   Scaffold.of(ctx).showSnackBar(
    //     SnackBar(
    //       content: Text('メモの保存に失敗しました'),
    //     ),
    //   );
    // }
    // if (_isSending == null) return;
    // setState(() {
    //   _isSending = false;
    // });
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
              onPressed: () {
                FirebaseAuth.instance.signOut();
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
      body: Builder(builder: (ctx) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    color: _isSending || _enteredMessage.trim().isEmpty
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_enteredMessage.trim().isEmpty && _isSending) return;
                      _sendMessage(ctx);
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: DropdownButton<int>(
                        // value: _selectedCategoryId,
                        dropdownColor: Colors.grey[50],
                        underline: Container(),
                        onChanged: (int value) {
                          setState(() {
                            // _selectedCategoryId = value;
                          });
                        },
                        selectedItemBuilder: (context) {
                          return CategoryEnumList.getEnum
                              .map((CategoryEnum caterogy) {
                            return Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: caterogy.color,
                                  child: Icon(
                                    caterogy.icon,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  maxRadius: 16,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                DefaultTextStyle(
                                  style: TextStyle(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  child: Text(
                                    caterogy.name,
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
                        items: CategoryEnumList.getEnum
                            .map((CategoryEnum caterogy) {
                          return DropdownMenuItem(
                            value: caterogy.id,
                            child: Text(
                              caterogy.name,
                              style: caterogy.id == _selectedCategoryId
                                  ? TextStyle(fontWeight: FontWeight.bold)
                                  : TextStyle(fontWeight: FontWeight.normal),
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
                        data: _enteredMessage,
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 8),
                      padding: EdgeInsets.all(8),
                      child: _getTextField(),
                    ),
            ],
          ),
        );
      }),
      bottomNavigationBar: AppBottomNavigationBar(1),
    );
  }

  Widget _getTextField() {
    return TextField(
      maxLines: null,
      controller: _textController,
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        setState(() {
          _enteredMessage = value;
        });
      },
      cursorRadius: Radius.circular(10),
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: 'メモを入力しましょう',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      textAlignVertical: TextAlignVertical.center,
    );
  }
}
