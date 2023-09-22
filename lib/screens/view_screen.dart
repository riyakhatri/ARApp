import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key, required this.src});
  final String src;

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final double roomWidth = 500.0;
  final double roomHeight = 300.0;
  final double roomDepth = 800.0;
  double originalModelWidth = 10.0;
  double originalModelHeight = 10.0;
  double originalModelDepth = 10.0;
  @override
  Widget build(BuildContext context) {
    // Calculate the scale factors based on the room size and model size

    return ModelViewer(
      src: widget.src,
      arScale: ArScale.fixed,
      ar: true,
      shadowIntensity: 1,
      cameraControls: true,
      backgroundColor: Colors.white,
    );
  }
}
