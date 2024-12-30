import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/models/last_message_model.dart';
import 'package:stegmessage/models/message_model.dart';
import 'package:stegmessage/models/message_reply_model.dart';
import 'package:stegmessage/models/user_model.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  bool _isLoading = false;
  MessageReplyModel? _messageReplyModel;

  bool get isLoading => _isLoading;
  MessageReplyModel? get messageReplyModel => _messageReplyModel;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setMessageReplyModel(MessageReplyModel? messageReplyModel) {
    _messageReplyModel = messageReplyModel;
    notifyListeners();
  }

  // firebase initialization
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // send text message to firestore
  Future<void> sendTextMessage({
    required UserModel senderUser,
    required String contactUID,
    required String contactName,
    required String contactImage,
    required String message,
    required MESSAGEENUM messageType,
    required String groupUID,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      var messageUID = const Uuid().v4();

      //1. check if it's a message reply and add the reply message to the message
      String repliedString = _messageReplyModel?.message ?? '';
      String repliedTo = _messageReplyModel == null
          ? ''
          : _messageReplyModel!.isMe
              ? 'You'
              : _messageReplyModel!.senderName;
      MESSAGEENUM repliedMessageType =
          _messageReplyModel?.messageType ?? MESSAGEENUM.text;

      //2. update/set the message model class
      final messageModel = MessageModel(
        senderUID: senderUser.uid,
        senderName: senderUser.name,
        senderImage: senderUser.image,
        contactUID: contactUID,
        message: message,
        messageType: messageType,
        timeSent: DateTime.now(),
        messageUID: messageUID,
        isSeen: false,
        repliedMessage: repliedString,
        repliedTo: repliedTo,
        repliedMessageType: repliedMessageType,
      );

      //3. check if it's a group message and send to group else send to contact
      if (groupUID.isNotEmpty) {
        // send to group
      } else {
        // send to contact
        await handleContactMessage(
          messageModel: messageModel,
          contactUID: contactUID,
          contactName: contactName,
          contactImage: contactImage,
          onSuccess: onSuccess,
          onError: onError,
        );

        // set the message reply model to null
        setMessageReplyModel(null);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> handleContactMessage({
    required MessageModel messageModel,
    required String contactUID,
    required String contactName,
    required String contactImage,
    required Function onSuccess,
    required Function(String p1) onError,
  }) async {
    try {
      //0. contact messageModel
      final contactMessageModel = messageModel.copyWith(
        userId: messageModel.senderUID,
        contactImage: contactImage,
      );

      //1. initialize last message for the sender
      final senderLastMessage = LastMessageModel(
        senderUID: messageModel.senderUID,
        contactUID: contactUID,
        contactName: contactName,
        contactImage: contactImage,
        message: messageModel.message,
        messageType: messageModel.messageType,
        isSeen: false,
        timeSent: messageModel.timeSent,
      );

      //2. initialize last message for the contact
      final contactLastMessage = LastMessageModel(
        senderUID: messageModel.senderUID, // your UID (receiver's view)
        contactUID: messageModel.senderUID, // your UID
        contactName: messageModel.senderName,
        contactImage: messageModel.senderImage,
        message: messageModel.message,
        messageType: messageModel.messageType,
        isSeen: false,
        timeSent: messageModel.timeSent,
      );

      await _firestore.runTransaction(
        //3. send message to sender's firestore location
        (transaction) async {
          transaction.set(
            _firestore
                .collection(Constants.users)
                .doc(messageModel.senderUID)
                .collection(Constants.chats)
                .doc(contactUID)
                .collection(Constants.messages)
                .doc(messageModel.messageUID),
            messageModel.toMap(),
          );

          transaction.set(
            //4. send message to contact's firestore location
            _firestore
                .collection(Constants.users)
                .doc(contactUID)
                .collection(Constants.chats)
                .doc(messageModel.senderUID)
                .collection(Constants.messages)
                .doc(messageModel.messageUID),
            contactMessageModel.toMap(),
          );

          transaction.set(
            //5. send last message to sender's firestore location
            _firestore
                .collection(Constants.users)
                .doc(messageModel.senderUID)
                .collection(Constants.chats)
                .doc(contactUID),
            senderLastMessage.toMap(),
          );

          transaction.set(
            //6. send last message to contact's firestore location
            _firestore
                .collection(Constants.users)
                .doc(contactUID)
                .collection(Constants.chats)
                .doc(messageModel.senderUID),
            contactLastMessage.toMap(),
          );
        },
      );
      //7. call onSuccess function
      onSuccess();
    } on FirebaseException catch (e) {
      onError(e.toString());
    }
  }

  // set message as seen
  Future<void> setMessageAsSeen({
    required String contactUID,
    required String userID,
    required String messageUID,
  }) async {
    try {
      await _firestore
          .collection(Constants.users)
          .doc(userID)
          .collection(Constants.chats)
          .doc(contactUID)
          .collection(Constants.messages)
          .doc(messageUID)
          .update({
        Constants.isSeen: true,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // get chatsList stream
  Stream<List<LastMessageModel>> getChatsListStream(String userID) {
    return _firestore
        .collection(Constants.users)
        .doc(userID)
        .collection(Constants.chats)
        .orderBy(Constants.timeSent, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        print('Chat ${data['message']} isSeen: ${data['isSeen']}');
        return LastMessageModel.fromMap(doc.data());
      }).toList();
    });
  }

  // get messages stream
  Stream<List<MessageModel>> getMessagesStream({
    required String contactUID,
    required String userID,
    required String isGroup,
  }) {
    // check if it's a group message
    if (isGroup.isNotEmpty) {
      // hanfle group message
      return _firestore
          .collection(Constants.groups)
          .doc(contactUID)
          .collection(Constants.messages)
          .orderBy(Constants.timeSent, descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return MessageModel.fromMap(doc.data());
        }).toList();
      });
    } else {
      return _firestore
          .collection(Constants.users)
          .doc(userID)
          .collection(Constants.chats)
          .doc(contactUID)
          .collection(Constants.messages)
          .orderBy(Constants.timeSent, descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return MessageModel.fromMap(doc.data());
        }).toList();
      });
    }
  }

  Future<void> markMessageAsSeen({
    required String messageId,
    required String contactUID,
    required String userID,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(contactUID)
          .collection(Constants.chats)
          .doc(userID)
          .collection(Constants.messages)
          .doc(messageId)
          .update({Constants.isSeen: true});

      // Update the isSeen field in the chat list for the user
      await FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(contactUID)
          .collection(Constants.chats)
          .doc(userID)
          .update({Constants.isSeen: true});

      // Update the isSeen field in the chat list for the contact
      await FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(userID)
          .collection(Constants.chats)
          .doc(contactUID)
          .update({Constants.isSeen: true});
    } catch (e) {
      print('Failed to mark message as seen: $e');
    }
  }

  getUserModelByUID(String contactUID) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(contactUID).get();

      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Failed to get user model by UID: $e');
    }
    return null; // Return null if user not found or an error occurs
  }

  Future<List<MessageModel>> getUnseenMessages(
      {required contactUID, required String userID, required isGroup}) async {
    final messagesQuerySnapshot = await FirebaseFirestore.instance
        .collection(Constants.users)
        .doc(contactUID)
        .collection(Constants.chats)
        .doc(userID)
        .collection(Constants.messages)
        .where(Constants.isSeen, isEqualTo: false)
        .get();

    return messagesQuerySnapshot.docs.map((doc) {
      return MessageModel.fromMap(doc.data());
    }).toList();
  }
}
