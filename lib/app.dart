import 'package:flutter/material.dart';
import 'package:onsite_map_location/models/user_location.dart';
import 'package:onsite_map_location/screens/field_screen.dart';
import 'package:onsite_map_location/services/location_service.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (BuildContext context) => LocationService().locationStream,
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: FieldScreen(),
      ),
    );
  }
}
