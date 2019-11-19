import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final String barcode;
  @override
  MapScreen({@required this.barcode});

  State<MapScreen> createState() => MapSampleState();
}

class MapSampleState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final _seattle = LatLng(47.608013, -122.335167);
  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799, target: LatLng(37.43296265331129, -122.08832357078792), tilt: 59.440717697143555, zoom: 19.151926040649414);

  Future<dynamic> _getItems() async {
    // TODO: Actually call a dragonchain.
    // DragonchainClient dragonchainClient = await getDragonchainClient();
    // dragonchainClient.getSmartContractObject(this.widget.barcode, 'someContractId')

    await new Future.delayed(const Duration(seconds: 1), () => "1"); // kill this
    var response = [
      {'latitude': 47.608013, 'longitude': -122.335167, 'barcode': 'banana'},
      {'latitude': 47.609024, 'longitude': -122.332154, 'barcode': 'banana'},
      {'latitude': 47.605015, 'longitude': -122.333173, 'barcode': 'banana'},
      {'latitude': 47.603036, 'longitude': -122.335181, 'barcode': 'banana'},
    ];

    var polylinePoints = response.map((Map<String, dynamic> point) => LatLng(point['latitude'], point['longitude'])).toList();
    var markers = response
        .map((Map<String, dynamic> point) => Marker(markerId: MarkerId(point['barcode']), position: LatLng(point['latitude'], point['longitude'])))
        .toSet();
    Polyline polyline = new Polyline(polylineId: PolylineId(response[0]['barcode']), points: polylinePoints, color: Color.fromRGBO(221, 80, 76, 1));
    return {
      'polylines': [polyline].toSet(),
      'markers': markers
    };
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
                  target: _seattle,
                  zoom: 14.4746,
                ),
                polylines: snapshot.data['polylines'],
                markers: snapshot.data['markers'],
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
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
