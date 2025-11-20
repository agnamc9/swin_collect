import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future showInfoDialog(
  BuildContext context, {
  String title = 'INFORMATION',
  required String message,
  String positiveLabel = 'OK',
  String negativeLabel = '',
  Function? positiveCallBack,
  Function? negativeCallBack,
  bool dismissible = false,
  bool? result,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(title),
        content: SingleChildScrollView(child: Text(message)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              if (positiveCallBack != null) positiveCallBack();
            },
            child: Text(positiveLabel),
          ),
          Visibility(
            visible: negativeLabel != '',
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, false);
                if (negativeCallBack != null) negativeCallBack();
              },
              child: Text(negativeLabel),
            ),
          ),
        ],
      );
    },
  );
}

Future showLoadingDialog(
  BuildContext context, {
  String message = 'Veuillez patienter...',
  bool dismissible = true,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: dismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        elevation: 0,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator()),
                Gap(16),
                Expanded(child: Text(message)),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future showInfoRetryDialog(
  BuildContext context, {
  required String message,
  String positiveLabel = 'REESSAYER',
  String negativeLabel = 'ANNULER',
  Function? positiveCallBack,
}) {
  return showInfoDialog(
    context,
    message: message,
    positiveLabel: positiveLabel,
    negativeLabel: negativeLabel,
    positiveCallBack: positiveCallBack,
    negativeCallBack: () {
      Navigator.pop(context);
    },
  );
}
