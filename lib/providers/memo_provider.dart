import 'package:catememo/models/Memo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemoProvider with ChangeNotifier {
  List<Memo> _memos = [];

  List<Memo> get getMemos {
    return [..._memos];
  }

  void setMemos(List<Memo> memos) {
    _memos = memos;
    notifyListeners();
  }

  Future<void> fetchMemo(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('memos')
        .where('uid', isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .get();
    var memos = <Memo>[];
    snapshot.docs.forEach((doc) {
      memos.add(Memo.create(doc));
    });
    setMemos(memos);
  }

  void removeAt(int index) {
    final clone = [..._memos];
    clone.removeAt(index);
    setMemos(clone);
  }

  void updateMemo(Memo memo) {
    final clone = _memos.map((e) => e.id == memo.id ? memo : e).toList();
    setMemos(clone);
  }

  void clear() {
    _memos = [];
  }
}
