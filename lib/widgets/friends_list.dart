import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/models/user_model.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/utilities/global_methods.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({
    super.key,
    required this.viewType,
  });

  final FRIENDVIEWTYPE viewType;

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  late Future<List<UserModel>> future;
  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    final future = widget.viewType == FRIENDVIEWTYPE.friends
        ? context.read<AuthenticationProvider>().getFriendsList(uid)
        : context.read<AuthenticationProvider>().getFriendRequestsList(uid);

    return FutureBuilder<List<UserModel>>(
        future: future,
        builder: (context, snapchot) {
          if (snapchot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapchot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapchot.hasData || snapchot.data!.isEmpty) {
            return const Center(
              child: Text('No friends found'),
            );
          }

          return ListView.builder(
            itemCount: snapchot.data!.length,
            itemBuilder: (context, index) {
              final friend = snapchot.data![index];
              return ListTile(
                contentPadding: const EdgeInsets.only(top: 2, left: 7),
                leading: userImageWidget(
                  imageUrl: friend.image,
                  radius: 30,
                  onTap: () {
                    // navigating to this user's profile with uid as argument
                  },
                ),
                title: Text(friend.name),
                subtitle: Text(
                  friend.aboutMe,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Constants.profileScreen,
                    arguments: friend.uid,
                  );
                },
                trailing: widget.viewType == FRIENDVIEWTYPE.friends
                    ? IconButton(
                        icon: const Icon(
                          Icons.chat_rounded,
                          color: Color.fromARGB(255, 26, 51, 106),
                        ),
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
                              Constants.contactUID: friend.uid,
                              Constants.contactName: friend.name,
                              Constants.contactImage: friend.image,
                              Constants.groupID: '',
                            },
                          );
                        },
                      )
                    : Row(
                        mainAxisSize: MainAxisSize
                            .min, // Ensures the row takes minimum space
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 30,
                            ),
                            onPressed: () async {
                              // Handle accept friend request
                              await context
                                  .read<AuthenticationProvider>()
                                  .acceptFriendRequest(friendID: friend.uid)
                                  .whenComplete(() {
                                showSnackBar(context,
                                    'You are now friends with ${friend.name}');
                                refreshList();
                              });
                            },
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () async {
                                // Handle remove friend request
                                // For example, call a function to decline the friend request
                                await context
                                    .read<AuthenticationProvider>()
                                    .declineFriendRequest(friendID: friend.uid)
                                    .whenComplete(
                                  () {
                                    showSnackBar(
                                        context, 'Friend request declined');
                                    refreshList();
                                  },
                                );
                              }),
                        ],
                      ),
              );
            },
          );
        });
  }

  void refreshList() {
    setState(() {
      final uid = context.read<AuthenticationProvider>().userModel!.uid;
      future = widget.viewType == FRIENDVIEWTYPE.friends
          ? context.read<AuthenticationProvider>().getFriendsList(uid)
          : context.read<AuthenticationProvider>().getFriendRequestsList(uid);
    });
  }
}
