import "package:flutter/material.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/pages/support_page/components/my_rehab_content_card.dart";
import "package:occupational_health/pages/support_page/rehabilitation_page.dart";
import "package:occupational_health/services/Rehabilitation/rehabilitation_service.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher_string.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final RehabilitationService _rehabilitationService = RehabilitationService();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            FutureBuilder(
                future: _rehabilitationService.getLastViewedLocalStorage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text("Error");
                  }
                  if (snapshot.hasData) {
                    return _buildRecentRehabs(snapshot.data);
                  }
                  
                  return const Text("Error");
                }),
            const SizedBox(height: 30),
            const Text("Locate your nearest clinic"),
            const SizedBox(height: 15),
            Container(
              width: 350,
              height: 350,
              child: 53.383331 != null && -1.466667 != null
                  ? Stack(
                      children: [
                        FlutterMap(
                          options: MapOptions(
                            center: LatLng(53.383331 ?? 0.0, -1.466667 ?? 0.0),
                            zoom: 14,
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
                                      53.383331 ?? 0.0, -1.466667 ?? 0.0),
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
                                // Marker(
                                //   point: LatLng(53.383331 ?? 0.0, -1.466667 ?? 0.0),
                                //   width: 80,
                                //   height: 80,
                                //   child: Icon(
                                //     Icons.location_pin,
                                //     color: Colors.red.withOpacity(0.9),
                                //     size: 20,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildRecentRehabs(List<dynamic>? docs) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Rehabilitation content',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      //  air pollution row
      child: Column(
        children: [
          // Rehab Cards from docs
          if (docs != null && docs.isNotEmpty)
            for (var doc in docs)
              MyRehabCard(
                title: doc['Name'],
                onPressed: () {
                  launchUrlString(doc['URL']);
                },
              ),

          if (docs == null || docs.isEmpty)
            const Text("No recent content used"),

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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RehabilitationPage())).then((value) => setState(() {}));
                    },
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
    );
  }
}
