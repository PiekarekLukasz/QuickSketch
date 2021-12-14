import 'dart:math';

import 'package:flutter/material.dart';


class WordActivity extends StatefulWidget {
  const WordActivity({Key? key, required this.setWord}) : super(key: key);

  final Function(String path) setWord;

  @override
  State<WordActivity> createState() => WordActivityState();
}

class WordActivityState extends State<WordActivity> {


  var possibleObjects = ["table","chair","tshirt","laptop","keyboard","mouse"];

  var title = "";

  void _reroll(){
    print("rolling title");
    setState(() {
      title = possibleObjects[Random().nextInt(6)];
    });
    widget.setWord(title);
  }

  @override
  void initState() {
    title = possibleObjects[Random().nextInt(6)];
    super.initState();
  }
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
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 48,
                  fontFamily: 'Sketchy',
                ),
              ),
              ElevatedButton(
                onPressed: _reroll,
                child: const Icon(Icons.restart_alt),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)
                  ),
                  minimumSize: Size(80, 50),
                ),
              )
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
