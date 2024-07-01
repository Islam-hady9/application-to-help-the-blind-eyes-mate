import 'package:flutter/material.dart';
import 'package:google_ml_kit_text_recognition/google_ml_kit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class TextRead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Arabic Text Recognition')),
        body: TextRecognitionWidget(),
      ),
    );
  }
}

class TextRecognitionWidget extends StatefulWidget {
  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
  final ImagePicker _picker = ImagePicker();
  String _recognizedText = '';

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> recognizeText(String imagePath) async {
    final XFile? image = XFile(imagePath);
    if (image == null) return;

    final inputImage = InputImage.fromFilePath(image.path);
    final RecognisedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    setState(() {
      _recognizedText = recognizedText.text;
    });
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await recognizeText(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: pickImage,
            child: Text('Take Photo'),
          ),
          SizedBox(height: 20),
          Text(
            _recognizedText.isNotEmpty ? _recognizedText : 'No text recognized',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
