import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/widgets/friends_list.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friend requests',
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
            prefixIcon: const Icon(Icons.search),
            onChanged: (value) {
              print(value);
            },
          ),
          const Expanded(
              child: FriendsList(
            viewType: FRIENDVIEWTYPE.friendRequests,
          ))
        ],
      ),
    );
  }
}
