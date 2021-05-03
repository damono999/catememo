import 'package:flutter/material.dart';

Widget getTextField(
  TextEditingController controller,
  Function handleChangeFn, {
  int maxLines = 1,
  String hintText = "",
}) {
  return TextField(
    maxLines: maxLines,
    controller: controller,
    keyboardType: TextInputType.multiline,
    onChanged: handleChangeFn,
    cursorRadius: Radius.circular(10),
    style: TextStyle(fontSize: 16),
    decoration: InputDecoration(
      hintText: hintText,
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
