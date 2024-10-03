import 'package:stegmessage/constants.dart';

class UserModel {
  String uid;
  String name;
  String phoneNumber;
  String image;
  String token;
  String aboutMe;
  String lastSeen;
  String createdAt;
  String status;
  bool isOnline;
  List<String> friendsUIDs;
  List<String> friendRequestsUIDs;
  List<String> sentFriendRequestsUIDs;

  UserModel({
    required this.uid,
    required this.image,
    required this.name,
    required this.phoneNumber,
    required this.token,
    required this.aboutMe,
    required this.lastSeen,
    required this.status,
    required this.createdAt,
    required this.isOnline,
    required this.friendsUIDs,
    required this.friendRequestsUIDs,
    required this.sentFriendRequestsUIDs,
  });

//from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        status: map[Constants.status] ?? '',
        uid: map[Constants.uid] ?? '',
        image: map[Constants.image] ?? '',
        name: map[Constants.name] ?? '',
        phoneNumber: map[Constants.phoneNumber] ?? '',
        token: map[Constants.token] ?? '',
        aboutMe: map[Constants.aboutMe] ?? '',
        lastSeen: map[Constants.lastSeen] ?? '',
        createdAt: map[Constants.createdAt] ?? '',
        isOnline: map[Constants.isOnline] ?? false,
        friendsUIDs: List<String>.from(map[Constants.friendsUIDs] ?? []),
        friendRequestsUIDs:
            List<String>.from(map[Constants.friendRequestsUIDs] ?? []),
        sentFriendRequestsUIDs:
            List<String>.from(map[Constants.sentFriendRequestsUIDs] ?? []));
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.uid: uid,
      Constants.image: image,
      Constants.name: name,
      Constants.phoneNumber: phoneNumber,
      Constants.token: token,
      Constants.status: status,
      Constants.aboutMe: aboutMe,
      Constants.lastSeen: lastSeen,
      Constants.createdAt: createdAt,
      Constants.isOnline: isOnline,
      Constants.friendsUIDs: friendsUIDs,
      Constants.friendRequestsUIDs: friendRequestsUIDs,
      Constants.sentFriendRequestsUIDs: sentFriendRequestsUIDs,
    };
  }
}
