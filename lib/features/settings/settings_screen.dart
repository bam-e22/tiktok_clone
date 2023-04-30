import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;
  bool _marketingEmails = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  void _onMarketingEmailsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _marketingEmails = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: _notifications,
            onChanged: _onNotificationsChanged,
            title: Text('Enable notifications'),
          ),
          CheckboxListTile(
            value: _marketingEmails,
            onChanged: _onMarketingEmailsChanged,
            title: Text('Marketing emails'),
            subtitle: Text("We won't spam you."),
            activeColor: Theme.of(context).primaryColor,
          ),
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );
              print("date= $date");
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              print("time= $time");
              final booking = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    child: child!,
                    data: ThemeData(
                        appBarTheme: AppBarTheme(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    )),
                  );
                },
              );
              print("booking= $booking");
            },
            title: Text('What is your birthday?'),
          ),
          AboutListTile(),
          ListTile(
            title: Text(
              'Log out (iOS)',
            ),
            textColor: Colors.red,
            onTap: () => showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text("Are you sure?"),
                content: Text("Please don't go"),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('No'),
                  ),
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(),
                    isDestructiveAction: true,
                    child: Text('Yes'),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Log out (Android)',
            ),
            textColor: Colors.red,
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Are you sure?"),
                content: Text("Please don't go"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Yes'),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Log out (iOS / Bottom)',
            ),
            textColor: Colors.red,
            onTap: () => showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: Text("Are you sure?"),
                message: Text("Please don't go"),
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Not log out'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () => Navigator.of(context).pop(),
                    isDestructiveAction: true,
                    child: Text('Yes please'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
