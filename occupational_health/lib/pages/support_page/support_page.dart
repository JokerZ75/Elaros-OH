import "package:flutter/material.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/pages/support_page/components/my_rehab_content_card.dart";

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
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
                    onPressed: () {},
                  ),
                  MyRehabCard(
                    title: "Fatigue",
                    onPressed: () {},
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
          ],
        ),
      ),
    ));
  }
}
