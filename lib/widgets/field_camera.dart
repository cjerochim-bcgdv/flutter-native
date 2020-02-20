import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FieldCamera extends StatefulWidget {
  final LatLng location;
  final Function(String imagePath, LatLng location) onSnap;

  FieldCamera({this.location, this.onSnap});

  @override
  _FieldCameraState createState() => _FieldCameraState();
}

class _FieldCameraState extends State<FieldCamera> {
  List<CameraDescription> cameras;
  CameraController controller;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isReady = controller?.value != null;

    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: size.width,
        child: Column(
          children: <Widget>[
            Container(
              child: FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            isReady
                ? Expanded(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    ),
                  )
                : Container(),
            SnapButton(
              onSnap: () async {
                // Generate path
                final path = join((await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png');
                await controller.takePicture(path);

                widget.onSnap(path, widget.location);
              },
            )
          ],
        ),
      ),
    ));
  }
}

class SnapButton extends StatelessWidget {
  final Function onSnap;

  SnapButton({this.onSnap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: onSnap,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              border: Border.all(width: 4.0, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
      ),
    );
  }
}
