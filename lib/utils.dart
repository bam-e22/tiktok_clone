import 'package:flutter/cupertino.dart';

import 'generated/l10n.dart';

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

extension StringResourceHelper on BuildContext {
  S get string => S.of(this);
}
