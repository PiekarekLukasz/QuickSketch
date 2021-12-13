import 'package:flutter/material.dart';

class WinnerActivity extends StatelessWidget {
  final String imie;
  const WinnerActivity({Key? key, required this.imie}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.indigo,
                ]
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "The sketchiest one \nof them all:",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontFamily: 'Sketchy',
                ),
              ),
              Text(
                imie,
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 48,
                  fontFamily: 'Sketchy',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){Navigator.pop(context);},
        tooltip: 'let\'s go',
        child: const Icon(Icons.thumb_up_alt_outlined),
      ),
    );
  }
}