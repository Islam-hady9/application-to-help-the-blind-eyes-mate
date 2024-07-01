import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;
import 'user_register_page.dart'; // Import your newly created file
import 'loading_page_widget.dart'; // Import the loading page widget
import 'package:eyes_mate_app/object_recognition.dart';
import 'package:eyes_mate_app/scan_page.dart';
import 'package:eyes_mate_app/face_recognition.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;
void main() {
  runApp(MaterialApp(
    home: LoadingpageWidget(), // Use the LoadingpageWidget here
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FlutterTts flutterTts = FlutterTts();
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _speakInstructions();
  }

  Future<void> _speakInstructions() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(
        "If you want object detection swipe up, face recognition swipe right, currency detection swipe left, text recognition swipe down.");
  }

  void _onVerticalSwipe(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      // Swiped up
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ObjectDetectionPage()));
    } else if (details.primaryVelocity! > 0) {
      // Swiped down
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TextRecognitionPage(onReturn: _speakInstructions)));
    }
  }

  void _onHorizontalSwipe(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      // Swiped left
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CurrencyPage()));
    } else if (details.primaryVelocity! > 0) {
      // Swiped right
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FacePage()));
    }
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserRegisterPage(onReturn: _speakInstructions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: _onVerticalSwipe,
        onHorizontalDragEnd: _onHorizontalSwipe,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(226, 207, 245, 1),
                    Color.fromRGBO(197, 147, 247, 1),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/up_arrow.png',
                      width: 96.97, height: 87.45),
                  SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/left_arrow.png',
                          width: 96.97, height: 87.45),
                      SizedBox(width: 25),
                      Image.asset('assets/right_arrow.png',
                          width: 96.97, height: 87.45),
                    ],
                  ),
                  SizedBox(height: 70),
                  Image.asset('assets/down_arrow.png',
                      width: 96.97, height: 87.45),
                ],
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  _toggleDropdown();
                },
                child: _isDropdownOpen
                    ? Container() // Hide Ellipse8.png when dropdown is open
                    : Image.asset('assets/Ellipse8.png', width: 60, height: 60),
              ),
            ),
            if (_isDropdownOpen)
              Positioned(
                top: 40, // Adjust position based on your design
                left: 20, // Adjust position based on your design
                child: GestureDetector(
                  onTap: () {
                    _toggleDropdown();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/Ellipse.png',
                                width: 48, height: 47),
                            SizedBox(width: 2),
                            Image.asset('assets/Arrow2.png',
                                width: 19, height: 47),
                            SizedBox(width: 2),
                            Transform.rotate(
                              angle: -90.96024563751448 * (math.pi / 180),
                              child: Container(
                                width: 5,
                                height: 15,
                                decoration: BoxDecoration(
                                    // Add your decoration as needed
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            _navigateToLogin();
                            _toggleDropdown();
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Italianno',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 40,
              right: 20,
              child: Row(
                children: [
                  Text(
                    'Eyes Mate',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Italianno',
                    ),
                  ),
                  SizedBox(width: 8),
                  Image.asset('assets/Logo.png', width: 50, height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class ObjectDetectionPage extends StatelessWidget {
  final Function onReturn;
  final FlutterTts flutterTts = FlutterTts();

  ObjectDetectionPage({required this.onReturn}) {
    _speakInstructions();
  }

  k

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Object Detection")),
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.pop(context);
          onReturn();
        },
        child: Center(child: Text("Object Detection Page")),
      ),
    );
  }
}*/

class FaceRecognitionPage extends StatelessWidget {
  final Function onReturn;
  final FlutterTts flutterTts = FlutterTts();

  FaceRecognitionPage({required this.onReturn}) {
    _speakInstructions();
  }

  Future<void> _speakInstructions() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak("If you need to exit from this page double click.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Recognition")),
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.pop(context);
          onReturn();
        },
        child: Center(child: Text("Face Recognition Page")),
      ),
    );
  }
}

class CurrencyDetectionPage extends StatelessWidget {
  final Function onReturn;
  final FlutterTts flutterTts = FlutterTts();

  CurrencyDetectionPage({required this.onReturn}) {
    _speakInstructions();
  }

  Future<void> _speakInstructions() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak("If you need to exit from this page double click.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Currency Detection")),
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.pop(context);
          onReturn();
        },
        child: Center(child: Text("Currency Detection Page")),
      ),
    );
  }
}

class TextRecognitionPage extends StatelessWidget {
  final Function onReturn;
  final FlutterTts flutterTts = FlutterTts();

  TextRecognitionPage({required this.onReturn}) {
    _speakInstructions();
  }

  Future<void> _speakInstructions() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak("If you need to exit from this page double click.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Registration")),
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.pop(context);
          onReturn();
        },
        child: Center(child: Text("User Registration Page")),
      ),
    );
  }
}
