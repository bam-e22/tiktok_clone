import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/common/widgets/video_config.dart';

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
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ValueListenableBuilder(
            valueListenable: videoConfig,
            builder: (context, value, child) {
              return SwitchListTile.adaptive(
                value: value,
                onChanged: (value) {
                  videoConfig.value = !videoConfig.value;
                },
                title: const Text('Auto Mute'),
                subtitle: const Text('Videos will be muted by default'),
              );
            },
          ),
          SwitchListTile.adaptive(
            value: _notifications,
            onChanged: _onNotificationsChanged,
            title: const Text('Enable notifications'),
          ),
          CheckboxListTile(
            value: _marketingEmails,
            onChanged: _onMarketingEmailsChanged,
            title: const Text('Marketing emails'),
            subtitle: const Text("We won't spam you."),
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
              if (kDebugMode) {
                print("date= $date");
              }

              if (!mounted) return;
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (kDebugMode) {
                print("time= $time");
              }
              if (!mounted) return;
              final booking = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                        appBarTheme: const AppBarTheme(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    )),
                    child: child!,
                  );
                },
              );
              if (kDebugMode) {
                print("booking= $booking");
              }
            },
            title: const Text('What is your birthday?'),
          ),
          const AboutListTile(),
          ListTile(
            title: const Text(
              'Log out (iOS)',
            ),
            textColor: Colors.red,
            onTap: () => showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text("Are you sure?"),
                content: const Text("Please don't go"),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('No'),
                  ),
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(),
                    isDestructiveAction: true,
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Log out (Android)',
            ),
            textColor: Colors.red,
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Are you sure?"),
                content: const Text("Please don't go"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Log out (iOS / Bottom)',
            ),
            textColor: Colors.red,
            onTap: () => showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: const Text("Are you sure?"),
                message: const Text("Please don't go"),
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Not log out'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () => Navigator.of(context).pop(),
                    isDestructiveAction: true,
                    child: const Text('Yes please'),
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
