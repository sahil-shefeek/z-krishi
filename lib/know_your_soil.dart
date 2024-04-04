import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SoilAnalysisPage extends StatefulWidget {
  @override
  _SoilAnalysisPageState createState() => _SoilAnalysisPageState();
}

class _SoilAnalysisPageState extends State<SoilAnalysisPage> {
  File? _image;
  bool _isLoading = false;
  String? _result;

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> analyzeSoil() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:8000/api/classify/'),
    );

    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    setState(() {
      _result = responseData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Know Your Soil'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image != null
                      ? Image.file(
                          _image!,
                          height: 150,
                        )
                      : Text('No image selected.'),
                  ElevatedButton(
                    onPressed: () => getImage(ImageSource.gallery),
                    child: Text('Choose Image from Gallery'),
                  ),
                  ElevatedButton(
                    onPressed: () => getImage(ImageSource.camera),
                    child: Text('Take Picture'),
                  ),
                  ElevatedButton(
                    onPressed: _image != null ? analyzeSoil : null,
                    child: Text('Check'),
                  ),
                  _result != null ? Text('Result: $_result') : Container(),
                ],
              ),
      ),
    );
  }
}
