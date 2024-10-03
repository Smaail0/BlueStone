import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/widgets/friends_list.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friends',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Column(
        children: [
          // cupertino search bar
          CupertinoSearchTextField(
            placeholder: 'Search',
            style: const TextStyle(color: Colors.white),
            prefixIcon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            onChanged: (value) {
              print(value);
            },
          ),
          const Expanded(
              child: FriendsList(
            viewType: FRIENDVIEWTYPE.friends,
          ))
        ],
      ),
    );
  }
}
