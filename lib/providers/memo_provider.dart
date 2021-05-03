import 'package:catememo/models/Memo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemoProvider with ChangeNotifier {
  List<Memo> _memos = [];

  List<Memo> get getMemos {
    return _memos;
  }

  void setMemos(List<Memo> memos) {
    _memos = memos;
  }

  Future<void> fetchMemo() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('memos')
        .orderBy("createdAt", descending: true)
        .get();
    var memos = <Memo>[];
    snapshot.docs.forEach((doc) {
      memos.add(Memo.create(doc));
    });
    setMemos(memos);
    notifyListeners();
  }

  void removeAt(int index) {
    final clone = [..._memos];
    clone.removeAt(index);
    _memos = clone;
    notifyListeners();
  }

  void clear() {
    _memos = [];
  }
}
