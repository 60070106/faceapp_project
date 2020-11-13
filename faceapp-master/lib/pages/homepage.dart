import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/take_picture_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import 'loginpage.dart';

class HomePage extends StatefulWidget {
  final String imagePath;
  final String percentage;
  HomePage({this.percentage, this.imagePath});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userData;
  String imgPath = null;
  bool _isFormRegister = false;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
    });
  }

  Widget checkinCard() {
    File file;
    Uint8List bytes;
    imgPath = widget.imagePath;

    if (imgPath != null) {
      file = File(imgPath);
      String base64Image = base64Encode(file.readAsBytesSync());
      bytes = base64Decode(base64Image);
    }

    var data = {
      'username': '${userData['username']}',
    };

    return (imgPath == null)
        ? Container(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                height: MediaQuery.of(context).size.height * 0.25,
                child: InkWell(
                  onTap: () async {
                    final cameras = await availableCameras();
                    final frontCamera = cameras[1];

                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => TakePicturePage(
                                fromRegister: _isFormRegister,
                                data: data,
                                camera: frontCamera)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      color: Color(0xFFFF835F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 8,
                      child: Container(
                        child: Center(
                          child: Text(
                            'Check In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          )
        : Column(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill, image: MemoryImage(bytes))),
            ),
            Text(
              'Welcome',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xFFFF835F),
                fontSize: 30.0,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
              ),
            ),
            Card(
              elevation: 4.0,
              color: Colors.white,
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.account_circle,
                            color: Color(0xFFFF835F),
                          ),
                        ),
                        Text(
                          'คุณ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 12.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Text(
                            userData != null ? '${userData['realname']}' : '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF9b9b9b),
                              fontSize: 17.0,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            userData != null ? '${userData['surname']}' : '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF9b9b9b),
                              fontSize: 17.0,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4.0,
              color: Colors.white,
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.tag_faces,
                            color: Color(0xFFFF835F),
                          ),
                        ),
                        Text(
                          'percentage of matching',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 12.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Text(
                            widget.percentage.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF9b9b9b),
                              fontSize: 17.0,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face recog'), actions: <Widget>[
        IconButton(icon: const Icon(Icons.dehaze), onPressed: () {})
      ]),
      backgroundColor: Colors.grey[200],
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ////////////// 1st card///////////
                Card(
                  elevation: 4.0,
                  color: Colors.white,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 40, bottom: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        checkinCard()
                        ////////////  first name ////////////
                        // Card(
                        //   elevation: 4.0,
                        //   color: Colors.white,
                        //   margin: EdgeInsets.only(
                        //       left: 10, right: 10, top: 10, bottom: 10),
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10)),
                        //   child: Container(
                        //     padding:
                        //     EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        //     width: MediaQuery.of(context).size.width,
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: <Widget>[
                        //         Row(
                        //           children: <Widget>[
                        //             Padding(
                        //               padding: const EdgeInsets.only(right: 10),
                        //               child: Icon(
                        //                 Icons.account_circle,
                        //                 color: Color(0xFFFF835F),
                        //               ),
                        //             ),
                        //             Text(
                        //               'Firstname',
                        //               textAlign: TextAlign.left,
                        //               style: TextStyle(
                        //                 color: Color(0xFF9b9b9b),
                        //                 fontSize: 17.0,
                        //                 decoration: TextDecoration.none,
                        //                 fontWeight: FontWeight.normal,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.only(left: 35),
                        //           child: Text(
                        //             userData!= null ? '${userData['realname']}' : '',
                        //             textAlign: TextAlign.left,
                        //             style: TextStyle(
                        //               color: Color(0xFF9b9b9b),
                        //               fontSize: 15.0,
                        //               decoration: TextDecoration.none,
                        //               fontWeight: FontWeight.normal,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        ////////////// last name //////////////
                        // Card(
                        //   elevation: 4.0,
                        //   color: Colors.white,
                        //   margin: EdgeInsets.only(
                        //       left: 10, right: 10, top: 10, bottom: 10),
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10)),
                        //   child: Container(
                        //     padding:
                        //     EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        //     width: MediaQuery.of(context).size.width,
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: <Widget>[
                        //         Row(
                        //           children: <Widget>[
                        //             Padding(
                        //               padding: const EdgeInsets.only(right: 10),
                        //               child: Icon(
                        //                 Icons.account_circle,
                        //                 color: Color(0xFFFF835F),
                        //               ),
                        //             ),
                        //             Text(
                        //               'Last Name',
                        //               textAlign: TextAlign.left,
                        //               style: TextStyle(
                        //                 color: Color(0xFF9b9b9b),
                        //                 fontSize: 17.0,
                        //                 decoration: TextDecoration.none,
                        //                 fontWeight: FontWeight.normal,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.only(left: 35),
                        //           child: Text(
                        //             userData!= null ? '${userData['surname']}' : '',
                        //             textAlign: TextAlign.left,
                        //             style: TextStyle(
                        //               color: Color(0xFF9b9b9b),
                        //               fontSize: 15.0,
                        //               decoration: TextDecoration.none,
                        //               fontWeight: FontWeight.normal,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        ////////////////////// phone ///////////
                        //         Card(
                        //           elevation: 4.0,
                        //           color: Colors.white,
                        //           margin: EdgeInsets.only(
                        //               left: 10, right: 10, top: 10, bottom: 10),
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10)),
                        //           child: Container(
                        //             padding:
                        //             EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        //             width: MediaQuery.of(context).size.width,
                        //             child: Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: <Widget>[
                        //                 Row(
                        //                   children: <Widget>[
                        //                     Padding(
                        //                       padding: const EdgeInsets.only(right: 10),
                        //                       child: Icon(
                        //                         Icons.phone,
                        //                         color: Color(0xFFFF835F),
                        //                       ),
                        //                     ),
                        //                     Text(
                        //                       'Phone',
                        //                       textAlign: TextAlign.left,
                        //                       style: TextStyle(
                        //                         color: Color(0xFF9b9b9b),
                        //                         fontSize: 17.0,
                        //                         decoration: TextDecoration.none,
                        //                         fontWeight: FontWeight.normal,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 Padding(
                        //                   padding: const EdgeInsets.only(left: 35),
                        //                   child: Text(
                        //                     userData!= null ? '${userData['phone']}' : '',
                        //                     textAlign: TextAlign.left,
                        //                     style: TextStyle(
                        //                       color: Color(0xFF9b9b9b),
                        //                       fontSize: 15.0,
                        //                       decoration: TextDecoration.none,
                        //                       fontWeight: FontWeight.normal,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //
                        //         ////////////end  part////////////
                      ],
                    ),
                  ),
                ),

                /////////////// Button////////////
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ///////// Edit Button /////////////
                      (imgPath != null)
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlatButton(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  child: Text(
                                    'Check out',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                color: Color(0xFFFF835F),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: () {
                                  imgPath = null;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                },
                              ),
                            )
                          : Container(),

                      ////////////// logout//////////
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FlatButton(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8, left: 10, right: 10),
                              child: Text(
                                'Logout',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            color: Color(0xFFFF835F),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0)),
                            onPressed: logout),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logout() async {
    // logout from the server ...
    var res = await CallApi().getData('logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LogInPage()));
    }
  }
}
