// import 'dart:io';

// // import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// class ObjectReco extends StatefulWidget {
//   const ObjectReco({super.key});

//   @override
//   State<ObjectReco> createState() => _ObjectRecoState();
// }

// class _ObjectRecoState extends State<ObjectReco> {
//   late InputImage _inputImage;
//   File? _pickedImage;

//   static final ImageLabelerOptions _options =
//       ImageLabelerOptions(confidenceThreshold: 0.86);
//   final imageLabeler = ImageLabeler(options: _options);

//   final ImagePicker _imagePicker = ImagePicker();
//   String text = "";

//   pickedImageFromGallery() async {
//     XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
//     if (image == null) {
//       return;
//     }

//     setState(() {
//       _pickedImage = File(image.path);
//     });
//     _inputImage = InputImage.fromFile(_pickedImage!);
//     identifyImage(_inputImage);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Image Labeling"),
//       ),
//       body: Container(
//         height: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (_pickedImage != null)
//               Image.file(
//                 _pickedImage!,
//                 height: 300,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               )
//             else
//               Container(
//                 height: 300,
//                 color: Colors.black,
//                 width: double.infinity,
//               ),
//             Expanded(child: Container()),
//             Text(
//               text,
//               style: const TextStyle(fontSize: 20),
//             ),
//             Expanded(child: Container()),
//             Container(
//               padding: const EdgeInsets.all(16),
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   pickedImageFromGallery();
//                 },
//                 child: const Text("Pick Image"),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void identifyImage(InputImage inputImage) async {
//     final List<ImageLabel> image = await imageLabeler.processImage(inputImage);
//     if (image.isEmpty) {
//       setState(() {
//         text = 'Cannot identify the image';
//       });
//       return;
//     }
//     for (ImageLabel ing in image) {
//       setState(() {
//         text = "Label:${ing.label}\nConfidence:${ing.confidence} ";
//       });
//     }
//     imageLabeler.close();
//   }
// }
