import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:camera/camera.dart';
import 'package:dragonchain_sdk/dragonchain_sdk.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'actions/take_photo.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({
    Key key,
  }) : super(key: key);

  @override
  AddScreenState createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  _getPhotoOfNewItem() async {
    final camera = (await availableCameras()).first;
    final result = Navigator.push(context, MaterialPageRoute(builder: (context) => TakePhotoScreen(camera: camera)));
    return result;
  }

  _getCurrentPosition() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  _getBarcode() async {
    String barcode = await BarcodeScanner.scan();
    return barcode;
  }

  _getDragonchainClient() async {
    return DragonchainClient.createClient(
        dragonchainId: '29xBXnCxpMQso9zhCNsegA13WYtTH24JDedszndt5XTd8',
        authKey: 'SuzacGlkY9T01PJ89Ha7SjEGoubwoc4Ue29p8SI8jp4',
        authKeyId: 'HJXOAMYAVUJG');
  }

  _appendItemHistory() async {
    this.setState(() => _isLoading = true);
    File file = await _getPhotoOfNewItem();
    Position position = await _getCurrentPosition();
    String barcode = await _getBarcode();
    DragonchainClient dragonchainClient = await _getDragonchainClient();
    this.setState(() => _isLoading = false);

    var response = await dragonchainClient.createTransaction('banana', {
      'method': 'append_history',
      'params': {
        'barcode': barcode,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'time': new DateTime.now().toUtc().toIso8601String(),
        'image': base64.encode(file.readAsBytesSync())
      }
    });
    logger.d(response);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          body: new Center(
        child: new Column(
          children: <Widget>[
            _isLoading
                ? CircularProgressIndicator()
                : new Container(
                    child: new MaterialButton(
                      color: Color.fromRGBO(0, 1, 1, 0),
                      onPressed: _appendItemHistory,
                      child: new Text("Scan a new Item!"),
                      autofocus: true,
                    ),
                    padding: const EdgeInsets.all(8.0),
                  ),
          ],
        ),
      )),
    );
  }
}
