import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/utilities/assets_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  Country selectedCountry = Country(
    countryCode: 'TN',
    example: 'Tunisia',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Tunisia',
    phoneCode: '+216',
    displayName: 'Tunisia',
    displayNameNoCountryCode: 'TN',
    e164Key: '',
  );

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Lottie.asset(
                  AssetsManager.loginCharacter,
                  // Set any necessary Lottie animation properties here
                ),
              ),
              Text(
                'BlueStone',
                style: GoogleFonts.openSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Add your phone number to get a code to verify',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneNumberController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  setState(() {
                    _phoneNumberController.text = value;
                  });
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Phone Number',
                  hintStyle: GoogleFonts.openSans(
                    fontSize: 16,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          countryListTheme: CountryListThemeData(
                            bottomSheetHeight: 500,
                            textStyle: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            inputDecoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              selectedCountry = country;
                            });
                          },
                        );
                      },
                      child: Text(
                        '${selectedCountry.flagEmoji} ${selectedCountry.phoneCode}',
                        style: GoogleFonts.openSans(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  suffixIcon: _phoneNumberController.text.length == 8
                      ? authProvider.isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(9.0),
                              child: CircularProgressIndicator(),
                            )
                          : InkWell(
                              onTap: () {
                                //Sign in with phone number
                                authProvider.signInWithPhoneNumber(
                                    phoneNumber:
                                        '${selectedCountry.phoneCode} ${_phoneNumberController.text}',
                                    context: context);
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                margin: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.done,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
