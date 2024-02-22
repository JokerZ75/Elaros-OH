import "package:flutter/material.dart";
import "package:occupational_health/components/my_assessment_card.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/services/Auth/auth_service.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
              MySubmitButton(
                  onPressed: () {},
                  text: "Click To Take Your Daily Assessment"),
              // your environment
              const SizedBox(height: 30),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Your Environmment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Column(
                  children: <Widget>[
                    //  air pollution row
                    Row(
                      children: [
                        // text and icon
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "Air pollution",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2),
                              ),
                              Icon(Icons.info, size: 15),
                            ],
                          ),
                        ),
                        // need to get the air polution and display it here
                        Expanded(
                          child: Text(
                            '2 Low',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.2),
                          ),
                        ),
                      ],
                    ),
                    // Temperature
                    Row(
                      children: [
                        // text and icon
                        Expanded(
                          child: Text(
                            "Temperature ",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.2),
                          ),
                        ),
                        // need to get the temperature and display it here
                        Expanded(
                          child: Text(
                            '9°',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // recent assessments
              const SizedBox(height: 30),

              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Recent Assessments',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                //  air pollution row
                child: Column(children: <Widget>[
                  MyAssessmentCard(
                      title: "Assessment 35",
                      subtitle: "Date Taken: 19-02-2024",
                      onPressed: () {}),
                  MyAssessmentCard(
                      title: "Assessment 34",
                      subtitle: "Date Taken: 18-02-2024",
                      onPressed: () {}),
                  MyAssessmentCard(
                      title: "Assessment 33",
                      subtitle: "Date Taken: 18-02-2024",
                      onPressed: () {}),
                ]),
              ),

              // Container(
              //   child: InputDecorator(
              //     decoration: InputDecoration(
              //       labelText: 'Recent Assessments',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //     child: Column(
              //       children: <Widget>[
              //         //  air pollution row
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        )));
  }
}
