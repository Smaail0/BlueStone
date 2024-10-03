import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/providers/chat_provider.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField(
      {super.key,
      required this.scrollController,
      required this.contactUID,
      required this.contactName,
      required this.contactImage,
      required this.groupID});

  final String contactUID;
  final String contactName;
  final String contactImage;
  final String groupID;
  final ScrollController scrollController;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  late TextEditingController _chatController = TextEditingController();
  late FocusNode _chatFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _chatController = TextEditingController();
    _chatFocusNode = FocusNode();
    _chatFocusNode.addListener(
      () {
        if (_chatFocusNode.hasFocus) {
          scrollToBottom();
        }
      },
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    _chatFocusNode.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {}
    });
  }

  // send text message to firestore
  void sendTextMessage() {
    final currenUser = context.read<AuthenticationProvider>().userModel!;
    final chatProvider = context.read<ChatProvider>();

    chatProvider.sendTextMessage(
      senderUser: currenUser,
      contactUID: widget.contactUID,
      contactName: widget.contactName,
      contactImage: widget.contactImage,
      message: _chatController.text,
      messageType: MESSAGEENUM.text,
      groupUID: widget.groupID,
      onSuccess: () {
        _chatController.clear();
        _chatFocusNode.requestFocus();
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      onError: (error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _chatController,
                      focusNode: _chatFocusNode,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.paperclip,
                                    color: Colors.grey[600]),
                                onPressed: () {
                                  // show attachment options
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return const SizedBox(
                                        height: 200,
                                        child: Center(
                                          child: Text('Attachment options'),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.microphone,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.solidPaperPlane,
              color: Colors.blue,
            ),
            onPressed: () {
              // Handle sending message
              sendTextMessage();
            },
          ),
        ),
      ],
    );
  }
}
