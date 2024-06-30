import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:eyes_mate_app/main.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FacePage extends StatefulWidget {
  const FacePage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<FacePage> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';
  FlutterTts flutterTts = FlutterTts();
  Map<String, String> Faces = {
    '0': 'person',
  };

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
    initTts();
    _speakFaces();
  }

  Future<void> _speakFaces() async {
    await flutterTts.speak("Face Recognition is Opened");
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
          String FaceLabel = element['label'].trim();
          String FaceRecognition = Faces[FaceLabel] ?? FaceLabel;

          // Set output to the correct recognition value
          output = FaceRecognition;

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
        model: "assets/faces_detect_model.tflite",
        labels: "assets/faces_detect_labels.txt");
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face Recognition')),
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
