import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/authentication/landing_screen.dart';
import 'package:stegmessage/authentication/login_screen.dart';
import 'package:stegmessage/authentication/otp_screen.dart';
import 'package:stegmessage/authentication/user_information_screen.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/firebase_options.dart';
import 'package:stegmessage/main_screens/chat_screen.dart';
import 'package:stegmessage/main_screens/friend_request_screen.dart';
import 'package:stegmessage/main_screens/friends_screen.dart';
import 'package:stegmessage/main_screens/home_screen.dart';
import 'package:stegmessage/main_screens/profile_screen.dart';
import 'package:stegmessage/main_screens/settings_screen.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/providers/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: const Color.fromARGB(255, 47, 95, 196),
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color.fromARGB(255, 26, 51, 106),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StegMessage',
        theme: theme,
        darkTheme: darkTheme,
        initialRoute: Constants.landingScreen,
        routes: {
          Constants.landingScreen: (context) => const LandingScreen(),
          Constants.loginScreen: (context) => const LoginScreen(),
          Constants.otpScreen: (context) => const OtpScreen(),
          Constants.userInformationScreen: (context) =>
              const UserInformationScreen(),
          Constants.homeScreen: (context) => const HomeScreen(),
          Constants.profileScreen: (context) => const ProfileScreen(),
          Constants.settingsScreen: (context) => const SettingsScreen(),
          Constants.friendsScreen: (context) => const FriendsScreen(),
          Constants.friendRequestScreen: (context) =>
              const FriendRequestScreen(),
          Constants.chatScreen: (context) => const ChatScreen(),
        },
      ),
    );
  }
}
