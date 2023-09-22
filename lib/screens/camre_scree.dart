import 'package:cam/Text/scan_text.dart';

import 'package:cam/Widget/showbar.dart';
import 'package:cam/objectReco/object_reco.dart';
import 'package:cam/screens/scn_qr.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/cam_controller.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            return Obx(
              () => controller.isCameraInitialized.value
                  ? Stack(children: [
                      SizedBox(
                        height: 100.h,
                        width: 100.w,
                        child: CameraPreview(controller.cameraController),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 2.w, top: 3.h),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            children: [
                              FloatingActionButton(
                                heroTag: "btn1",
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Get.off(() => QRCodeWidget(
                                        controller: controller.cameraController,
                                      ));
                                },
                                child: const Icon(
                                  Icons.search,
                                  color: Color.fromRGBO(153, 153, 136, 1),
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              FloatingActionButton(
                                heroTag: "btn2",
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Get.to(() => const TextReco());
                                },
                                child: const Icon(
                                  Icons.text_fields,
                                  color: Color.fromRGBO(153, 153, 136, 1),
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              FloatingActionButton(
                                heroTag: "btn3",
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  // Get.to(() => const ObjectReco());
                                },
                                child: const Icon(
                                  Icons.data_object,
                                  color: Color.fromRGBO(153, 153, 136, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          height: 7.h,
                          width: 50.w,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(153, 153, 136, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Set the desired border radius value
                              ),
                            ),
                            onPressed: () {
                              _displayBottonSheet(context);
                            },
                            child:
                                Icon(Icons.model_training_outlined, size: 5.h),
                          ),
                        ),
                      ),
                    ])
                  : const Column(
                      children: [
                        Text("Loading Preview...."),
                        // Text(controller.isCameraInitialized.value as String)
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Future _displayBottonSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        enableDrag: true,
        isDismissible: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) {
          return const ShowBar();
        });
  }
}
