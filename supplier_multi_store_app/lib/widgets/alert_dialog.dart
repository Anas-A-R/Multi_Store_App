import 'package:flutter/cupertino.dart';

class MyAlertDialog {
  showAlertDialog({
    required String title,
    required String content,
    required Function() tabNo,
    required Function() tabYes,
    required BuildContext context,
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(onPressed: tabNo, child: const Text('NO')),
            CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: tabYes,
                child: const Text('YES')),
          ],
        );
      },
    );
  }
}
