import 'package:choice/choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/services/Assessment/assessment_service.dart';
import 'package:occupational_health/model/questionaire.dart';

class CompleteQuestionariePage extends StatefulWidget {
  final String id;
  const CompleteQuestionariePage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CompleteQuestionariePageState();
}

class _CompleteQuestionariePageState extends State<CompleteQuestionariePage> {
  final AssessmentService _assessmentService = AssessmentService();
  Questionaire _questionaire = Questionaire(
    questionaire: {},
    timestamp: Timestamp.now(),
  );

  List<QuestionaireSection> sections = [
    // use the questionaire we fetched from the database
    
    
  ];

  @override
  void initState() {
    super.initState();
    _assessmentService.getQuestionaireById(widget.id).then((questionaire) {
      setState(() {
        _questionaire = questionaire;
        sections = _questionaire.questionaire.entries
            .map((entry) => QuestionaireSection(
                  sectionTitle: entry.key,
                  questions: entry.value,
                ))
            .toList();
      });
    });
  }

  PageController pageController = PageController();
  int pageNumber = 1;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFB84C),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title:  Text(_questionaire.timestamp.toDate().toString().substring(0, 10),
            style: const TextStyle(
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

                          // Page Number
                          Text(
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
                  itemBuilder: (context, index) {
                    return ChoiceChip(
                      shape: const CircleBorder(),
                      showCheckmark: false,
                      selectedColor: const Color(0xFFEFB84C),
                      label: Text(choices[index]),
                      selected: context.selected(choices[index]),
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
