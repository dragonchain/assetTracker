import 'dart:async';
import 'dart:convert';

import 'package:dragonchain_sdk/dragonchain_sdk.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'actions/get_dragonchain_client.dart';
import 'item_details_screen.dart';

class MapScreen extends StatefulWidget {
  final String barcode;
  @override
  MapScreen({@required this.barcode});

  State<MapScreen> createState() => MapSampleState();
}

class MapSampleState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  Future<dynamic> _getItems() async {
    DragonchainClient dragonchainClient = await getDragonchainClient();
    var response = await dragonchainClient.getSmartContractObject(this.widget.barcode, smartContractId);
    logger.d(response);
    var avgLat = _getAverageFromArrayOfObjects(response, 'latitude');
    var avgLon = _getAverageFromArrayOfObjects(response, 'longitude');
    var bounds = _getBoundsFromArrayOfObjects(response);
    return {
      'polylines': _getPolylinesFromResponse(response),
      'markers': _getMarkersFromResponse(response),
      'target': LatLng(avgLat, avgLon),
      'bounds': CameraTargetBounds(bounds)
    };
  }

  _padded(double number) {
    return number + 0;
  }

  LatLngBounds _getBoundsFromArrayOfObjects(dynamic response) {
    double maxLat = response[0]['latitude'];
    double minLat = response[0]['latitude'];
    double maxLon = response[0]['longitude'];
    double minLon = response[0]['longitude'];

    for (var x = 0; x < response.length; x++) {
      if (response[x]['latitude'] > maxLat) maxLat = response[x]['latitude'];
      if (response[x]['latitude'] < minLat) minLat = response[x]['latitude'];
      if (response[x]['longitude'] > maxLon) maxLon = response[x]['longitude'];
      if (response[x]['longitude'] < minLon) minLon = response[x]['longitude'];
    }
    return LatLngBounds(northeast: LatLng(_padded(maxLat), _padded(maxLon)), southwest: LatLng(_padded(minLat), _padded(minLon)));
  }

  Set<Polyline> _getPolylinesFromResponse(dynamic response) {
    Color red = Color.fromRGBO(221, 80, 76, 1);
    List<LatLng> polylinePoints = new List();
    for (var x = 0; x < response.length; x++) {
      polylinePoints.add(LatLng(response[x]['latitude'], response[x]['longitude']));
    }
    Polyline polyline = new Polyline(
        startCap: Cap.roundCap, endCap: Cap.roundCap, polylineId: PolylineId(response[0]['barcode']), points: polylinePoints, color: red);
    return [polyline].toSet();
  }

  Set<Marker> _getMarkersFromResponse(dynamic response) {
    Set<Marker> markers = new Set();
    for (var x = 0; x < response.length; x++) {
      markers.add(Marker(
          onTap: () => _goToDetails(response[x]['barcode'], Image.memory(base64Decode(response[x]['image'])), response[x]['transactionId']),
          markerId: MarkerId(response[x]['transactionId']),
          position: LatLng(response[x]['latitude'], response[x]['longitude'])));
    }
    return markers;
  }

  double _getAverageFromArrayOfObjects(List<dynamic> response, String label) {
    double number = 0;
    for (var x = 0; x < response.length; x++) {
      number = number + response[x][label];
    }
    return number / response.length;
  }

  void _goToDetails(String barcode, Image image, String transactionId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetailsScreen(barcode: barcode, transactionId: transactionId, image: image)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
          future: _getItems(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }

              return GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: snapshot.data['target'],
                  zoom: 10.0, // TODO: use math for this...
                ),
                polylines: snapshot.data['polylines'],
                markers: snapshot.data['markers'],
                onMapCreated: (GoogleMapController controller) {
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  }
                },
              );
            }
            return new Container(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[CircularProgressIndicator()])));
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        label: Text('Close'),
        icon: Icon(Icons.close),
      ),
    );
  }
}
