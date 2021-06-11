import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:transcribe/util/loader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transcribe/api/filehandle.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<FILELIST> files = [];
  bool _isLoading = true;
  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermission(Permission.storage);
    getFiles();
  }

  Future<void> getFiles() async {
    files = [];
    String pth =
        await ExtStorage.getExternalStoragePublicDirectory("Transcribe");
    var dir = new Directory(pth);
    List contents = dir.listSync().reversed.toList();
    for (var fileOrDir in contents) {
      if (fileOrDir is File) {
        files.add(FILELIST(
          filename: ((fileOrDir.absolute).toString().split("/").last).substring(
              0, ((fileOrDir.absolute).toString().split("/").last).length - 1),
          filetype: ((fileOrDir.absolute).toString().split(".").last).substring(
              0, ((fileOrDir.absolute).toString().split(".").last).length - 1),
          size: (await (fileOrDir.absolute).length() / 1000).toString(),
        ));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/2.jpg'),
                fit: BoxFit.cover,
              ),
              color: Colors.blue,
            ),
            height: 200,
            child: Center(
              child: Text(
                "TRANSCRIBE",
                style: TextStyle(
                  fontFamily: 'trade',
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          offset: Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        child: Text(
                          "New File",
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, "/STTpage",
                              arguments: {"filename": ""});
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "Recent Documents",
              style: TextStyle(
                fontFamily: 'trade',
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _isLoading
                      ? Center(
                          child: Floader().floder_Wave(),
                        )
                      : Column(
                          children: files.map((e) => documents(e)).toList(),
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget documents(doc) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Text(".${doc.filetype}"),
        ),
        title: Text('${doc.filename}'),
        subtitle: Text('${doc.size}kb'),
        trailing: IconButton(
          icon: Icon(Icons.delete_sharp),
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Deleting File'),
              content: Text('Are You Sure You Want To Delete ${doc.filename}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    CounterStorage().deleteFile("${doc.filename}");
                    setState(() {
                      files = [];
                      getFiles();
                    });
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, "/STTpage",
              arguments: {"filename": "${doc.filename}"});
        },
      ),
    );
  }
}

class FILELIST {
  String filename;
  String size;
  String filetype;
  FILELIST({this.filename, this.size, this.filetype});
}
