import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/utilities/assets_manager.dart';
import 'package:stegmessage/models/user_model.dart';
import 'package:stegmessage/utilities/global_methods.dart';

import 'chat_list_screens.dart';
import 'stations_screen.dart';
import 'people_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  final List<Widget> pages = const [
    ChatListScreens(),
    StationsScreen(),
    PeopleScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          leading: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    AssetsManager.stegLogo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Transform.translate(
                offset: Offset(-12, 0),
                child: Text(
                  'StegMessage',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Container(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: userImageWidget(
                      imageUrl: authProvider.userModel!.image,
                      radius: 20,
                      onTap: () {
                        // Navigate to user profile
                        Navigator.pushNamed(context, Constants.profileScreen,
                            arguments: authProvider.userModel!.uid);
                      })),
            ),
          ],
        ),
        body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            children: pages),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidCommentDots),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.bolt,
                size: 18,
              ),
              label: 'Stations',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.globe,
                size: 20,
              ),
              label: 'People',
            ),
          ],
          currentIndex: currentIndex,
          onTap: (index) {
            // animate to the page.
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeIn);
            setState(() {
              currentIndex = index;
            });
          },
        ));
  }
}
