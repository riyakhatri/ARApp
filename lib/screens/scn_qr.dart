import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({super.key, this.controller});
  final CameraController? controller;
  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  String result = "";
  bool canStoreResult = true;
  String previouslyStoredResult = "";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code!;
      });

      if (canStoreResult &&
          result.isNotEmpty &&
          result != previouslyStoredResult) {
        _storeQRCodeResult(result);
        _startCooldownTimer();
      }
    });
  }

  void _storeQRCodeResult(String result) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot existingResults = await firestore
          .collection('users')
          .doc(uid)
          .collection('scanned_qrcodes')
          .where('result', isEqualTo: result)
          .get();

      if (existingResults.docs.isEmpty) {
        await firestore
            .collection('users')
            .doc(uid)
            .collection('scanned_qrcodes')
            .add({
          'result': result,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Scanned QR code added to Firestore"),
          ),
        );

        setState(() {
          previouslyStoredResult = result;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("QR code already scanned and stored"),
          ),
        );
      }
    } catch (e) {
      print('Error adding scanned QR code: $e');
    }
  }

  void _startCooldownTimer() {
    setState(() {
      canStoreResult = false;
    });

    Timer(const Duration(seconds: 10), () {
      setState(() {
        canStoreResult = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Scanner"),
        backgroundColor: const Color.fromRGBO(102, 153, 153, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
            flex: 0,
            child: Center(
              child: Text(
                "Scan Result: $result",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromRGBO(153, 153, 136, 1),
                        ),
                      ),
                      onPressed: () {
                        if (result.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: result));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Copied to Clipboard")),
                          );
                        }
                      },
                      child: const Text("Copy")),
                  ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromRGBO(153, 153, 136, 1),
                        ),
                      ),
                      onPressed: () async {
                        final Uri _url = Uri.parse(result);
                        if (result.isNotEmpty) {
                          await launchUrl(_url);
                        }
                      },
                      child: const Text("Open")),
                ],
              ))
        ],
      ),
    );
  }
}
