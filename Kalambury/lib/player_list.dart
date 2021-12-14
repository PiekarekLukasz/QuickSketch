import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kalambury/winner_display.dart';
import 'package:kalambury/word_display.dart';
import 'package:collection/collection.dart';
import 'camera_controller.dart';

class PlayerListActivity extends StatelessWidget {
  const PlayerListActivity({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlayerList(title: 'Quick Sketch - Word Display'),
    );
  }
}

class PlayerList extends StatefulWidget {
  const PlayerList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class Player{
  String name;
  int points = 0;
  bool ready = false;

  Player(this.name);
}

class _PlayerListState extends State<PlayerList> {

  var activePlayerList = List<Player>.empty(growable: true);

  var playersImages = new Map();

  String word = "Randome me";

  void setWord(s){
    setState(() {
      word = s;
    });
  }

  void setImagePath(dynamic childValue, playerName) {

    print("Updating player images map");

    setState(() {
      playersImages[playerName] = childValue;
    });

    print(playersImages.entries);
  }

  bool ready = false;
  bool firstTime = true;

  void _Done() {
    print("Finishing game");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WordActivity(setWord: (word)=> {setWord(word)})),
    );
    setState(() {
      for(Player player in activePlayerList) player.ready = false;
      firstTime = false;
      ready = false;
    });

  }

  void _askForName(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final  controll = TextEditingController();
          return SimpleDialog(
            contentPadding: EdgeInsets.all(20.0),
            title: const Text("Pick your name"),
            children: [
              TextField(
                autofocus: true,
                controller: controll,
                onEditingComplete: (){
                  _addPlayer(controll.text);
                  Navigator.pop(context);
                  },
              )
            ],
          );
        }
        );
  }

  void _addPlayer(String name)
  {
    setState(() {
      activePlayerList.add(Player(name));
    });
  }

  void _removePlayer(Player player)
  {
    setState(() {
      activePlayerList.remove(player);
    });
  }

  void _countPlayerPoints(){
    setState(() {
      for(Player player in activePlayerList) {
        if (playersImages.containsKey(player.name)) {
          player.points = 2;
        }
      }
    });
    //Tutaj wysyłamy requesty do API, na podstawie wyników updatujemy
  }

  void _updatePlayersState() {

    for(Player player in activePlayerList) {
      if (playersImages.containsKey(player.name)) {
        player.ready = true;
      }
    }

    setState(() {

      //activePlayerList.map((player) => player.ready = playersImages.containsKey(player.name));

      var notReadyPlayer = activePlayerList.firstWhereOrNull((element) => !element.ready);
      print("NOT readty");
      print(notReadyPlayer?.name);
      ready = notReadyPlayer == null ||activePlayerList.isEmpty ;
    });
  }

    void _finishTheGame() {

    var winner = activePlayerList.reduce((current, next) =>
    (next.points > current.points) ? next : current);

    {
      Timer(
          Duration(seconds: 1),
      () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => WinnerActivity(imie: winner.name)),
              (Route<dynamic> route) => false
      ));
    }
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
        child:
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                       const Text("Featuring:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 48,
                            fontFamily: 'Sketchy',
                          ),
                        ),
                  if(activePlayerList.isEmpty)
                    const Text("No one?",
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontFamily: 'Sketchy',
                    ),
                  ),

                  for (Player player in activePlayerList)
                    Container(
                      height: 100,
                      width: 450,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.purpleAccent,
                            Colors.redAccent,
                          ]
                        ),
                        border: Border.all(
                          color: Colors.purple,
                          width: 7,
                         ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(player.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontFamily: 'Sketchy',
                                  ),
                                ),
                              Text(player.points.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                  fontFamily: 'Sketchy',
                                ),
                              ),
                              Text("Ready",
                                style: TextStyle(
                                  color: player.ready? Colors.green: Colors.black,
                                  fontSize: 28,
                                  fontFamily: 'Sketchy',
                                ),
                              ),
                                if(!player.ready)
                                ElevatedButton(onPressed: () async {
                                  final cameras = await availableCameras();
                                  final firstCamera = cameras.first;
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>  TakePictureScreen(
                                          camera: firstCamera,
                                          returnImagePath: (path){setImagePath(path, player.name);}
                                      ),
                                    ),
                                  );

                                  _updatePlayersState();
                                },
                                  child: (!firstTime) ? Icon(Icons.camera_alt_outlined) : Icon(Icons.exit_to_app ) ,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0)
                                    ),
                                    minimumSize: Size(80, 50),
                                  ),
                                ),
                            ],

                        ),

                    ) ,
                  SizedBox.fromSize(
                    size: const Size(20,10),
                  ),
                  if(!firstTime)
                  ElevatedButton(
                    onPressed: ready? _countPlayerPoints: null,
                    child: const Text("Calculate results"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)
                      ),
                      minimumSize: Size(80, 50),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: const Size(100,100),
                  ),
                  if(firstTime)
                    ElevatedButton(
                      onPressed: _askForName,
                      child: const Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)
                        ),
                                minimumSize: Size(80, 50),
                      ),
                    ),
                ],
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ready? _finishTheGame: _Done,
        tooltip: 'let\'s go',
        backgroundColor: ready? Colors.green: Colors.grey,
        child: const Icon(Icons.thumb_up_alt_outlined),
      ),
    );
  }
}
