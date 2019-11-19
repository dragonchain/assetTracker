import 'package:flutter/material.dart';

import 'map_screen.dart';

class ListItemsScreen extends StatefulWidget {
  @override
  ListItemsScreenState createState() => ListItemsScreenState();
}

class ListItemsScreenState extends State<ListItemsScreen> {
  Future<List<Map<String, String>>> _getItems() async {
    // TODO: call a dragonchain instead of sleeping for 1 second
    await new Future.delayed(const Duration(seconds: 1), () => "1");

    return [
      {"name": "thing", "barcode": "123123123"}
    ];
  }

  _goToMapView(String barcode) async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(barcode: barcode)));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: FutureBuilder(
            future: _getItems(),
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, String>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                var listTiles = snapshot.data
                    .map((f) => ListTile(onTap: () async => _goToMapView(f['barcode']), leading: Icon(Icons.map), title: Text(f['name'])))
                    .toList();
                return new ListView(children: listTiles);
              }
              return new ListView(children: [ListTile(leading: Icon(Icons.map), title: Text('Nothing Here'))]);
            }));
  }
}
