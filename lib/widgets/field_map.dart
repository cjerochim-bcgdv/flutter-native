import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FieldMap extends StatefulWidget {
  final LatLng location;
  final Map<MarkerId, Marker> markers;
  final Function(LatLng position) onLocation;

  FieldMap({
    this.location,
    this.onLocation,
    this.markers: const {},
  });

  @override
  _FieldMapState createState() => _FieldMapState();
}

class _FieldMapState extends State<FieldMap> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(40.688841, -74.044015), zoom: 18);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setCameraPosition(widget.location, 18);
//    setMarker(widget.location, '22222');
  }

//  void setMarker(LatLng position, String id) {
//    final MarkerId markerId = MarkerId(id);
//    final Marker marker = Marker(
//        markerId: markerId,
//        position: position,
//        onTap: () {
//          print('Hello');
//        });
////    setState(() {
////      markers[markerId] = marker;
////    });
//  }

  void setCameraPosition(LatLng position, double zoom) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onTap: widget.onLocation,
      mapType: MapType.satellite,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: initialPosition,
      markers: widget.markers.values.toSet(),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
