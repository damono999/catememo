import 'package:flutter/material.dart';
import 'package:catememo/screen/create_memo_screen.dart';
import 'package:catememo/screen/memos_screen.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  AppBottomNavigationBar(this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: 'メモ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit),
          label: '作成',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart),
          label: 'チャート',
        ),
      ],
      onTap: (int index) {
        if (index == currentIndex) return;

        if (index == 0) {
          Navigator.of(context).pushReplacementNamed(MemosScreen.routeName);
        } else if (index == 1) {
          Navigator.of(context)
              .pushReplacementNamed(CreateMemoScreen.routeName);
        } else if (index == 2) {
          // Navigator.of(context).pushReplacementNamed(MemoListScreen.routeName);
        }
      },
    );
  }
}
