import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemoProvider with ChangeNotifier {
  Future<QuerySnapshot> fetchMemo() {
    return FirebaseFirestore.instance.collection('memos').get();
  }
}
