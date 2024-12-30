import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/providers/chat_provider.dart';
import 'package:stegmessage/widgets/bottom_chat_field.dart';
import 'package:stegmessage/widgets/chat_app_bar.dart';
import 'package:stegmessage/widgets/chat_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isMarkingSeen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isMarkingSeen) {
      _markMessagesAsSeen();
    }
  }

  Future<void> _markMessagesAsSeen() async {
    _isMarkingSeen = true;
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final contactUID = arguments[Constants.contactUID];
    final groupID = arguments['groupID'];

    final userID = context.read<AuthenticationProvider>().userModel!.uid;

    // Fetch the list of messages that are unseen
    final unseenMessages = await context.read<ChatProvider>().getUnseenMessages(
        contactUID: contactUID, userID: userID, isGroup: groupID);

    for (var message in unseenMessages) {
      if (!mounted) return; // checking if the widget is still mounted
      await context.read<ChatProvider>().markMessageAsSeen(
            messageId: message.messageUID,
            contactUID: contactUID,
            userID: userID,
          );
    }
    _isMarkingSeen = false;
  }

  @override
  Widget build(BuildContext context) {
    // get arguments passed from prevvious screen
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    // contact uid
    final contactUID = arguments[Constants.contactUID];
    // contact name
    final contactName = arguments[Constants.contactName];
    // contact image
    final contactImage = arguments[Constants.contactImage];
    // group id
    final groupID = arguments['groupID'];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: ChatAppBar(
          contactUID: contactUID,
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatList(
            contactUID: contactUID,
            groupID: groupID,
            scrollController: _scrollController,
          )),
          BottomChatField(
            contactUID: contactUID,
            contactName: contactName,
            contactImage: contactImage,
            scrollController: _scrollController,
            groupID: groupID,
          ),
        ],
      ),
    );
  }
}
