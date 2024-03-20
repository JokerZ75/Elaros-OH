import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/components/my_top_progress_card.dart';
import 'package:occupational_health/pages/page_view_main.dart';
import 'package:occupational_health/services/Assessment/assessment_service.dart';
import 'package:occupational_health/services/Assessment/onboard_questionaire_page.dart';

class OnboardGate extends StatefulWidget {
  const OnboardGate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnboardGateState();
}

class _OnboardGateState extends State<OnboardGate> {
  bool isOnboarded = false;
  final AssessmentService _assessmentService = AssessmentService();

  @override
  void initState() {
    super.initState();
    checkOnboard();
  }

  void checkOnboard() async {
    bool onboarded = await _assessmentService.hasTakenOnboardingQuestionaire();
    setState(() {
      isOnboarded = onboarded;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isOnboarded) {
      return const ListViewMain();
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                // Welcome text
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 50),
                      Text(
                        "Welcome to Occupational Health",
                        style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w600,
                            height: 1.2),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Please take the onboarding questionaire to measure your pre-covid stats...",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            height: 1.2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),

                // login button
                MySubmitButton(
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OnBoardQuestionairePage()))
                          .then((value) => {
                                if (value == true)
                                  {
                                    MyTopProgressCard(
                                            duration:
                                                const Duration(seconds: 2),
                                            title:
                                                "Checking Onboarding Status...",
                                            distanceFromTop: 200)
                                        .showSnackBar(context),
                                    Future.delayed(
                                        const Duration(seconds: 2),
                                        () => {
                                              checkOnboard(),
                                            })
                                  }
                              });
                    },
                    text: "Take Onboarding Questionaire"),
              ],
            ),
          )));
    }
  }
}
