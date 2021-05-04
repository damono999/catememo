import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  final String id;
  final String uid;
  final String title;
  final String memo;
  final Timestamp createdAt;
  final Timestamp updateAt;

  Memo({
    this.id,
    this.uid,
    this.title,
    this.memo,
    this.createdAt,
    this.updateAt,
  });

  factory Memo.create(QueryDocumentSnapshot doc) {
    return Memo(
      id: doc.id,
      uid: doc.data()["uid"],
      title: doc.data()["title"],
      memo: doc.data()["memo"],
      createdAt: doc.data()["createdAt"],
      updateAt: doc.data()["updatedAt"],
    );
  }
}
