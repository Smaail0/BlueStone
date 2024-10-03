import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/models/user_model.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/utilities/global_methods.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel!;

    // get user data from argument
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        actions: [
          currentUser.uid == uid
              ? IconButton(
                  onPressed: () async {
                    // Navigate to the settings screen with uid as argument
                    await Navigator.pushNamed(
                      context,
                      Constants.settingsScreen,
                      arguments: uid,
                    );
                  },
                  icon: const Icon(Icons.settings),
                )
              : const SizedBox()
        ],
      ),
      body: StreamBuilder(
        stream: context.read<AuthenticationProvider>().userStream(userID: uid),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userModel =
              UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: Column(
              children: [
                // user image
                Center(
                  child: userImageWidget(
                    imageUrl: userModel.image,
                    radius: 60,
                    onTap: () {},
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  userModel.name,
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),
                Text(
                  userModel.phoneNumber,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 26, 51, 106),
                  ),
                ),

                const SizedBox(height: 10),
                buildFriendRequestButton(
                  currentUser: currentUser,
                  userModel: userModel,
                ),
                const SizedBox(
                  height: 5,
                ),

                buildFriendsButton(
                  currentUser: currentUser,
                  userModel: userModel,
                ),

                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: Divider(
                        color: Color.fromARGB(255, 26, 51, 106),
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'About me',
                      style: GoogleFonts.openSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const SizedBox(
                      height: 40,
                      width: 40,
                      child: Divider(
                        color: Color.fromARGB(255, 26, 51, 106),
                        thickness: 1,
                      ),
                    )
                  ],
                ),
                Text(
                  userModel.aboutMe,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

// friend request button
  Widget buildFriendRequestButton({
    required UserModel currentUser,
    required UserModel userModel,
  }) {
    if (currentUser.uid == userModel.uid &&
        userModel.friendRequestsUIDs.isNotEmpty) {
      return buildElevatedButton(
        onPressed: () {
          // navigate to friend request screen
          Navigator.pushNamed(
            context,
            Constants.friendRequestScreen,
          );
        },
        label: 'View Friend Requests',
        width: MediaQuery.of(context).size.width * 0.7,
      );
    } else {
      // not in our profile
      return const SizedBox.shrink();
    }
  }

  // friend button
  Widget buildFriendsButton({
    required UserModel currentUser,
    required UserModel userModel,
  }) {
    if (currentUser.uid == userModel.uid && userModel.friendsUIDs.isNotEmpty) {
      return buildElevatedButton(
        // navigate to friend request screen
        onPressed: () {
          // sent friend request
          Navigator.pushNamed(
            context,
            Constants.friendsScreen,
          );
        },
        label: 'View Friends',
        width: MediaQuery.of(context).size.width * 0.7,
      );
    } else {
      if (currentUser.uid != userModel.uid) {
        // show cancel friend request button when request was sent else show send friend request button

        if (userModel.friendRequestsUIDs.contains(currentUser.uid)) {
          return buildElevatedButton(
            // navigate to friend request screen
            onPressed: () async {
              // sent friend request
              await context
                  .read<AuthenticationProvider>()
                  .cancelFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                showSnackBar(context, 'Friend request Cancelled');
              });
            },
            label: 'Cancel Friend Request',
            width: MediaQuery.of(context).size.width * 0.7,
          );
        } else if (userModel.sentFriendRequestsUIDs.contains(currentUser.uid)) {
          return buildElevatedButton(
            // navigate to friend request screen
            onPressed: () async {
              // sent friend request
              await context
                  .read<AuthenticationProvider>()
                  .acceptFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                showSnackBar(
                    context, 'You are now friends with ${userModel.name}');
              });
            },
            label: 'Accept Friend Request',
            width: MediaQuery.of(context).size.width * 0.7,
          );
        } else if (userModel.friendsUIDs.contains(currentUser.uid)) {
          return Row(
            children: [
              Expanded(
                flex: 8,
                child: buildElevatedButton(
                  onPressed: () async {
                    // Show unfriend dialogue to ask the user if he wants to unfriend the user
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Unfriend ${userModel.name} ?',
                          textAlign: TextAlign.center,
                          style:
                              GoogleFonts.openSans(fontWeight: FontWeight.w700),
                        ),
                        content: Text(
                          'Are you sure you want to unfriend ${userModel.name}?',
                          textAlign: TextAlign.center,
                        ),
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
                                  .unfriend(friendID: userModel.uid)
                                  .whenComplete(() {
                                Navigator.pop(context);
                                showSnackBar(context,
                                    'You are no longer friends with ${currentUser.name}');
                              });
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                  label: 'Unfriend ${userModel.name}',
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.message,
                      color: Color.fromARGB(255, 26, 51, 106),
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // navigate to chat screen with the following arguments
                      // 1 friend uid
                      // 2 friend name
                      // 3 friend image
                      // 4 group id with an empty string

                      Navigator.pushNamed(
                        context,
                        Constants.chatScreen,
                        arguments: {
                          Constants.contactUID: userModel.uid,
                          Constants.contactName: userModel.name,
                          Constants.contactImage: userModel.image,
                          Constants.groupID: '',
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 26, 51, 106),
                      ),
                      onPressed: () {},
                    ),
                  ))
            ],
          );
        } else {
          return buildElevatedButton(
            // navigate to friend request screen
            onPressed: () async {
              // sent friend request
              await context
                  .read<AuthenticationProvider>()
                  .sendFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                showSnackBar(context, 'Friend request Sent');
              });
            },
            label: 'Send Friend Request',
            width: MediaQuery.of(context).size.width * 0.7,
          );
        }

        // show send friend request button
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  Widget buildElevatedButton({
    required VoidCallback onPressed,
    required String label,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
