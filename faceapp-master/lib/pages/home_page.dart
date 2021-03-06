import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/take_picture_page.dart';

class FaceRegis extends StatefulWidget {
  @override
  _FaceRegisState createState() => _FaceRegisState();
}

class _FaceRegisState extends State<FaceRegis> {
  void _showCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras[1];

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: frontCamera)));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First, take a picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('begin'),
              onPressed: () {
                _showCamera();
              },
            )
          ],
        ),
      ),
    );
  }
}
