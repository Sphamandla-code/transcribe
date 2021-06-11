import 'dart:ui';
import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:transcribe/api/speech_api.dart';
import 'package:transcribe/api/filehandle.dart';
import 'package:permission_handler/permission_handler.dart';

class STTPage extends StatefulWidget {
  STTPage({Key key}) : super(key: key);

  @override
  _STTPageState createState() => _STTPageState();
}

class _STTPageState extends State<STTPage> {
  String txt = "listerning";
  String words = "";
  String saveto = "";
  bool isListening = false;
  Map startData = {};

  TextEditingController _controller;
  TextEditingController _controller2;
  @override
  void initState() {
    super.initState();
    requestPermission(Permission.storage);
    _controller = TextEditingController();
    _controller2 = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
    });
    Future.delayed(const Duration(seconds: 1), () {
      getPassedFile(startData);
    });
  }

  Future<void> getPassedFile(file) async {
    String wo = "";
    if (file['filename'] != "") {
      wo = await CounterStorage().readCounter(file['filename']);
      saveto = file['filename'];
    }
    setState(() {
      words = wo;
      saveto = file['filename'];
      _controller2.text = saveto;
    });
  }

  @override
  Widget build(BuildContext context) {
    startData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage('assets/images/2.jpg'),
            fit: BoxFit.cover,
          ),
          actions: [
            TextButton(
                onPressed: () {},
                child: IconButton(
                    icon: Icon(Icons.save),
                    color: Colors.white,
                    onPressed: () {}))
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(isListening ? txt : words),
        )),
        floatingActionButton: AvatarGlow(
            endRadius: 50,
            glowColor: Colors.blue[900],
            animate: isListening,
            child: FloatingActionButton(
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                size: 23,
              ),
              onPressed: () {
                toggleRecording();
              },
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.blue,
          child: Container(
            child: Row(
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width * 30) / 100,
                  child: TextButton(
                    onPressed: () {
                      CounterStorage().writeCounter(words, "");
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        Text(
                          "Edit",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width * 30) / 100,
                  child: TextButton(
                    onPressed: () {
                      savedailog();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  String dropdownValue = 'docx';
  var dataTypes = ['txt', 'docx'];
  savedailog() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Save'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                  filled: true, hintText: 'filename', labelText: 'file'),
              controller: _controller2,
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  print(dropdownValue);
                });
              },
              items: <String>['docx', 'txt', 'doc']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              CounterStorage()
                  .writeCounter(words, "${_controller2.text}.$dropdownValue");
              Navigator.pop(context, 'OK');
            },
            child: const Text('save'),
          ),
        ],
      ),
    );
  }

  Future toggleRecording() => SpeechApi.toogleRecording(
      onResult: (text) => setState(() => this.txt = text),
      onListening: (isListening) {
        setState(() {
          this.isListening = isListening;
          if (!isListening) {
            Future.delayed(Duration(seconds: 1), () {
              setState(() {
                this.words += " ${this.txt}";
              });
            });
          }
        });
      });
}
