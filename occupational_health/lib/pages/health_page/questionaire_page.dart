import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/services/Assessment/assessment_service.dart';

class QuestionairePage extends StatefulWidget {
  final void Function()? onAssessmentComplete;
  // Async onAssessmentComplete;
  final dynamic Function()? onAssessmentCompleteAsync;
  const QuestionairePage(
      {Key? key, this.onAssessmentComplete, this.onAssessmentCompleteAsync})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuestionairePageState();
}

class _QuestionairePageState extends State<QuestionairePage> {
  List<QuestionaireSection> sections = [
    QuestionaireSection(sectionTitle: "Breathlessness", questions: {
      "a. At Rest": -1,
      "b. Changing position e.g. from laying to sitting or sitting to laying":
          -1,
      "c. Dressing yourself": -1,
      "d. Walking upstairs": -1,
    }),
    QuestionaireSection(sectionTitle: "Throat sensitivity", questions: {
      "a. Cough / throat sensitivity": -1,
      "b. Change of voice": -1,
    }),
    QuestionaireSection(sectionTitle: "Fatigue", questions: {
      "a. Fatigue levels in usual activities": -1,
    }),
    QuestionaireSection(sectionTitle: "Smell / Taste", questions: {
      "a. Altered smell": -1,
      "b. Altered taste": -1,
    }),
    QuestionaireSection(sectionTitle: "Pain / Discomfort", questions: {
      "a. Chest pain": -1,
      "b. Joint pain": -1,
      "c. Muscle pain": -1,
      "d. Headache": -1,
      "e. Abdominal pain": -1,
    }),
    QuestionaireSection(sectionTitle: "Cognition", questions: {
      "a. Problems with concentration": -1,
      "b. Problems with memory": -1,
      "c. Problems with planning": -1,
    }),
    QuestionaireSection(sectionTitle: "Palpitations / Dizziness", questions: {
      "a. Palpitations in certain positions, activity or at rest ": -1,
      "b. Dizziness in certain positions, activity or  at rest": -1,
    }),
    QuestionaireSection(sectionTitle: "Worsening of symptoms", questions: {
      "a. Crashing or relapse hours or days after physical, cognitive or emotional exertion":
          -1,
    }),
    QuestionaireSection(sectionTitle: "Anxiety / Mood", questions: {
      "a. Feeling anxious": -1,
      "b. Feeling depressed": -1,
      "c. Having unwanted memories of your illness or time in hospital ": -1,
      "d. Having unpleasant dreams about your illness or time in hospital": -1,
      "e. Trying to avoid thoughts or feelings about your illness or time in hospital ":
          -1,
    }),
    QuestionaireSection(sectionTitle: "Sleep", questions: {
      "a. Sleep problems, such as difficulty falling asleep, staying asleep or oversleeping":
          -1
    }),
    QuestionaireSection(sectionTitle: "Communication", questions: {
      "a. Difficulty with communication/word finding difficulty/understanding others":
          -1
    }),
    QuestionaireSection(
        sectionTitle: "Walking or moving around ",
        questions: {"a. Difficulties with walking or moving around": -1}),
    QuestionaireSection(sectionTitle: "Personal", questions: {
      "a. Difficulties with personal tasks such as using the toilet or getting washed and dressed":
          -1
    }),
    QuestionaireSection(
        sectionTitle: "Other activities of Daily Living",
        questions: {
          "a. Difficulty doing wider activities, such as household work, leisure/sporting activities, paid/unpaid work, study or shopping":
              -1
        }),
    QuestionaireSection(sectionTitle: "Social role", questions: {
      "a. Problems with socialising/interacting with friends* or caring for dependants *related to your illness and not due to  social distancing/lockdown measures":
          -1
    }),
  ];

  PageController pageController = PageController();
  int pageNumber = 1;

  int indexOf(String value, List<String> array) {
    for (int i = 0; i < array.length; i++) {
      if (array[i] == value) {
        return i;
      }
    }
    //return a place holder value
    return -1;
  }

  // validator function
  (int, bool) validate() {
    for (var section in sections) {
      for (var question in section.questions.entries) {
        if (question.value == -1) {
          return (
            indexOf(section.sectionTitle,
                sections.map((e) => e.sectionTitle).toList()),
            false
          );
        }
      }
    }
    return (-1, true);
  }

  final AssessmentService _assessmentService = AssessmentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFB84C),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text("Questionnaire",
            style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Explanation questionaire system
                    const Text(
                        "0 = None; no problem\n1 = Mild; does not affect daily life\n2 = Moderate; affects some daily life\n3 = Severe; affects all aspects daily life and work",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            height: 1.1)),

                    const SizedBox(height: 20),

                    // Questionaire
                    SizedBox(
                      width: 350,
                      height: 475,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PageView(
                          controller: pageController,
                          onPageChanged: (value) {
                            setState(() {
                              pageNumber = value + 1;
                            });
                          },
                          children: <Widget>[
                            for (var section in sections)
                              _buildSection(section),
                          ],
                        ),
                      ),
                    ),

                    // Page Control buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    const CircleBorder()),
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => const Color(0xFFEFB84C)),
                                iconColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.black),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(50, 50)),
                                iconSize: MaterialStateProperty.all(35.0)),
                            onPressed: () {
                              pageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            },
                            child: const Icon(Icons.arrow_back_ios_new_rounded),
                          ),
                          const Spacer(flex: 1),

                          // Page Number and Total Pages
                          pageNumber == sections.length
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder()),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) =>
                                                  const Color(0xFFEFB84C)),
                                      iconColor: MaterialStateColor.resolveWith(
                                          (states) => Colors.black),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(50, 50)),
                                      iconSize:
                                          MaterialStateProperty.all(35.0)),
                                  onPressed: () async {
                                    var result = validate();
                                    if (result.$2 == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Assessment Complete"),
                                        ),
                                      );
                                      Map<String, Map<String, int>>
                                          questionaire = {};
                                      for (var section in sections) {
                                        questionaire[section.sectionTitle] =
                                            section.questions;
                                      }
                                      await _assessmentService
                                          .saveQuestionaire(questionaire);
                                      if (widget.onAssessmentComplete != null) {
                                        widget.onAssessmentComplete!();
                                      }
                                      if (widget.onAssessmentCompleteAsync !=
                                          null) {
                                        widget.onAssessmentCompleteAsync!();
                                      }
                                      Navigator.pop(context);
                                    } else {
                                      pageController.animateToPage(result.$1,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please answer all questions (Issues on page ${result.$1 + 1})'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.check),
                                )
                              : Text(
                                  'Page $pageNumber of ${sections.length}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                          const Spacer(flex: 1),
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    const CircleBorder()),
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => const Color(0xFFEFB84C)),
                                iconColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.black),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(50, 50)),
                                iconSize: MaterialStateProperty.all(35.0)),
                            onPressed: () {
                              pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            },
                            child: const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ],
                      ),
                    )
                  ]))),
    );
  }

  Widget _buildSection(QuestionaireSection section) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: section.sectionTitle,
          labelStyle: const TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFEFB84C), width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: ListView(children: <Widget>[
          for (var question in section.questions.entries)
            _buildQuestion(question.key, section.sectionTitle)
        ]),
      ),
    );
  }

  Widget _buildQuestion(String question, String sectionTitle) {
    String? selectedChoice = sections
        .firstWhere((element) => element.sectionTitle == sectionTitle)
        .questions[question]
        .toString();

    List<String> choices = ["0", "1", "2", "3"];

    void setSelectedChoice(String? choice) {
      selectedChoice = choice;
      setState(() {
        sections
            .firstWhere((element) => element.sectionTitle == sectionTitle)
            .questions[question] = int.parse(choice!);
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Question
          Text(
            question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              height: 1.1,
            ),
          ),

          // Single select choice
          SizedBox(
              width: 300,
              child: InlineChoice.single(
                  itemCount: choices.length,
                  value: selectedChoice,
                  onChanged: setSelectedChoice,
                  itemBuilder: (context, index) {
                    return ChoiceChip(
                      shape: const CircleBorder(),
                      showCheckmark: false,
                      selectedColor: const Color(0xFFEFB84C),
                      label: Text(choices[index]),
                      selected: context.selected(choices[index]),
                      onSelected: context.onSelected(choices[index]),
                    );
                  }))
        ],
      ),
    );
  }
}

class QuestionaireSection {
  final String sectionTitle;
  final Map<String, int> questions;

  QuestionaireSection({required this.sectionTitle, required this.questions});
}
