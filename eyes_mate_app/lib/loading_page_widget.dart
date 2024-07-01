import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'main.dart'; // Import the main file where MainPage is defined

class LoadingpageWidget extends StatefulWidget {
  @override
  _LoadingpageWidgetState createState() => _LoadingpageWidgetState();
}

class _LoadingpageWidgetState extends State<LoadingpageWidget> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speakAndNavigate();
  }

  Future<void> _speakAndNavigate() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak("Welcome to Your Eyes Mate");
    
    flutterTts.setCompletionHandler(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage()), // Navigate to MainPage
      );
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 360,
        height: 800,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(168, 87, 249, 1),
              Color.fromRGBO(219, 187, 252, 1),
              Color.fromRGBO(63, 9, 116, 1),
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -28,
              left: -50,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 452,
                      height: 282,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/Eye.png'),
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius: BorderRadius.all(Radius.elliptical(452, 282)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 452,
                      height: 282,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(169, 127, 210, 0.5),
                        borderRadius: BorderRadius.all(Radius.elliptical(452, 282)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 141,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 333,
                      height: 399,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/Logo.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 581,
              left: 31,
              child: Text(
                'Eyes Mate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Italianno',
                  fontSize: 64,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
