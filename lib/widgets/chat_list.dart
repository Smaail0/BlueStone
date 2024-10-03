import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/models/message_model.dart';
import 'package:stegmessage/models/user_model.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/providers/chat_provider.dart';
import 'package:stegmessage/utilities/global_methods.dart';
import 'package:stegmessage/widgets/my_message_widget.dart';

class ChatList extends StatefulWidget {
  const ChatList({
    super.key,
    required this.contactUID,
    required this.groupID,
    required this.scrollController,
  });

  final String contactUID;
  final String groupID;
  final ScrollController scrollController;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  UserModel? contactModel;
  late StreamSubscription<List<MessageModel>>? _messageStreamSubscription;
  List<MessageModel> messagesList = [];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    _fetchContactModel(); // Call the method to fetch the contact's data when the widget is initialized

    _messageStreamSubscription = context
        .read<ChatProvider>()
        .getMessagesStream(
            contactUID: widget.contactUID,
            userID: context.read<AuthenticationProvider>().userModel!.uid,
            isGroup: widget.groupID)
        .listen((messages) {
      setState(() {
        messagesList = messages;
      });
    });
  }

  void _onScroll() {
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    final lastVisibleMessage = _getLastVisibleMessage();
    if (lastVisibleMessage != null && !lastVisibleMessage.isSeen) {
      context.read<ChatProvider>().markMessageAsSeen(
          messageId: lastVisibleMessage.messageUID,
          contactUID: widget.contactUID,
          userID: uid);
    }
  }

  MessageModel? _getLastVisibleMessage() {
    for (var message in messagesList) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final size = box.size;

      if (position.dy + size.height > 0 &&
          position.dy < MediaQuery.of(context).size.height) {
        return message;
      }
    }
    return null; // Replace with actual implementation
  }

  // Method to fetch the contact's user model using their UID
  Future<void> _fetchContactModel() async {
    final fetchedModel =
        await context.read<ChatProvider>().getUserModelByUID(widget.contactUID);
    if (mounted) {
      setState(() {
        contactModel =
            fetchedModel; // Store the fetched user model in the state
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _messageStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationProvider>().userModel!.uid;

    return StreamBuilder<List<MessageModel>>(
      stream: context.read<ChatProvider>().getMessagesStream(
          contactUID: widget.contactUID, userID: uid, isGroup: widget.groupID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Start a conversation',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (snapshot.hasData) {
          messagesList = snapshot.data!;

          final seenMessages = messagesList.where((msg) => msg.isSeen).toList();
          final lastSeenMessage = seenMessages.isNotEmpty
              ? seenMessages.reduce((curr, next) =>
                  curr.timeSent.isAfter(next.timeSent) ? curr : next)
              : null;

          final messagesWithImage = <MessageModel>[];
          String? previousMessageSender;
          for (var i = 0; i < messagesList.length; i++) {
            final message = messagesList[i];
            if (i > 0) {
              final previousMessage = messagesList[i - 1];
              if (previousMessage.senderUID != message.senderUID) {
                messagesWithImage.add(message);
              }
            } else {
              messagesWithImage.add(message);
            }

            previousMessageSender = message.senderUID;
          }

          return GroupedListView<dynamic, DateTime>(
            reverse: false,
            controller: widget.scrollController,
            elements: messagesList,
            groupBy: (element) {
              return DateTime(
                element.timeSent.year,
                element.timeSent.month,
                element.timeSent.day,
              );
            },
            groupHeaderBuilder: (dynamic groupedByValue) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  formatDate(groupedByValue.timeSent),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                )),
            itemBuilder: (context, dynamic element) {
              final isMe = element.senderUID == uid;
              final isFirstMessage = messagesWithImage.contains(element);
              final showImage = !isMe && isFirstMessage;

              final isLastSeenMessage = lastSeenMessage != null &&
                  element.messageUID == lastSeenMessage.messageUID;

              final viewerImageUrl = contactModel?.image ?? '';

              return Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  MyMessageWidget(
                      message: element,
                      isMe: isMe,
                      showImage: showImage,
                      isSeen: element.isSeen,
                      viewerImageUrl: viewerImageUrl,
                      isLastMessage: isLastSeenMessage,
                      isPreviousMessageFromSameSender:
                          previousMessageSender == element.senderUID)
                ],
              );
            },
            useStickyGroupSeparators: false,
            floatingHeader: false,
            order: GroupedListOrder.DESC,
          );
        }
        return const Center(child: Text('No messages yet'));
      },
    );
  }
}
