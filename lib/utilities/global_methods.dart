// show snack bar
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stegmessage/utilities/assets_manager.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

Widget userImageWidget({
  required String imageUrl,
  required double radius,
  required Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        backgroundImage: imageUrl.isNotEmpty
            ? NetworkImage(imageUrl)
            : const AssetImage(AssetsManager.logo) as ImageProvider),
  );
}

// pick image from gallery or take a new photo

Future<File?> pickImage({
  required bool fromCamera,
  required Function(String) onFail,
}) async {
  File? fileImage;
  if (fromCamera) {
    // get picture from camera
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        onFail('No Image was selected');
      } else {
        fileImage = File(pickedFile.path);
      }
    } catch (e) {
      onFail(e.toString());
    }
  } else {
    // get picture from gallery
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        onFail('No image selected');
      } else {
        fileImage = File(pickedFile.path);
      }
    } catch (e) {
      onFail(e.toString());
    }
  }
  return fileImage;
}

String formatTimeOrDate(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (dateToCheck == today) {
    return DateFormat.jm().format(dateTime);
  } else {
    return DateFormat.yMd().format(dateTime);
  }
}

String formatDate(DateTime dateTime) {
  return DateFormat.yMd().format(dateTime);
}

String formatTime(DateTime dateTime) {
  return DateFormat.jm().format(dateTime);
}

Widget seenIndicator({required bool isSeen, String? senderImage}) {
  if (!isSeen || senderImage == null) {
    return const SizedBox.shrink();
  }

  return Padding(
      padding: const EdgeInsets.only(left: 5.0), // Small padding for spacing
      child: userImageWidget(
        imageUrl: senderImage,
        radius: 5,
        onTap: () {},
      ));
}
