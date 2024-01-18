import 'dart:developer';

import 'package:ev_cpms/route/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../main.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  final bool fromSignup;
  final Map<String, dynamic> data;
  const OtpPage(
      {Key? key,
      required this.verificationId,
      required this.fromSignup,
      required this.data})
      : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const SizedBox(
                height: 200,
                width: 200,
                // child: Image.asset('assets/login.jpg'),
                child: Icon(
                  Icons.phone_android,
                  size: 90,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Verification code',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Text(
                  'We have sent the code verification to\nYour Mobile Number',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                child: PinCodeTextField(
                  onChanged: (value) {},
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  autoFocus: true,
                  controller: otp,
                  validator: (v) {
                    if ((v?.length ?? 0) < 6) {
                      return 'Enter six digit OTP';
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    fieldHeight: 40,
                    shape: PinCodeFieldShape.circle,
                    activeFillColor: Colors.white,
                    inactiveColor: Colors.grey,
                    activeColor: Colors.green.shade300,
                    selectedColor: Colors.green.shade300,
                  ),
                  cursorColor: Colors.grey.shade500,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: otp.text);

                  try {
                    final authCredential = await FirebaseAuth.instance
                        .signInWithCredential(phoneAuthCredential);

                    if (authCredential.user != null) {
                      if (widget.fromSignup == false) {
                        if (authCredential.additionalUserInfo?.isNewUser ??
                            true) {
                          appRouter.pushAndPopUntil(
                              SignUpPageRoute(phone: widget.data['phone']),
                              predicate: (_) => false);
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const CupertinoAlertDialog(
                                content: Text(
                                    'You are new user! Please signup first.'),
                              );
                            },
                          );
                        } else {
                          appRouter.pushAndPopUntil(const HomePageRoute(),
                              predicate: (_) => false);
                        }
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    log(e.toString());
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300,
                    elevation: 0,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15)),
                child: const Text(
                  "Verify",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
