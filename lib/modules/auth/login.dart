import 'package:ev_cpms/route/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phone = TextEditingController();

  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: pressed == true
            ? Center(
                child: Padding(
                padding: const EdgeInsets.all(12),
                child: Lottie.asset("assets/lottie/loading.json",
                    height: 200, width: 200),
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    Text(
                      'EV Station',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.green.shade300,
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: Text(
                        'Enter your phone number to continue, we will send you OTP to verify.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: TextField(
                        controller: phone,
                        autofocus: true,
                        maxLength: 10,
                        style: const TextStyle(),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          counterText: '',
                          labelText: 'Phone Number',
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefix: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              '+91',
                              style: TextStyle(),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (phone.text.trim().length != 10) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Phone number is not valid',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ));
                          return;
                        }

                        setState(() {
                          pressed = true;
                        });

                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: "+91${phone.text}",
                          verificationCompleted: (phoneAuthCredential) async {},
                          verificationFailed: (verificationFailed) async {
                            Navigator.of(context).pop();
                            setState(() {
                              pressed = false;
                            });
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  content: Text(
                                    verificationFailed.message.toString(),
                                  ),
                                );
                              },
                            );
                          },
                          codeSent: (id, token) async {
                            appRouter.push(OtpPageRoute(
                              verificationId: id,
                              fromSignup: false,
                              data: {'phone': phone.text.trim()},
                            ));
                          },
                          codeAutoRetrievalTimeout: (id) async {},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
                          elevation: 10,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 15)),
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
