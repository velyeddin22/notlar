import 'package:flutter/material.dart';

appSnackBar(
    {@required BuildContext? context,
    @required String? msg,
    @required bool? isError}) {
  return ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: isError! ? Colors.black : Colors.pink,
      content: Text(
        msg!,
        style: TextStyle(
          color: isError ? Colors.white : Colors.black,
        ),
      ),
      duration: Duration(seconds: 2),
    ),
  );
}
