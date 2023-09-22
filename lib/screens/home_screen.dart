import 'package:cam/screens/camre_scree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../auth/auth_controller.dart';
import '../auth/user_model.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AuthController auth = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    getTextUser();
    getUser();
  }

  // Future<List<ScannedQrcodes>> getUser() async {
  //   try {
  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     QuerySnapshot existingResults = await firestore
  //         .collection('users')
  //         .doc(uid)
  //         .collection('scanned_qrcodes')
  //         .orderBy('timestamp', descending: true)
  //         .limit(2)
  //         .get();

  //     final List<ScannedQrcodes> results = existingResults.docs.map((e) {
  //       return ScannedQrcodes.fromMap(e.data() as Map<String, dynamic>);
  //     }).toList();

  //     return results;
  //   } catch (e) {
  //     print('Error getting last five results: $e');
  //     return [];
  //   }
  // }

  // Future<List<ScannedText>> getTextUser() async {
  //   try {
  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     QuerySnapshot existingResult = await firestore
  //         .collection('users')
  //         .doc(uid)
  //         .collection('scanned_text')
  //         .orderBy('timestamp', descending: true)
  //         .limit(2)
  //         .get();

  //     final List<ScannedText> result = existingResult.docs.map((e) {
  //       return ScannedText.fromMap(e.data() as Map<String, dynamic>);
  //     }).toList();

  //     return result;
  //   } catch (e) {
  //     print('Error getting last five results: $e');
  //     return [];
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const CircleAvatar(
                  backgroundColor: Colors.black,
                  maxRadius: 70,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await auth.logoutUser();
                },
                icon: const Icon(
                  // <-- Icon
                  Icons.logout_rounded,
                  size: 24.0,
                ),
                label: const Text('Log Out'), // <-- Text
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          // backgroundColor: Color.fromRGBO(153, 102, 102, 1),
          // backgroundColor: Color.fromRGBO(204, 153, 102, 1),
          backgroundColor: const Color.fromRGBO(102, 153, 153, 1),
          // backgroundColor: Color.fromRGBO(204, 187, 153, 1),
          title: const Text(
            "Main Page",
            style: TextStyle(),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                margin: EdgeInsets.only(top: 1.h, bottom: 1.h),
                child: const Text(
                  "QR data",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: AutofillHints.creditCardFamilyName),
                )),
            Flexible(
              flex: 2,
              child: StreamBuilder<QuerySnapshot>(
                  stream: getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Card(
                        child: ListTile(
                          title: Text("No data"),
                        ),
                      );
                    } else {
                      final results = snapshot.data!.docs;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final result = ScannedQrcodes.fromMap(
                                results[index].data() as Map<String, dynamic>);
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(result.result ?? ''),
                                        shape: BeveledRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        actions: [
                                          TextButton.icon(
                                            onPressed: () {
                                              if (result.result!.isNotEmpty) {
                                                Clipboard.setData(ClipboardData(
                                                    text: result.result ?? ''));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          "Copied to Clipboard")),
                                                );
                                                Get.back();
                                              }
                                            },
                                            icon: const Icon(Icons.copy),
                                            label: const Text("Copy"),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    result.result ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  subtitle:
                                      Text(result.timestamp?.toString() ?? ''),
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
            Container(
              margin: EdgeInsets.only(top: 1.h, bottom: 1.h),
              child: const Text(
                "Scan text",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: AutofillHints.creditCardFamilyName),
              ),
            ),
            Flexible(
              flex: 3,
              child: StreamBuilder<QuerySnapshot>(
                  stream: getTextUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Card(
                        child: ListTile(
                          title: Text("No data"),
                        ),
                      );
                    } else {
                      final results = snapshot.data!.docs;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final result = ScannedText.fromMap(
                                results[index].data() as Map<String, dynamic>);
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(result.result ?? ''),
                                        shape: BeveledRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        actions: [
                                          TextButton.icon(
                                            onPressed: () {
                                              if (result.result!.isNotEmpty) {
                                                Clipboard.setData(ClipboardData(
                                                    text: result.result ?? ''));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          "Copied to Clipboard")),
                                                );
                                                Get.back();
                                              }
                                            },
                                            icon: const Icon(Icons.copy),
                                            label: const Text("Copy"),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Card(
                                // color: Colors.amber,
                                child: ListTile(
                                  focusColor: Colors.black,
                                  // title: Text("hello"),
                                  title: Text(
                                    result.result ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  subtitle:
                                      Text(result.timestamp.toString() ?? ''),
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 12.h),
                height: 5.h,
                width: 50.w,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(153, 153, 136, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Set the desired border radius value
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => const CameraScreen());
                    },
                    child: const Text("Start Camera")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getUser() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('scanned_qrcodes')
        .orderBy('timestamp', descending: true)
        .limit(3)
        .snapshots();
  }

  Stream<QuerySnapshot> getTextUser() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('scanned_text')
        .orderBy('timestamp', descending: true)
        .limit(3)
        .snapshots();
  }
}
