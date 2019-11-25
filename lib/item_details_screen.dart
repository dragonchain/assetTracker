import 'package:asset_tracker/actions/get_dragonchain_client.dart';
import 'package:dragonchain_sdk/dragonchain_sdk.dart';
import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String barcode;
  final Image image;
  final String transactionId;
  @override
  ItemDetailsScreen({@required this.barcode, @required this.image, @required this.transactionId});

  State<ItemDetailsScreen> createState() => MapSampleState();
}

class MapSampleState extends State<ItemDetailsScreen> {
  Future<Map<String, dynamic>> _getReport() async {
    // facd3ccf-b116-4a54-8276-127949077dc2
    DragonchainClient dragonchainClient = await getDragonchainClient();
    var transactionResponse = await dragonchainClient.getTransaction(this.widget.transactionId);
    var verifications = await dragonchainClient.getVerifications(transactionResponse['header']['block_id']);
    return verifications;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: FutureBuilder(
            future: _getReport(),
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                String string =
                    "2:${snapshot.data['2'].length} 3:${snapshot.data['3'].length} 4:${snapshot.data['4'].length} 5:${snapshot.data['5'].length}";
                // after loaded...
                return Scaffold(
                    body:
                        Container(child: Center(child: Column(children: <Widget>[this.widget.image, Text(this.widget.transactionId), Text(string)]))),
                    floatingActionButton: FloatingActionButton.extended(
                      onPressed: () => Navigator.pop(context),
                      label: Text('Back'),
                      icon: Icon(Icons.arrow_back),
                    ));
              }

              // before loaded.....
              return Scaffold(body: Container(child: Center(child: Column(children: <Widget>[Text("Loading...")]))));
            }));
  }
}
