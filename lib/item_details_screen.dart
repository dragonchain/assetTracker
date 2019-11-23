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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(child: Center(child: Column(children: <Widget>[this.widget.image, Text(this.widget.transactionId)]))),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pop(context),
          label: Text('Back'),
          icon: Icon(Icons.arrow_back),
        ));
  }
}
