import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenSingle extends StatefulWidget {
  final String barcode;
  final LatLng newPoint;
  @override
  MapScreenSingle({@required this.barcode, this.newPoint});

  State<MapScreenSingle> createState() => MapSampleState();
}

class MapSampleState extends State<MapScreenSingle> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
            target: this.widget.newPoint,
            zoom: 14.4746,
          ),
          markers: [Marker(markerId: MarkerId(this.widget.barcode), position: this.widget.newPoint)].toSet(),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pop(context),
          label: Text('Close'),
          icon: Icon(Icons.close),
        ));
  }
}
