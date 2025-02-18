import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:eyes_mate_app/main.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<CurrencyPage> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';
  FlutterTts flutterTts = FlutterTts();
  Map<String, String> Currency = {
    '0': '1',
    '1': '5',
    '2': '10',
    '3': '10 (new)',
    '4': '20',
    '5': '20 (new)',
    '6': '50',
    '7': '100',
    '8': '200',
  };

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
    initTts();
    _speakCurrency();
  }

  Future<void> _speakCurrency() async {
    await flutterTts.speak("Currency Recognition is Opened");
  }

  void initTts() {
    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);
    flutterTts.awaitSpeakCompletion(true);

    // Add a listener for TTS status
    flutterTts.setStartHandler(() {
      print("TTS started");
    });

    flutterTts.setCompletionHandler(() {
      print("TTS completed");
    });

    flutterTts.setErrorHandler((msg) {
      print("TTS error: $msg");
    });
  }

  loadCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true);
      predictions!.forEach((element) {
        setState(() {
          // Trim and ensure the label is correctly formatted
          String CurrencyLabel = element['label'].trim();
          String CurrencyRecognition = Currency[CurrencyLabel] ?? CurrencyLabel;

          // Set output to the correct recognition value
          output = CurrencyRecognition;

          print(output);
          speak(output);
        });
      });
    }
  }

  Future<void> speak(String text) async {
    var result = await flutterTts.speak(text);
    if (result == 1) {
      print("Speaking: $text");
    } else {
      print("Failed to speak: $text");
    }
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/currency_model.tflite",
        labels: "assets/currency_labels.txt");
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency Detection')),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: !cameraController!.value.isInitialized
                ? Container()
                : AspectRatio(
                    aspectRatio: cameraController!.value.aspectRatio,
                    child: CameraPreview(cameraController!),
                  ),
          ),
        ),
        Text(
          output,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ]),
    );
  }
}
