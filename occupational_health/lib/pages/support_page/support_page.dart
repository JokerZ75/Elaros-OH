import "package:flutter/material.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/pages/support_page/components/my_rehab_content_card.dart";
import "package:url_launcher/url_launcher_string.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  // https://www.dhiwise.com/post/maximizing-user-experience-integrating-flutter-geolocator
  // this website was used to help with the location services, both getting the location and displaying it on the map
  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
    // forceAndroidLocationManager: true,
    // desiredAccuracy: LocationAccuracy.best);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // your environment
            const SizedBox(height: 30),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Rehabilitation content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              //  air pollution row
              child: Column(
                children: [
                  MyRehabCard(
                    title: "Breathlessness",
                    onPressed: () {
                      launchUrlString(
                          'https://www.yourcovidrecovery.nhs.uk/i-think-i-have-long-covid/effects-on-your-body/breathlessness/');
                    },
                  ),
                  MyRehabCard(
                    title: "Fatigue",
                    onPressed: () {
                      launchUrlString(
                          'https://www.yourcovidrecovery.nhs.uk/i-think-i-have-long-covid/effects-on-your-body/fatigue/');
                    },
                  ),

                  // Button linking for more
                  Card(
                    elevation: 5,
                    color: const Color(0xFFEFB84C),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          // Button linking for more
                          Expanded(
                              child: MySubmitButton(
                            onPressed: () {},
                            text: "Click Here For More",
                            minWidth: 110,
                            lineHeight: 20,
                            textSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text("Locate your nearest clinic"),
            const SizedBox(height: 15),

            FutureBuilder(
              future: getLocation(),
              builder:
                  (BuildContext context, AsyncSnapshot<Position> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: 350,
                    height: 350,
                    child: Stack(
                      children: [
                        FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              snapshot.data!.latitude,
                              snapshot.data!.longitude,
                            ),
                            initialZoom: 14,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            CircleLayer(
                              circles: [
                                CircleMarker(
                                  point: LatLng(
                                    snapshot.data!.latitude,
                                    snapshot.data!.longitude,
                                  ),
                                  radius: 350,
                                  useRadiusInMeter: true,
                                  color: Colors.blue.withOpacity(0.2),
                                  borderColor: Colors.red.withOpacity(0.7),
                                  borderStrokeWidth: 2,
                                )
                              ],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(
                                    snapshot.data!.latitude,
                                    snapshot.data!.longitude,
                                  ),
                                  width: 80,
                                  height: 80,
                                  child: Icon(
                                    Icons.location_pin,
                                    color: Colors.red.withOpacity(0.9),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                // CircularProgressIndicator while waiting for the location permission
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    ));
  }
}
