// ignore_for_file: library_private_types_in_public_api

import 'package:cam/Widget/process_indicationg_button.dart';
import 'package:cam/auth/user_model.dart';
import 'package:cam/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhoneNumberVerification extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const PhoneNumberVerification(
      {Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);

  @override
  _PhoneNumberVerificationState createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  final _focusNode = FocusNode();
  var _strokeColor = Colors.black;
  var _smsCode = '';
  var responsiveButtonState = GlobalKey<ProgressIndicatingButtonState>();
  final UserModel userModel = UserModel();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? userId;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(
          () {
            _strokeColor = Colors.blue;
          },
        );
      } else {
        setState(() {
          _strokeColor = Colors.black;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (kDebugMode) {
            print('Somewhere else clicked');
          }
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                }, // Handle your callback
                child: Ink(
                  height: 50,
                  width: 70,
                  child: const Center(child: Text('< Back')),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome',
                    ),
                    Text(
                        'We have sent a 6-digit code at ${widget.phoneNumber}'),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.all(color: _strokeColor),
                      ),
                      child: TextField(
                        style: const TextStyle(letterSpacing: 30),
                        maxLength: 6,
                        onChanged: (value) {
                          _smsCode = value;
                        },
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: ProgressIndicatingButton(
                  key: responsiveButtonState,
                  onTap: () {
                    try {
                      _verifyCode();
                      // ignore: unused_catch_clause
                    } on FirebaseAuthException catch (e) {
                      responsiveButtonState.currentState!.setErrorState();
                    }
                  },
                  title: 'Next',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Check If Document Exists
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  void _verifyCode() async {
    setState(() {});
    responsiveButtonState.currentState!.setProgressState();

    await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: widget.verificationId, smsCode: _smsCode));
    responsiveButtonState.currentState!.setNormalState();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
    if (FirebaseAuth.instance.currentUser != null) {
      userId = _firebaseAuth.currentUser!.uid;
      userModel.userId = userId;
      userModel.userPhone = widget.phoneNumber;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(userModel.asMap());
    }
  }
}
