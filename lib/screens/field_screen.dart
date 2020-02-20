import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onsite_map_location/models/maker_content.dart';
import 'package:onsite_map_location/models/user_location.dart';
import 'package:onsite_map_location/widgets/field_camera.dart';
import 'package:onsite_map_location/widgets/field_map.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock/wakelock.dart';

Uuid uuid = Uuid();

class FieldScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  FieldScreen({this.cameras: const []});

  @override
  _FieldScreenState createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  bool isActive = false;
  LatLng currentLocation;
  Map<MarkerId, Marker> markers = {};

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext rootContext) {
    var userLocation = Provider.of<UserLocation>(rootContext);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: userLocation?.longitude != null
                // Accept a list of markers
                // Determine the current point;
                ? FieldMap(
                    markers: markers,
                    location: LatLng(
                      userLocation.latitude,
                      userLocation.longitude,
                    ),
                    onLocation: (LatLng v) {
                      // TODO - update icon image
                      // TODO - Add current position
                      // TODO - Set camera to take pick with sheet
                      Navigator.push(
                        rootContext,
                        MaterialPageRoute(
                          builder: (context) => FieldCamera(
                            location: v,
                            onSnap: (String imagePath, LatLng location) {
                              // Generate marker and push to list
                              MarkerId id = MarkerId(uuid.v4());
                              Marker marker = Marker(
                                markerId: id,
                                position: location,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: rootContext,
                                    builder: (BuildContext context) {
                                      print(imagePath);
                                      return Container(
                                        padding: EdgeInsets.all(16.0),
                                        height: 300,
                                        child: Image.file(File(imagePath)),
                                      );
                                    },
                                  );
                                },
                              );
                              setState(() {
                                markers[id] = marker;
                              });

                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  )
                : null,
          ),
          Container(),
        ],
      ),
    );
  }
}
