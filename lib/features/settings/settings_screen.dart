import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/view_models/theme_mode_view_model.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme mode'),
            trailing: DropdownButton<ThemeMode>(
              value: ref.watch(themeConfigProvider).themeMode,
              items: ThemeMode.values
                  .map<DropdownMenuItem<ThemeMode>>((themeMode) {
                return DropdownMenuItem(
                  value: themeMode,
                  child: Text(themeMode.name),
                );
              }).toList(),
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  ref.read(themeConfigProvider.notifier).setThemeMode(value);
                }
              },
            ),
          ),
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).muted,
            onChanged: (value) async {
              await ref.read(playbackConfigProvider.notifier).setMuted(value);
            },
            title: const Text('Auto Mute'),
            subtitle: const Text('Videos will be muted by default'),
          ),
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).autoplay,
            onChanged: (value) async {
              await ref
                  .read(playbackConfigProvider.notifier)
                  .setAutoplay(value);
            },
            title: const Text('Autoplay'),
            subtitle: const Text('Video will start playing automatically.'),
          ),
          SwitchListTile.adaptive(
            value: false,
            onChanged: (value) {},
            title: const Text('Enable notifications'),
          ),
          CheckboxListTile(
            value: false,
            onChanged: (value) {},
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

              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (kDebugMode) {
                print("time= $time");
              }
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
