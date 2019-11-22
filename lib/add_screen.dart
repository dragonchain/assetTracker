import 'dart:convert';
import 'dart:io';

import 'package:asset_tracker/map_screen_single.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:camera/camera.dart';
import 'package:dragonchain_sdk/dragonchain_sdk.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'actions/get_dragonchain_client.dart';
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
    try {
      String barcode = await BarcodeScanner.scan(); // throws if user exits
      return barcode;
    } catch (e) {
      return '';
    }
  }

  _appendItemHistory() async {
    this.setState(() => _isLoading = true);
    File file = await _getPhotoOfNewItem();
    Position position = await _getCurrentPosition();
    String barcode = await _getBarcode();
    DragonchainClient dragonchainClient = await getDragonchainClient();

    var txn = {
      'method': 'appendItem',
      'params': {
        'barcode': barcode,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'time': new DateTime.now().toUtc().toIso8601String(),
        'image': base64.encode(file.readAsBytesSync())
      }
    };
    logger.d(txn);
    var response = await dragonchainClient.createTransaction('assetTracker', txn);
    logger.d(response);
    this.setState(() => _isLoading = false);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapScreenSingle(barcode: barcode, newPoint: LatLng(position.latitude, position.longitude))));
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: _isLoading
                  ? Center(child: Column(children: <Widget>[CircularProgressIndicator()]))
                  : new RaisedButton(
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
