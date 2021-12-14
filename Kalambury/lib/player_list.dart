import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis/vision/v1.dart' as gcloud;
import 'package:kalambury/winner_display.dart';
import 'package:kalambury/word_display.dart';

import 'camera_controller.dart';
import 'credential_provider.dart';


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

  Future<void> _countPlayerPoints() async {

    for(Player player in activePlayerList) {

      var path = playersImages[player.name];

      File file = File(path);

      var imageBytes = await file.readAsBytes();

      var _client = CredentialsProvider().client;

      var _vision = VisionApi(await _client);

      var response = await annotateImage(_vision, imageBytes);

      print("Veryfining image for user " + player.name);

      print(response!.webDetection!.webEntities!.map((w) => {w.description.toString() }).toString());

      var entity = response.webDetection!.webEntities!.firstWhereOrNull((w) => w.description.toString().toLowerCase().contains(word));

      var score = (entity!=null)? entity.score : null;
      print("For word: '" + word +"' score is " + (score ?? 0).toString());
      player.points = (score != null)? (100*score).toInt() : 0;
    }

    setState(() {});

  }

  Future<gcloud.AnnotateImageResponse?> invokeAnnotate(gcloud.VisionApi vision,
      {required String $fields,
        required gcloud.BatchAnnotateImagesRequest request}) async {
      gcloud.AnnotateImageResponse response;
    for (int attempt = 1; attempt <= 10; attempt++) {
      final batchResponse =
      await vision.images.annotate(request, $fields: $fields);

      final response = batchResponse.responses!.single;
      if (response.error == null) {
        return response;
      }
    }
  }

  Future<gcloud.AnnotateImageResponse?> annotateImage(
      gcloud.VisionApi vision, Uint8List image) async {
    const $fields = 'responses(error,textAnnotations/'
        'description,webDetection(webEntities(description,score)))';

    final request = gcloud.BatchAnnotateImagesRequest()
      ..requests = [
        gcloud.AnnotateImageRequest()
          ..image = (gcloud.Image()..content = base64Encode(image))
          ..features = [
            gcloud.Feature()
              ..type = 'WEB_DETECTION'
              ..maxResults = 10,
            gcloud.Feature()
              ..type = 'OBJECT_LOCALIZATION'
              ..maxResults = 10,
            gcloud.Feature()
              ..type = 'LABEL_DETECTION'
              ..maxResults = 10,
            gcloud.Feature()
              ..type = 'TEXT_DETECTION'
              ..maxResults = 10
          ]
      ];

    return invokeAnnotate(vision, $fields: $fields, request: request);
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
                                  if(firstTime) {
                                    _removePlayer(player);
                                  }
                                  else {
                                    final cameras = await availableCameras();
                                    final firstCamera = cameras.first;
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TakePictureScreen(
                                                camera: firstCamera,
                                                returnImagePath: (path) {
                                                  setImagePath(
                                                      path, player.name);
                                                }
                                            ),
                                      ),
                                    );

                                    _updatePlayersState();
                                  }
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

