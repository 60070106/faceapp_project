import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/homepage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'display_picture_page.dart';

class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;
  final Map<String, String> data;
  final bool fromRegister;

  TakePicturePage({@required this.fromRegister, this.data, this.camera});

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;

  String percentage = 'not in function';

  Future<void> _sendData(String imgpath) async {
    File file;

    file = File(imgpath);
    String base64Image = base64Encode(file.readAsBytesSync());
    widget.data['image'] = base64Image;
    percentage = 'null';

    var res = await http.post('http://10.50.5.16:8000/api/comparepicture',
        body: jsonEncode(widget.data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }
        );

    var body = json.decode(res.body);

    if (body['success']) {
      percentage = await body['percentage'];
    }
     print(body);


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController =
        CameraController(widget.camera, ResolutionPreset.medium);

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  void _takePicture(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;

      final path =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

      await _cameraController.takePicture(path);
      await _sendData(path);

      widget.fromRegister
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DisplayPicturePage(data: widget.data, imagePath: path)))
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                  HomePage(percentage: percentage, imagePath: path)));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Take a Facial Picture'),
        ),
        body: Stack(children: <Widget>[
          FutureBuilder(
            future: _initializeCameraControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.camera),
                  onPressed: () {
                    _takePicture(context);
                  },
                ),
              ),
            ),
          )
        ]));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cameraController.dispose();
    super.dispose();
  }
}
