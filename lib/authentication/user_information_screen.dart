import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/models/user_model.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/utilities/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stegmessage/rounded_loading_button/rounded_loading_button.dart';
import 'package:stegmessage/widgets/app_bar_back_button.dart';
import 'package:stegmessage/widgets/display_user_image.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _nameController = TextEditingController();
  final focusNode = FocusNode();

  String userImage = '';
  File? finalFileImage;

  @override
  void dispose() {
    _btnController.stop();
    _nameController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void selectImage(bool fromCamera) async {
    finalFileImage = await pickImage(
      fromCamera: fromCamera,
      onFail: (String message) {
        showSnackBar(context, message);
      },
    );
    // crop image
    await cropImage(finalFileImage?.path);

    popContext();
  }

  popContext() {
    Navigator.pop(context);
  }

  Future<void> cropImage(filePath) async {
    if (filePath != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 800,
        maxHeight: 800,
        compressQuality: 90,
      );

      //popTheDialogue();

      if (croppedFile != null) {
        setState(() {
          finalFileImage = File(croppedFile.path);
        });
      } else {
        //popTheDialogue();
      }
    }
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 120,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                selectImage(true);
              },
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
            ),
            ListTile(
              onTap: () {
                selectImage(false);
              },
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text('User Information'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              DisplayUserImage(
                finalFileImage: finalFileImage,
                radius: 60,
                onPressed: () {
                  showBottomSheet();
                },
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                focusNode: focusNode,
                decoration: InputDecoration(
                    labelText: 'Enter your name',
                    labelStyle: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 47, 95, 196)),
                      borderRadius: BorderRadius.circular(30),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 150,
                child: RoundedLoadingButton(
                  controller: _btnController,
                  onPressed: () {
                    if (_nameController.text.isEmpty) {
                      showSnackBar(context, 'Please enter your name');
                      _btnController.reset();
                    }
                    // save user data into firestore
                    saveUserDataToFireStore();
                  },
                  color: Theme.of(context).primaryColor,
                  successIcon: Icons.check,
                  successColor: Colors.green,
                  errorColor: Colors.red,
                  child: Text(
                    'Save',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // save user data to firestore
  void saveUserDataToFireStore() async {
    final authProvider = context.read<AuthenticationProvider>();

    UserModel userModel = UserModel(
      uid: authProvider.uid!,
      name: _nameController.text,
      phoneNumber: authProvider.phoneNumber!,
      image: '',
      token: '',
      status: '',
      aboutMe: 'Hey there, I\'m using StegMessage',
      createdAt: '',
      lastSeen: '',
      isOnline: true,
      friendsUIDs: [],
      friendRequestsUIDs: [],
      sentFriendRequestsUIDs: [],
    );

    authProvider.saveUserDataToFireStore(
      userModel: userModel,
      fileImage: finalFileImage,
      onSuccess: () async {
        _btnController.success();
// save user data to shared preferences
        await authProvider.saveUserDataToSharedPreferences();
        navigateToHomeScreen();
      },
      onFail: () async {
        _btnController.error();
        showSnackBar(context, 'Something went wrong');
        await Future.delayed(const Duration(seconds: 1));
        _btnController.reset();
      },
    );
  }

  void navigateToHomeScreen() {
    // navigate to home screen
    Navigator.of(context).pushNamedAndRemoveUntil(
      Constants.homeScreen,
      (route) => false,
    );
  }
}
