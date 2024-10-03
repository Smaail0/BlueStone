import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/models/last_message_model.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/providers/chat_provider.dart';
import 'package:stegmessage/utilities/global_methods.dart';

class ChatListScreens extends StatefulWidget {
  const ChatListScreens({super.key});

  @override
  State<ChatListScreens> createState() => _ChatListScreensState();
}

class _ChatListScreensState extends State<ChatListScreens> {
  @override
  Widget build(BuildContext context) {
    final userModel = context.read<AuthenticationProvider>().userModel!;
    return Scaffold(
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
          Expanded(
              child: StreamBuilder<List<LastMessageModel>>(
            stream:
                context.read<ChatProvider>().getChatsListStream(userModel.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                final chats = snapshot.data!;
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    // check if the user is the sender or the receiver
                    final isMe = chat.senderUID == userModel.uid;
                    // display the last message correclty
                    final lastMessage =
                        isMe ? 'You: ${chat.message}' : chat.message;

                    return ListTile(
                      leading: userImageWidget(
                          imageUrl: chat.contactImage,
                          radius: 25,
                          onTap: () {}),
                      title: Text(
                        chat.contactName,
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$lastMessage · ${formatTimeOrDate(chat.timeSent)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: !isMe && !chat.isSeen
                                  ? GoogleFonts.openSans(
                                      fontWeight: FontWeight.w700)
                                  : GoogleFonts.openSans(
                                      fontWeight: FontWeight.w400),
                            ),
                          ),
                          if (!chat.isSeen && !isMe)
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.circle,
                                color: Colors.blue,
                                size: 8,
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, Constants.chatScreen,
                            arguments: {
                              Constants.contactUID: chat.contactUID,
                              Constants.contactImage: chat.contactImage,
                              Constants.contactName: chat.contactName,
                              Constants.groupID: '',
                            });
                      },
                    );
                  },
                );
              }

              // Add a return statement for the case when there's no data
              return const Center(
                child: Text('No chats available'),
              );
            },
          ))
        ],
      ),
    );
  }
}
