import "package:flutter/material.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/pages/support_page/components/my_rehab_content_card.dart";
import "package:url_launcher/url_launcher_string.dart";
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:flutter_google_maps_webservices/places.dart";

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "Enter Key");

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

    return await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<List<PlacesSearchResult>> getNearbyHospitals(Position position) async {
    PlacesSearchResponse response = await _places.searchNearbyWithRadius(
      Location(lat: position.latitude, lng: position.longitude),
      8047, // 5 miles in meters
      type: "hospital",
    );

    if (response.status == "OK") {
      return response.results;
    } else {
      throw Exception(
          'Failed to fetch nearby restaurants.\nError: ${response.status}');
    }
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
            const Text("Locate your nearest hospital"),
            const SizedBox(height: 15),

            FutureBuilder(
              future: getLocation(),
              builder:
                  (BuildContext context, AsyncSnapshot<Position> snapshot1) {
                if (snapshot1.hasData) {
                  return SizedBox(
                    width: 350,
                    height: 350,
                    child: Stack(
                      children: [
                        FutureBuilder(
                          future: getNearbyHospitals(snapshot1.data!),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<dynamic>> snapshot2) {
                            if (snapshot2.hasData) {
                              Set<Marker> markers = {};
                              for (var restaurant in snapshot2.data!) {
                                markers.add(
                                  Marker(
                                    markerId: MarkerId(restaurant.placeId),
                                    // markerId: MarkerId(restaurant.id),
                                    position: LatLng(
                                        restaurant.geometry.location.lat,
                                        restaurant.geometry.location.lng),
                                    infoWindow: InfoWindow(
                                      title: restaurant.name,
                                      snippet: restaurant.vicinity,
                                    ),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueBlue),
                                  ),
                                );
                              }
                              markers.add(
                                Marker(
                                    markerId: const MarkerId('currentLocation'),
                                    position: LatLng(snapshot1.data!.latitude,
                                        snapshot1.data!.longitude),
                                    infoWindow: const InfoWindow(
                                      title: 'Your Location',
                                    ),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueRed)),
                              );
                              return GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(snapshot1.data!.latitude,
                                      snapshot1.data!.longitude),
                                  zoom: 12,
                                ),
                                markers: markers,
                              );
                            } else if (snapshot2.hasError) {
                              return Text('${snapshot2.error}');
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        //
                      ],
                    ),
                  );
                } else if (snapshot1.hasError) {
                  return Text('Error: ${snapshot1.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    ));
  }
}
