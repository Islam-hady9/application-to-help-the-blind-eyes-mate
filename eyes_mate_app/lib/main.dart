import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:eyes_mate_app/scan_page.dart';
import 'face_recognition.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speakHello();
  }

  Future<void> _speakHello() async {
    await flutterTts.speak(
        "Hello... Swipe Up To Open Object Recognition and Distance Measurement, Swipe Down To Open Text Reading, Swipe Left To Open Currency Recognition, Swipe Right To Open Face Recognition");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SwipePage(),
    );
  }
}

class SwipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        // If the user swipes up, navigate to UpPage
        if (details.velocity.pixelsPerSecond.dy < 0) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UpPage(),
            ),
          );
        }
        // If the user swipes down, navigate to DownPage
        else if (details.velocity.pixelsPerSecond.dy > 0) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DownPage(),
            ),
          );
        }
      },
      onHorizontalDragEnd: (details) {
        // If the user swipes to the right, navigate to RightPage
        if (details.velocity.pixelsPerSecond.dx > 0) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FacePage(),
            ),
          );
        }
        // If the user swipes to the left, navigate to LeftPage
        else if (details.velocity.pixelsPerSecond.dx < 0) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CurrencyPage(),
            ),
          );
        }
      },
      child: Container(
        color: Color.fromARGB(255, 182, 54, 67),
        child: Center(
          child: Text(
            'Swipe Up, Down, Left, or Right',
            style:
                TextStyle(color: Color.fromARGB(255, 6, 1, 1), fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}

class DownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Down Page'),
      ),
      body: Center(
        child: Text(
          'Down Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

class UpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Up Page'),
      ),
      body: Center(
        child: Text(
          'Up Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

class LeftPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Left Page'),
      ),
      body: Center(
        child: Text(
          'Left Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

class RightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Right Page'),
      ),
      body: Center(
        child: Text(
          'Right Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
