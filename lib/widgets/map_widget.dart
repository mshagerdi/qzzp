import 'dart:math';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:custom_info_window/custom_info_window.dart';

import '../providers/earthquakes.dart';

class MapWidget extends StatefulWidget {
  // const MapWidget({Key? key, String? clickedItemId}) : super(key: key);
  final String clickedItemId;
  final List<EarthquakeItem> earthquakes;

  MapWidget({
    required this.clickedItemId,
    required this.earthquakes,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  LatLng? _currentPosition;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();

    widget.clickedItemId != '0' ? _isLoading = false : _isLoading = true;
    getLocation();
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(44, 44)),
    //         'assets/images/Map-Marker.png')
    //     .then((onValue) {
    //   myIcon = onValue;
    // });
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void showInfoWindow(EarthquakeItem earthquake) {
    print('showInfoView ran!!');
    _customInfoWindowController.addInfoWindow!(
      Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: earthquake.color,
                          ),
                          child: Text(
                            '${earthquake.earthquakeClass.toString().split('.').last}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 9.0,
                        ),
                        Text(
                          '${earthquake.mag} Richter - ${DateFormat.yMMMd().add_Hms().format(earthquake.dateTime)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    Text.rich(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        text:
                            '${earthquake.dist1.toStringAsFixed(0)} kilometers from ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${earthquake.city1}, ${earthquake.province1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        text:
                            '${earthquake.dist2.toStringAsFixed(0)} kilometers from ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${earthquake.city2}, ${earthquake.province2}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        text:
                            '${earthquake.dist3.toStringAsFixed(0)} kilometers from ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${earthquake.city3}, ${earthquake.province3}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      '${earthquake.dep.toStringAsFixed(0)} kilometers depth',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Triangle.isosceles(
          //   edge: Edge.BOTTOM,
          //   child: Container(
          //     color: Colors.blue,
          //     width: 20.0,
          //     height: 10.0,
          //   ),
          // ),
        ],
      ),
      LatLng(
        earthquake.lat,
        earthquake.lng,
      ),
    );
  }

  void showMarker(EarthquakeItem earthquake) {
    Marker(
      markerId: MarkerId(earthquake.id),
      // icon: myIcon,
      onTap: () {
        showInfoWindow(earthquake);
      },
      position: LatLng(
        earthquake.lat,
        earthquake.lng,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final earthquakes = widget.earthquakes;

    List<Marker> _markers = [];
    List<Circle> _circles = [];
    for (var earthquake in earthquakes) {
      // print('id: $earthquake.id\n');
      _markers.add(
        Marker(
          markerId: MarkerId(earthquake.id),
          // icon: myIcon,
          onTap: () {
            showInfoWindow(earthquake);
          },
          infoWindow: InfoWindow(
            title:
                '${earthquake.mag} Richter - ${earthquake.city1}, ${earthquake.province1}',
            snippet: 'Tap marker for more Information.',
          ),
          position: LatLng(
            earthquake.lat,
            earthquake.lng,
          ),
        ),
      );
      _circles.add(
        Circle(
          circleId: CircleId(earthquake.id),
          center: LatLng(earthquake.lat, earthquake.lng),
          radius: pow(earthquake.mag, 4) * 100,
          fillColor: Colors.red.withOpacity(.2),
          strokeColor: Colors.white.withOpacity(.5),
          strokeWidth: 1,
        ),
      );
    }

    return Container(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  mapToolbarEnabled: false,
                  // myLocationButtonEnabled: true,
                  // myLocationEnabled: true,
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    _customInfoWindowController.googleMapController =
                        controller;

                    controller
                        .showMarkerInfoWindow(MarkerId(widget.clickedItemId));

                    showInfoWindow(
                        Provider.of<Earthquakes>(context, listen: false)
                            .findById(widget.clickedItemId));

                    // _customInfoWindowController.addInfoWindow!(
                    //     Text('data'),
                    //     LatLng(
                    //         Provider.of<Earthquakes>(context)
                    //             .findById(widget.clickedItemId)
                    //             .lat,
                    //         Provider.of<Earthquakes>(context)
                    //             .findById(widget.clickedItemId)
                    //             .lng));
                  },
                  markers: Set<Marker>.of(_markers),
                  circles: Set<Circle>.of(_circles),
                  initialCameraPosition: CameraPosition(
                    target: widget.clickedItemId != '0'
                        ? LatLng(
                            Provider.of<Earthquakes>(context)
                                .findById(widget.clickedItemId)
                                .lat,
                            Provider.of<Earthquakes>(context)
                                .findById(widget.clickedItemId)
                                .lng)
                        : _currentPosition!,
                    zoom: 6.0,
                  ),
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 121,
                  width: MediaQuery.of(context).size.width * .95,
                  offset: 50,
                ),
              ],
            ),
    );
  }
}
