import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projectpan/backend/constants.dart';

class ExplorePage extends StatefulWidget {
  static const routeName = '/explore';
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final Completer<GoogleMapController> _controller = Completer();

  bool _isMap = false;

  void _showMap() {
    setState(() {
      _isMap = !_isMap;
    });

    if (_isMap == true) {
      Future.delayed(const Duration(seconds: 2), () async {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
      });
    } else {
      setState(() {
        _kGooglePlex = const CameraPosition(bearing: 0.0, target: LatLng(39.950661308649984, 32.83130945012413), tilt: 30.0, zoom: 15.5);
      });
    }
  }

  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(41.0395314254371, 28.994523171206644),
    bearing: 0.0,
    tilt: 45.0,
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(bearing: 0.0, target: LatLng(39.950661308649984, 32.83130945012413), tilt: 30.0, zoom: 15.5);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        // color: Colors.red,
        image: DecorationImage(
          image: AssetImage(
            'assets/img/dr2.jpg',
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: AnimatedContainer(
                  height: _isMap ? size.height * .40 : size.height * .75,
                  width: size.width * .90,
                  constraints: BoxConstraints(maxHeight: size.height * .75, minWidth: size.width * .90),
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(color: ebonyclay.withOpacity(.65), borderRadius: BorderRadius.circular(20), backgroundBlendMode: BlendMode.colorDodge),
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Doctor Strange 2 (IMAX)', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black, overflow: TextOverflow.fade)),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: 'TARİH\n', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black)),
                                  TextSpan(text: '05.04.22', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.black)),
                                ],
                              ),
                            ),
                            const Spacer(),
                            RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: 'SAAT\n', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black)),
                                  TextSpan(text: '21.05', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.black)),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const Divider(thickness: 1, color: Colors.black, height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: 'KOLTUK\n', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black)),
                                  TextSpan(text: '9G', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.black)),
                                ],
                              ),
                            ),
                            const Spacer(),
                            RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: 'KONUM\n', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black)),
                                  TextSpan(text: 'AnkaMall\nCinemaximum', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.black, overflow: TextOverflow.fade)),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            height: size.height * .35,
                            width: size.height * .35,
                            child: qrIcon,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                reverseDuration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _isMap
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              indoorViewEnabled: false,
                              liteModeEnabled: false,
                              trafficEnabled: false,
                              buildingsEnabled: false,
                              compassEnabled: false,
                            ),
                          ),
                          Positioned(
                            child: IconButton(
                              onPressed: () => _showMap(),
                              icon: const Icon(Icons.close),
                            ),
                            right: 5,
                            top: 5,
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () => _showMap(),
                        child: Container(
                          alignment: Alignment.center,
                          height: 75,
                          width: size.width * 85,
                          decoration: BoxDecoration(color: woodsmoke, borderRadius: BorderRadius.circular(20)),
                          child: const Text('KONUMU GÖSTER', style: TextStyle(color: Colors.white)),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(ExplorePage._kLake));
  // }
}
