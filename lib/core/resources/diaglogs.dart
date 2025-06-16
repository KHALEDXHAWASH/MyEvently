import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoadingDialog(BuildContext context,
      {String? message, bool isDismissible = true}) {
    showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (context) {
        List<Widget> children = [];
        if (message != null) {
          children.add(Text(message));
          children.add(Spacer());
          children.add(CircularProgressIndicator());
        } else {
          children.add(CircularProgressIndicator());
        }
        return CupertinoAlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessageDialog(
      BuildContext context, {
        String? title,
        String? content,
        String? postTitle,
        VoidCallback? posAction,
        String? negTitle,
        VoidCallback? negAction,
      }) {
    showDialog(
        context: context,
        builder: (context) {
          List<Widget> actions = [];
          if (postTitle != null) {
            actions.add(TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  posAction?.call();
                },
                child: Text(postTitle)));
          }
          if (negTitle != null) {
            actions.add(TextButton(
                onPressed: () {
                  negAction?.call();
                },
                child: Text(negTitle)));
          }
          return CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            content: content != null ? Text(content) : null,
            actions: actions,
          );
        });
  }
}