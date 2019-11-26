import 'package:dragonchain_sdk/dragonchain_sdk.dart';
import 'package:flutter/material.dart';

import 'actions/get_dragonchain_client.dart';
import 'map_screen_path.dart';

class ListItemsScreen extends StatefulWidget {
  @override
  ListItemsScreenState createState() => ListItemsScreenState();
}

class ListItemsScreenState extends State<ListItemsScreen> {
  Future<List<dynamic>> _getItems() async {
    DragonchainClient dragonchainClient = await getDragonchainClient();
    var response = await dragonchainClient.getSmartContractObject('allItems', smartContractId);
    logger.d(response);
    if (response is Map && response['error'] != null && response['error']['type'] == 'NOT_FOUND') {
      return [];
    }
    return response;
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
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                if (snapshot.data.length == 0) {
                  var listTiles = ListTile(title: Text('Nothing here yet!'));
                  return new ListView(children: [listTiles]);
                } else {
                  var listTiles =
                      snapshot.data.map((f) => ListTile(onTap: () async => _goToMapView(f), leading: Icon(Icons.map), title: Text(f))).toList();
                  return new ListView(children: listTiles);
                }
              }
              return new ListView(children: [ListTile(leading: Icon(Icons.access_time), title: Text('Loading'))]);
            }));
  }
}
