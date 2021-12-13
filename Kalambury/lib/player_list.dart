import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kalambury/winner_display.dart';
import 'package:kalambury/word_display.dart';

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

  String word = "Randome me";

  bool ready = false;
  bool firstTime = true;

  String _getWord() {
    String newWord = "TO_DO"; // pozyskanie
    setState(() {
      word = newWord;
    });
    return newWord;
  }

  void _Done() {
    setState(() {
      firstTime = false;
      ready = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WordActivity(haslo: word)),
    );
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

  void _addPhotoToPlayer(Player player)
  {
    //add points to player based on photo
    // for now insta wins the game
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WinnerActivity(imie: player.name)),
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
                                ElevatedButton(
                                  onPressed:(ready && !player.ready) ? (){_addPhotoToPlayer(player);} : (){_removePlayer(player);},
                                  child: (ready && !player.ready) ? Icon(Icons.camera_alt_outlined) : Icon(Icons.exit_to_app ) ,
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
      floatingActionButton:!ready ? FloatingActionButton(
        onPressed: _Done,
        tooltip: 'let\'s go',
        child: const Icon(Icons.thumb_up_alt_outlined),
      ) : null,
    );
  }
}
