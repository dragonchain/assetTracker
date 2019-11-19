import 'package:flutter/material.dart';

class ListItemsScreen extends StatefulWidget {
  @override
  ListItemsScreenState createState() => ListItemsScreenState();
}

class ListItemsScreenState extends State<ListItemsScreen> {
  Future<List<Map<String, String>>> _getItems() async {
    //TODO: call dragonchain instead of sleep
    await new Future.delayed(const Duration(seconds: 1), () => "1");

    return [
      {"name": "thing", "barcode": "123123123"}
    ];
  }

  @override
  void initState() {
    super.initState();
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
                var banana = snapshot.data.map((f) => ListTile(leading: Icon(Icons.map), title: Text(f['name']))).toList();

                return new ListView(children: banana);
              }
              return new ListView(children: [ListTile(leading: Icon(Icons.map), title: Text('Nothing Here'))]);
            }));
  }
}
