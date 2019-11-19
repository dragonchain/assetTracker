// import 'dart:io';

// import 'package:asset_tracker/actions/take_photo.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:dragonchain_sdk/dragonchain_sdk.dart';
// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:convert';

// class ScanBarcodeScreen extends StatefulWidget {
//   @override
//   ScanBarcodeScreenState createState() => ScanBarcodeScreenState();
//   final String picturePath;

//   const ScanBarcodeScreen({
//     Key key,
//     this.picturePath,
//   }) : super(key: key);
// }

// class ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
//   String barcode = "";
//   String latitude = "";
//   String longitude = "";
//   DragonchainClient dragonchainClient;
//   CameraDescription camera;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future appendItemHistory() async {
//     final camera = (await availableCameras()).first;
//     var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TakePhotoScreen(camera: camera)));
//     logger.d(result);
//     var file = File(widget.picturePath).readAsBytesSync();
//     this.dragonchainClient = await DragonchainClient.createClient(
//         dragonchainId: '29xBXnCxpMQso9zhCNsegA13WYtTH24JDedszndt5XTd8',
//         authKey: 'SuzacGlkY9T01PJ89Ha7SjEGoubwoc4Ue29p8SI8jp4',
//         authKeyId: 'HJXOAMYAVUJG');
//     try {
//       String barcode = await BarcodeScanner.scan();
//       Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       var txn = {
//         'method': 'append_history',
//         'params': {
//           'barcode': barcode,
//           'latitude': position.latitude,
//           'longitude': position.longitude,
//           'time': new DateTime.now().toUtc().toIso8601String(),
//           'image': base64.encode(file)
//         }
//       };
//       var result = await this.dragonchainClient.createTransaction('banana', txn);
//       logger.d(result);
//       setState(() {
//         this.barcode = barcode;
//         this.latitude = latitude;
//         this.longitude = longitude;
//         this.camera = camera;
//       });
//     } on PlatformException catch (e) {
//       if (e.code == BarcodeScanner.CameraAccessDenied) {
//         setState(() {
//           this.barcode = 'The user did not grant the camera permission!';
//         });
//       } else {
//         setState(() => this.barcode = 'Unknown error: $e');
//       }
//     } on FormatException {
//       setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
//     } catch (e) {
//       setState(() => this.barcode = 'Unknown error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//           appBar: new AppBar(
//             title: new Text('Barcode Scanner Example'),
//           ),
//           body: new Center(
//             child: new Column(
//               children: <Widget>[
//                 new Container(
//                   child: new MaterialButton(onPressed: appendItemHistory, child: new Text("Scan")),
//                   padding: const EdgeInsets.all(8.0),
//                 ),
//                 new Text(barcode),
//               ],
//             ),
//           )),
//     );
//   }
// }
