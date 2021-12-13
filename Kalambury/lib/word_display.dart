import 'package:flutter/material.dart';

class WordActivity extends StatelessWidget {
  final String haslo;
  const WordActivity({Key? key, required this.haslo}) : super(key: key);
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
              Text(
                haslo,
                style: const TextStyle(
                  color: Colors.black,
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
