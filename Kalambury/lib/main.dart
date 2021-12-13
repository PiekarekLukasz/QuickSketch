import 'package:flutter/material.dart';
import 'package:kalambury/player_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Sketch',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Start Quick Sketch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _jumpToWordDisplay() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayerListActivity()),
    );
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
              const Text(
                'QUICK \nSKETCHER',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 48,
                  fontFamily: 'Sketchy',
                ),
              ),
                SizedBox.fromSize(
                  size: const Size(20,400),
                ),
                FloatingActionButton(
                  onPressed: _jumpToWordDisplay,
                  tooltip: 'PLAY',
                  child: const Icon(Icons.play_arrow),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
