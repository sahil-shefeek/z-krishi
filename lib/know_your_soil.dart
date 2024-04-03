import 'package:flutter/material.dart';

class SoilAnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Know Your Soil'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add logic to choose image from camera or gallery
          },
          child: Text('Choose Image'),
        ),
      ),
    );
  }
}
