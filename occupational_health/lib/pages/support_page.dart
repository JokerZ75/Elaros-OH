import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/services/Auth/auth_service.dart";

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
            SizedBox(height: 30),
            Container(
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Rehabilitation content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                //  air pollution row
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          // width: double.infinity,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Expanded(
                                  child: Text(
                                    "Breathlessness",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2),
                                  ),
                                ),
                              ),
                              new Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, right: 12, top: 5, bottom: 5),
                                child: Expanded(
                                  child: MySubmitButton(
                                    onPressed: () {},
                                    minWidth: 10,
                                    textSize: 20,
                                    text: "More info",
                                    // need to style this text more
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
