import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String _recognizedText = '';

  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  Future<void> _pickImage() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _recognizedText = '';
      });
      _detectText(_image!);
    }
  }

  Future<void> _detectText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final RecognizedText recognizedText =
    await _textRecognizer.processImage(inputImage);

    String text = recognizedText.text;

    setState(() {
      _recognizedText = text;
    });
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Detection App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap:()=>_pickImage,
              child: Container(
                width: 200,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child:  Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.image,color: Colors.white,),
                    SizedBox(width: 5,),
                    Text('Pick Image',
                      style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w900),),
                  ],
                )),
              ),
            ),
            const SizedBox(height: 20),
            _image != null
                ? Image.file(
              _image!,
              height: 250,
            )
                : const Text('No image selected'),
            const SizedBox(height: 20),
            const Text(
              'Recognized Text:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_recognizedText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

