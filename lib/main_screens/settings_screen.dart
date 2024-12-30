import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/providers/authentication_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkTheme = false;

  // get the saved theme
  void getThemeMode() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();

    if (savedThemeMode == AdaptiveThemeMode.dark) {
      setState(() {
        isDarkTheme = true;
      });
    } else {
      setState(() {
        isDarkTheme = false;
      });
    }
  }

  @override
  void initState() {
    getThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel!;
    // getting the uid from the argument
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
        actions: [
          currentUser.uid == uid
              ? IconButton(
                  onPressed: () async {
                    // dialogue to confirm logout
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await context
                                  .read<AuthenticationProvider>()
                                  .logout()
                                  .whenComplete(() {
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(context,
                                    Constants.loginScreen, (route) => false);
                              });
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                )
              : const SizedBox()
        ],
      ),
      body: Center(
        child: Card(
          child: SwitchListTile(
            title: const Text('Change the Theme'),
            secondary: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkTheme ? Colors.white : Colors.black),
              child: Icon(
                isDarkTheme ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                color: isDarkTheme ? Colors.black : Colors.white,
              ),
            ),
            value: isDarkTheme,
            onChanged: (value) {
              setState(() {
                isDarkTheme = value;
              });
              if (value) {
                AdaptiveTheme.of(context).setDark();
              } else {
                AdaptiveTheme.of(context).setLight();
              }
            },
          ),
        ),
      ),
    );
  }
}
