import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> createPicture(String imagePath) async {
  File file;
  String fileName = '';

  file = File(imagePath);
  fileName = file.path.split('/').last;
  fileName = fileName.split(" ").join("_");

  String base64Image = base64Encode(file.readAsBytesSync());

  http.post("http://10.0.2.2:8000/api/postpicture",
  body: {
    "name": fileName,
    "img": base64Image,
  }).then((res) {
    print (res.statusCode);
  }).catchError((err) {
    print (err);
  });

  // img.Image imageTemp = img.decodeImage(file.readAsBytesSync());
  // img.Image resizedImg = img.copyResize(imageTemp, width: 800);

  // var request = http.MultipartRequest('POST', Uri.parse("http://10.0.2.2:8000/api/postpicture"));
  // request.fields['name'] = fileName;

  // request.files.add( http.MultipartFile.fromBytes(
  //   'img',
  //   img.encodeJpg(resizedImg),
  //   filename: fileName,
  //   contentType: MediaType.parse('image/jpeg')
  // ));

  // var res = await request.send();
  // var resData = await res.stream.toBytes();
  // var resString = String.fromCharCodes(resData);
  //
  // return resString + " " + file.toString();
}

String state = "";

class DisplayPicturePage extends StatefulWidget {
  final String imagePath;
  DisplayPicturePage({this.imagePath});

  final String title = "Upload Image Demo";



  @override
  _DisplayPicturePageState createState() => _DisplayPicturePageState();
}

class _DisplayPicturePageState extends State<DisplayPicturePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('uploading face')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Image.file(File(widget.imagePath)),

            RaisedButton(
              child: Text('upload'),
              onPressed: () async {
                var res = await createPicture(widget.imagePath);
                setState(() {
                  state = res;
                  print(res);
                });
                },
            ),
          ],
        )
      )
    );
  }
}
