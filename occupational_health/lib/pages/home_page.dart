import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/services/Auth/auth_service.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() async {
    final AuthService authService = AuthService();
    try {
      await authService.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // sample past assessment data, will need to actually take the three most recent ones from database
  var assessmentData = {
    'tsSubCmds': [
      {'assessmentNumber': "35", 'dateTaken': "19-02-2024"},
      {'assessmentNumber': "34", 'dateTaken': "18-02-2024"},
      {'assessmentNumber': "33", 'dateTaken': "18-02-2024"}
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: [
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              MySubmitButton(
                  onPressed: () {},
                  text: "Click To Take Your Daily Assessment"),
              // your environment
              SizedBox(height: 30),
              Container(
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Your Environmment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      //  air pollution row
                      Container(
                        child: Row(
                          children: [
                            // text and icon
                            Expanded(
                              child: Container(
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
                            ),
                            // need to get the air polution and display it here
                            Expanded(
                              child: Container(
                                child: Text(
                                  '2 Low',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Temperature
                      Container(
                        child: Row(
                          children: [
                            // text and icon
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Temperature ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2),
                                ),
                              ),
                            ),
                            // need to get the temperature and display it here
                            Expanded(
                              child: Container(
                                child: Text(
                                  '9°',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // recent assessments
              SizedBox(height: 30),
              Container(
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Recent Assessments',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  //  air pollution row
                  child: Column(
                    children: List.generate(3, (index) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
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
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Assessment ${assessmentData['tsSubCmds']![index]['assessmentNumber']}",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              height: 1.2),
                                        ),
                                        Text(
                                          "Date Taken: ${assessmentData['tsSubCmds']![index]['dateTaken']}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              height: 1.2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                      );
                    }),
                  ),
                ),
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
