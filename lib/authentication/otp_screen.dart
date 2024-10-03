import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/constants.dart';
import 'package:stegmessage/providers/authentication_provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  String? otpCode;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //get the argument
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final phoneNumber = args[Constants.phoneNumber] as String;
    final verificationId = args[Constants.verificationId] as String;

    final authProvider = context.watch<AuthenticationProvider>();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.openSans(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          border: Border.all(
            color: const Color.fromARGB(255, 47, 95, 196),
          )),
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                'Verification',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Text(
                  'Enter the 6-digit code sent to the number',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                phoneNumber,
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 68,
                child: Pinput(
                  length: 6,
                  controller: controller,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: (pin) {
                    setState(() {
                      otpCode = pin;
                    });
                    // verfiy otp code here
                    verifyOtpCode(
                        verificationId: verificationId, otpCode: otpCode!);
                  },
                  focusedPinTheme: defaultPinTheme.copyWith(
                    height: 68,
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color.fromARGB(255, 47, 95, 196),
                      ),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
              authProvider.isSuccessful
                  ? Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  : const SizedBox.shrink(),
              authProvider.isLoading
                  ? const SizedBox.shrink()
                  : Text('didn\'t receive code?',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                      )),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    // resend otp code
                  },
                  child: Text(
                    'Resend Code',
                    style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 47, 95, 196),
                        fontWeight: FontWeight.w600),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void verifyOtpCode({
    required String verificationId,
    required String otpCode,
  }) async {
    final authProvider = context.read<AuthenticationProvider>();
    authProvider.verifyOTPCode(
      verificationId: verificationId,
      otpCode: otpCode,
      context: context,
      onSuccess: () async {
        // 1. check if user exists in firebase
        bool userExists = await authProvider.checkUserExists();

        if (userExists) {
          // 2. if user exists,

          // * get user information from firestore
          await authProvider.getUserDataFromFirestore();
          // * save user information to provider/shared preferences
          await authProvider.saveUserDataToSharedPreferences();
          // * navigate to home scree
          navigate(userExists: true);
        } else {
          // 3. if user doesn't exist, navigate to user information screen
          navigate(userExists: false);
        }
        // 2. if user exists, navigate to home screen

        // * get user information from firestore

        // * save user information to provider/shared preferences

        // 3. if user doesn't exist, navigate to user information screen
      },
    );
  }

  void navigate({required bool userExists}) {
    if (userExists) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Constants.homeScreen,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Constants.userInformationScreen,
        (route) => false,
      );
    }
  }
}
