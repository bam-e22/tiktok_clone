import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'generated/l10n.dart';

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

extension StringResourceHelper on BuildContext {
  S get string => S.of(this);
}

void showFirebaseErrorSnack(
    BuildContext context, FirebaseException? exception) {
  final snackBar = SnackBar(
    content: Text(exception?.message ?? "Something went wrong"),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
