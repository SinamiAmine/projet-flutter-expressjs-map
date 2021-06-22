import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projectpfe/constants.dart';
import 'package:projectpfe/screens/foncierScreen/components/from_fonciers.dart';

class MapHybrid extends StatefulWidget {
  const MapHybrid({Key? key}) : super(key: key);

  @override
  _MapHybridState createState() => _MapHybridState();
}

class _MapHybridState extends State<MapHybrid> {
  String? lati;
  String? long;
  GoogleMapController? googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position? position;
  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(snippet: 'Address'));
    setState(() {
      markers[markerId] = _marker;
    });
  }

  void getCurrentLocation() async {
    Position currentPosition =
        await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(33.5333312, -7.583331),
    zoom: 11.5,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mark an place'),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 600.0,
              child: GoogleMap(
                onTap: (tapped) async {
                  getMarkers(tapped.latitude, tapped.longitude);
                  setState(() {
                    lati = tapped.latitude.toString();
                    long = tapped.longitude.toString();
                    print(lati);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new FormFonciers(
                                selectedFonciers,
                                tapped.latitude.toString(),
                                tapped.longitude.toString())));
                  });
                },
                mapType: MapType.hybrid,
                compassEnabled: true,
                trafficEnabled: true,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    googleMapController = controller;
                  });
                },
                markers: Set<Marker>.of(markers.values),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
