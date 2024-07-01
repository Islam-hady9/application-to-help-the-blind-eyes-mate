import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:eyes_mate_app/main.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ObjectsPage extends StatefulWidget {
  const ObjectsPage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ObjectsPage> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';
  FlutterTts flutterTts = FlutterTts();

  Map<String, String> objects = {
  "0": "person",
  "1": "bicycle",
  "2": "car",
  "3": "motorcycle",
  "4": "airplane",
  "5": "bus",
  "6": "train",
  "7": "truck",
  "8": "boat",
  "9": "traffic light",
  "10": "fire hydrant",
  "11": "stop sign",
  "12": "parking meter",
  "13": "bench",
  "14": "bird",
  "15": "cat",
  "16": "dog",
  "17": "horse",
  "18": "sheep",
  "19": "cow",
  "20": "elephant",
  "21": "bear",
  "22": "zebra",
  "23": "giraffe",
  "24": "backpack",
  "25": "umbrella",
  "26": "handbag",
  "27": "tie",
  "28": "suitcase",
  "29": "frisbee",
  "30": "skis",
  "31": "snowboard",
  "32": "sports ball",
  "33": "kite",
  "34": "baseball bat",
  "35": "baseball glove",
  "36": "skateboard",
  "37": "surfboard",
  "38": "tennis racket",
  "39": "bottle",
  "40": "wine glass",
  "41": "cup",
  "42": "fork",
  "43": "knife",
  "44": "spoon",
  "45": "bowl",
  "46": "banana",
  "47": "apple",
  "48": "sandwich",
  "49": "orange",
  "50": "broccoli",
  "51": "carrot",
  "52": "hot dog",
  "53": "pizza",
  "54": "donut",
  "55": "cake",
  "56": "chair",
  "57": "couch",
  "58": "potted plant",
  "59": "bed",
  "60": "dining table",
  "61": "toilet",
  "62": "tv",
  "63": "laptop",
  "64": "mouse",
  "65": "remote",
  "66": "keyboard",
  "67": "cell phone",
  "68": "microwave",
  "69": "oven",
  "70": "toaster",
  "71": "sink",
  "72": "refrigerator",
  "73": "book",
  "74": "clock",
  "75": "vase",
  "76": "scissors",
  "77": "teddy bear",
  "78": "hair drier",
  "79": "toothbrush",
};

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
    initTts();
    _speakObject();
  }

  Future<void> _speakObject() async {
    await flutterTts.speak("Object Recognition is Opened");
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
          String ObjectLabel = element['label'].trim();
          String ObjectRecognition = objects[ObjectLabel] ?? ObjectLabel;

          // Set output to the correct recognition value
          output = ObjectRecognition;

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
        model: "assets/object_recognition_model.tflite",
        labels: "assets/objects_labels.txt");
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Object Recognition')),
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
