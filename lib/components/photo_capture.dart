import 'package:flutter/material.dart';

class PhotoCaptureScreen extends StatelessWidget {
  const PhotoCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Meal'),
      ),
      body: Center(
        child: Text('Implement camera functionality here.'),
      ),
    );
  }
}
