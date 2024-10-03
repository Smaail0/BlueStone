import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stegmessage/utilities/assets_manager.dart';

class DisplayUserImage extends StatelessWidget {
  const DisplayUserImage({
    super.key,
    required this.finalFileImage,
    required this.radius,
    required this.onPressed,
  });

  final File? finalFileImage;
  final double radius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return finalFileImage == null
        ? Stack(
            children: [
              CircleAvatar(
                radius: radius,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage(AssetsManager.logo),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onPressed,
                  child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      )),
                ),
              )
            ],
          )
        : Stack(
            children: [
              InkWell(
                child: CircleAvatar(
                  radius: radius,
                  backgroundColor: Colors.white,
                  backgroundImage: FileImage(File(finalFileImage!.path)),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onPressed,
                  child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 25,
                      )),
                ),
              )
            ],
          );
  }
}
