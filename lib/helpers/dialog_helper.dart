import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/routes/route_names.dart';

class DialogHelper {
  static var showingDialog = false;

  static Future<void> showNoInternetDialog(BuildContext context) async {
    if (!showingDialog) {
      showingDialog = true;
      await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'You have lost your internet connection. Please check your settings and try again.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                showingDialog = false;
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteNames.splash,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );
    }
  }

  static Future<void> showCheckoutDialog(BuildContext context) async {
    if (!showingDialog) {
      showingDialog = true;
      await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Order placed!'),
          content: const Text('Please await for our call.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Ok',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.black,
                    ),
              ),
              onPressed: () {
                showingDialog = false;
                Navigator.of(context).popUntil(
                  (route) => route.settings.name == RouteNames.main,
                );
              },
            ),
          ],
        ),
      );
    }
  }
}