import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_app/location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationTab extends StatefulWidget {
  const LocationTab({Key? key}) : super(key: key);

  static const routeName = '/location-screen';

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  final double _defaultLat = MyLocation.currentPosition!.latitude;
  final double _defaultLng = MyLocation.currentPosition!.longitude;

  late final GoogleMapController _googleMapController;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};

  // asking for permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  // getting address from lat and lng
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(MyLocation.currentPosition!.latitude,
            MyLocation.currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        MyLocation.currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // getting current position and address
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => MyLocation.currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => MyLocation.currentPosition = position);
      _getAddressFromLatLng(MyLocation.currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  // adding a new marker when the map is tapped
  Future<void> _handleTap(LatLng tappedPoint) async {
    String newAddress = '';
    await placemarkFromCoordinates(
      tappedPoint.latitude,
      tappedPoint.longitude,
    ).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      newAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    }).catchError((e) {
      debugPrint(e);
    });
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: newAddress,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    final CameraPosition defaultLocation = CameraPosition(
      target: LatLng(_defaultLat, _defaultLng),
      zoom: 15,
    );

    _markers.add(
      Marker(
        markerId: MarkerId('${MyLocation.currentAddress}'),
        position: defaultLocation.target,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: MyLocation.currentAddress,
        ),
      ),
    );

    Future<void> _goToCurrentLocation() async {
      final _currentPosition = LatLng(
        MyLocation.currentPosition!.latitude,
        MyLocation.currentPosition!.longitude,
      );
      _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15),
      );
      setState(() {
        Marker marker = Marker(
          markerId: MarkerId('${MyLocation.currentAddress}'),
          position: defaultLocation.target,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: MyLocation.currentAddress,
          ),
        );
        _markers
          ..clear()
          ..add(marker);
      });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Stack(
                  children: [
                    SizedBox(
                      height: h * 0.73,
                      width: double.infinity,
                      child: GoogleMap(
                        onMapCreated: (controller) =>
                            _googleMapController = controller,
                        initialCameraPosition: defaultLocation,
                        mapType: _currentMapType,
                        markers: _markers,
                        onTap: _handleTap,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 24, right: 12),
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          FloatingActionButton(
                            onPressed: _changeMapType,
                            backgroundColor: Colors.green,
                            child: const Icon(
                              Icons.map,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FloatingActionButton(
                            onPressed: _goToCurrentLocation,
                            backgroundColor: Colors.red,
                            child: const Icon(
                              Icons.home_rounded,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
