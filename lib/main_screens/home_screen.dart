import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/utilities/assets_manager.dart';
import 'package:stegmessage/utilities/global_methods.dart';

import 'chat_list_screens.dart';
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
    PeopleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final userModel = authProvider.userModel;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                AssetsManager.blueStoneLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Transform.translate(
          offset: const Offset(-12, 0),
          child: Text(
            'BlueStone',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: userModel != null
                ? userImageWidget(
                    imageUrl: userModel.image,
                    radius: 20,
                    onTap: () {
                      // Naviguer vers l'écran du profil de l'utilisateur
                      Navigator.pushNamed(
                        context,
                        Constants.profileScreen,
                        arguments: userModel.uid,
                      );
                    },
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
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
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidCommentDots),
            label: 'Chat',
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
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
          );
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
