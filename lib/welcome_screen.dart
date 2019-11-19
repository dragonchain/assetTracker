import 'package:asset_tracker/add_screen.dart';
import 'package:flutter/material.dart';

import 'list_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.add)),
                Tab(icon: Icon(Icons.list)),
              ],
            ),
            title: Text('Asset Tracker'),
          ),
          body: TabBarView(
            children: [
              AddScreen(),
              ListItemsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
