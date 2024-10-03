import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/models/user_model.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/utilities/global_methods.dart';

class GroupAppBar extends StatefulWidget {
  const GroupAppBar({super.key, required this.groupID});

  final String groupID;

  @override
  State<GroupAppBar> createState() => _GroupAppBarState();
}

class _GroupAppBarState extends State<GroupAppBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context
          .read<AuthenticationProvider>()
          .userStream(userID: widget.groupID),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final groupModel =
            UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

        return Row(
          children: [
            userImageWidget(
              imageUrl: groupModel.image,
              radius: 20,
              onTap: () {
                // navigate to group profile screen
              },
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupModel.name,
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'groupe description or group members',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            const SizedBox(width: 50),
          ],
        );
      },
    );
  }
}
