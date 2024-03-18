import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:occupational_health/model/questionaire_averages.dart';
import 'package:occupational_health/services/Assessment/assessment_service.dart';
import 'package:occupational_health/services/Auth/auth_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFPage {
  final AssessmentService _assessmentService = AssessmentService();

  Map<String, String> funcNames = {
    "Communication": "Communication",
    "Walking or moving around ": "Mobility",
    "Personal": "Personal Care",
    "Other activities of Daily Living": "Daily Activities",
    "Social role": "Social Role"
  };

  Map<String, String> symptomNames = {
    "Breathlessness": "Breathlessness", //
    "Throat sensitivity": "Throat sensitivity", //
    "Fatigue": "Fatigue", //
    "Smell / Taste": "Smell / Taste", //
    "Pain / Discomfort": "Pain / Discomfort", //
    "Cognition": "Cognition", //
    "Palpitations / Dizziness": "Palpitations / Dizziness", //
    "Worsening of symptoms": "Worsening", //
    "Anxiety / Mood": "Mood",
    "Sleep": "Sleep" //
  };

  Future<void> createPDF() async {
    final fontData = await rootBundle.load("fonts/Inter-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final QuestionaireAverages averages =
        await _assessmentService.getQuestionaireAverages();

    // Overall Averages
    Map<String, double> funcImpairmentAverages = {};
    for (var key in funcNames.keys) {
      funcImpairmentAverages[funcNames[key]!] = averages.overallAverages[key]!;
    }

    Map<String, double> symptomAverages = {};
    for (var key in symptomNames.keys) {
      symptomAverages[symptomNames[key]!] = averages.overallAverages[key]!;
    }

    // Monthly Averages
    Map<String, Map<String, double>> monthlyFuncImpairmentAverages = {};
    for (var month in averages.monthlySectionAverages.keys) {
      monthlyFuncImpairmentAverages[month] = {};
      for (var key in funcNames.keys) {
        monthlyFuncImpairmentAverages[month]![funcNames[key]!] =
            averages.monthlySectionAverages[month]![key]!;
      }
    }

    Map<String, Map<String, double>> monthlySymptomAverages = {};
    for (var month in averages.monthlySectionAverages.keys) {
      monthlySymptomAverages[month] = {};
      for (var key in symptomNames.keys) {
        monthlySymptomAverages[month]![symptomNames[key]!] =
            averages.monthlySectionAverages[month]![key]!;
      }
    }

    AuthService _authService = AuthService();

    // user data
    final user = await _authService.getUserData();

    

    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        maxPages: 20,
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(40),
          theme: pw.ThemeData.withFont(
            base: ttf,
          ),
        ),
        build: (pw.Context context) => [
              pw.Column(
                children: [
                  pw.Header(
                    level: 0,
                    child: pw.Text("C19-YRSm Long Covid Report | ${user.name}",
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  ),

                  // Personal Information Section
                  pw.Header(
                    level: 1,
                    child: pw.Text("Personal Information",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),

                  pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Text("Name: ",
                              style: const pw.TextStyle(fontSize: 14)),
                          pw.Text(user.name,
                              style: const pw.TextStyle(fontSize: 14)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("Email: ",
                              style: const pw.TextStyle(fontSize: 14)),
                          pw.Text(user.email,
                              style: const pw.TextStyle(fontSize: 14)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("Date of Birth: ",
                              style: const pw.TextStyle(fontSize: 14)),
                          pw.Text(user.dateOfBirth.toString().substring(0, 10),
                              style: const pw.TextStyle(fontSize: 14)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("Occupation: ",
                              style: const pw.TextStyle(fontSize: 14)),
                          pw.Text(user.occupation!,
                              style: const pw.TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),

                  // Scoring System Section
                  pw.Header(
                    level: 1,
                    child: pw.Text("Scoring System",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),

                  pw.Paragraph(
                      text:
                          "The scoring system used in this report is based on the C19-YRSm Long Covid Questionnaire. The questionnaire is designed to measure the severity of symptoms and functional impairment experienced by individuals with long covid. The questionnaire consists of 10 questions that measure the severity of symptoms and 5 questions that measure the severity of functional impairment. The questionnaire uses a 4-point scale to measure the severity of symptoms and functional impairment. The scores are as follows:"),

                  pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Text("0", style: const pw.TextStyle(fontSize: 14)),
                          pw.Spacer(),
                          pw.Text("No symptoms",
                              style: const pw.TextStyle(fontSize: 14)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("1", style: const pw.TextStyle(fontSize: 14)),
                          pw.Spacer(),
                          pw.Text("Mild symptoms",
                              style: const pw.TextStyle(fontSize: 14)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("2", style: const pw.TextStyle(fontSize: 14)),
                          pw.Spacer(),
                          pw.Text("Moderate symptoms",
                              style: const pw.TextStyle(fontSize: 14)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("3", style: const pw.TextStyle(fontSize: 14)),
                          pw.Spacer(),
                          pw.Text("Severe symptoms",
                              style: const pw.TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 5),

                  // Overall Averages Section
                  pw.Header(
                    level: 1,
                    child: pw.Text("Overall Averages",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),

                  // Symptoms Section
                  pw.Header(
                    level: 2,
                    child: pw.Text("Symptoms",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),

                  pw.SizedBox(height: 5),

                  pw.Column(
                    children: [
                      for (var key in symptomAverages.keys)
                        pw.Column(
                          children: [
                            pw.Row(
                              children: [
                                pw.Text(key,
                                    style: const pw.TextStyle(fontSize: 14)),
                                pw.Spacer(),
                                pw.Text(symptomAverages[key]!.toString(),
                                    style: const pw.TextStyle(fontSize: 14)),
                              ],
                            ),
                            // Divider - Non on last item
                            if (key != symptomAverages.keys.last)
                              pw.Container(
                                height: 1,
                                width: double.infinity,
                                color: PdfColors.black,
                              ),
                            pw.SizedBox(height: 5),
                          ],
                        ),
                    ],
                  ),

                  pw.SizedBox(height: 25),
                ],
              )
            ]));

    pdf.addPage(pw.MultiPage(
        maxPages: 20,
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(40),
          theme: pw.ThemeData.withFont(
            base: ttf,
          ),
        ),
        build: (pw.Context context) => [
              pw.Column(
                children: [
                  // Functional Impairment Section
                  pw.Header(
                    level: 2,
                    child: pw.Text("Functional Impairment",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),

                  pw.SizedBox(height: 5),

                  pw.Column(
                    children: [
                      for (var key in funcImpairmentAverages.keys)
                        pw.Column(
                          children: [
                            pw.Row(
                              children: [
                                pw.Text(key,
                                    style: const pw.TextStyle(fontSize: 14)),
                                pw.Spacer(),
                                pw.Text(funcImpairmentAverages[key]!.toString(),
                                    style: const pw.TextStyle(fontSize: 14)),
                              ],
                            ),
                            // Divider - Non on last item
                            if (key != funcImpairmentAverages.keys.last)
                              pw.Container(
                                height: 1,
                                width: double.infinity,
                                color: PdfColors.black,
                              ),
                            pw.SizedBox(height: 5),
                          ],
                        ),
                    ],
                  ),

                  pw.SizedBox(height: 25),
                ],
              )
            ]));

    pdf.addPage(pw.MultiPage(
        maxPages: 20,
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(40),
          theme: pw.ThemeData.withFont(
            base: ttf,
          ),
        ),
        build: (pw.Context context) => [
              pw.Column(
                children: [
                  // Monthly Averages Section
                  pw.Header(
                    level: 1,
                    child: pw.Text("Monthly Averages",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),

                  // Month 0
                  pw.Header(
                    level: 2,
                    child: pw.Text("Month 0",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),

                  // Functional Impairment Section
                  pw.Header(
                    level: 3,
                    child: pw.Text("Functional Impairment",
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  ),

                  pw.SizedBox(height: 5),

                  pw.Column(
                    children: [
                      for (var key in monthlyFuncImpairmentAverages["0"]!.keys)
                        pw.Column(
                          children: [
                            pw.Row(
                              children: [
                                pw.Text(key,
                                    style: const pw.TextStyle(fontSize: 14)),
                                pw.Spacer(),
                                pw.Text(
                                    monthlyFuncImpairmentAverages["0"]![key]!
                                        .toString(),
                                    style: const pw.TextStyle(fontSize: 14)),
                              ],
                            ),
                            // Divider - Non on last item
                            if (key !=
                                monthlyFuncImpairmentAverages["0"]!.keys.last)
                              pw.Container(
                                height: 1,
                                width: double.infinity,
                                color: PdfColors.black,
                              ),
                            pw.SizedBox(height: 5),
                          ],
                        ),
                    ],
                  ),

                  pw.SizedBox(height: 25),

                  // Symptoms Section

                  pw.Header(
                    level: 3,
                    child: pw.Text("Symptoms",
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  ),

                  pw.SizedBox(height: 5),

                  pw.Column(
                    children: [
                      for (var key in monthlySymptomAverages["0"]!.keys)
                        pw.Column(
                          children: [
                            pw.Row(
                              children: [
                                pw.Text(key,
                                    style: const pw.TextStyle(fontSize: 14)),
                                pw.Spacer(),
                                pw.Text(
                                    monthlySymptomAverages["0"]![key]!
                                        .toString(),
                                    style: const pw.TextStyle(fontSize: 14)),
                              ],
                            ),
                            // Divider - Non on last item
                            if (key != monthlySymptomAverages["0"]!.keys.last)
                              pw.Container(
                                height: 1,
                                width: double.infinity,
                                color: PdfColors.black,
                              ),
                            pw.SizedBox(height: 5),
                          ],
                        ),
                    ],
                  ),

                  pw.SizedBox(height: 25),
                ],
              )
            ]));

    
    // sort keys
    var keys = monthlyFuncImpairmentAverages.keys.toList();
    keys.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    for (var month in keys) {

      if (int.parse(month) != 0) {
        pdf.addPage(pw.MultiPage(
            maxPages: 20,
            pageTheme: pw.PageTheme(
              margin: const pw.EdgeInsets.all(40),
              theme: pw.ThemeData.withFont(
                base: ttf,
              ),
            ),
            build: (pw.Context context) => [
                  pw.Column(
                    children: [
                      pw.Header(
                        level: 2,
                        child: pw.Text("Month $month",
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      ),

                      // Functional Impairment Section
                      pw.Header(
                        level: 2,
                        child: pw.Text("Functional Impairment",
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      ),

                      pw.SizedBox(height: 5),

                      pw.Column(
                        children: [
                          for (var key
                              in monthlyFuncImpairmentAverages[month]!.keys)
                            pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Text(key,
                                        style:
                                            const pw.TextStyle(fontSize: 14)),
                                    pw.Spacer(),
                                    pw.Text(
                                        monthlyFuncImpairmentAverages[month]![
                                                key]!
                                            .toString(),
                                        style:
                                            const pw.TextStyle(fontSize: 14)),
                                  ],
                                ),
                                // Divider - Non on last item
                                if (key !=
                                    monthlyFuncImpairmentAverages[month]!
                                        .keys
                                        .last)
                                  pw.Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: PdfColors.black,
                                  ),
                                pw.SizedBox(height: 5),
                              ],
                            ),
                        ],
                      ),

                      pw.SizedBox(height: 25),

                      // Symptoms Section
                      pw.Header(
                        level: 2,
                        child: pw.Text("Symptoms",
                            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      ),

                      pw.SizedBox(height: 5),

                      pw.Column(
                        children: [
                          for (var key in monthlySymptomAverages[month]!.keys)
                            pw.Column(children: [
                              pw.Row(
                                children: [
                                  pw.Text(key,
                                      style: const pw.TextStyle(fontSize: 14)),
                                  pw.Spacer(),
                                  pw.Text(
                                      monthlySymptomAverages[month]![key]!
                                          .toString(),
                                      style: const pw.TextStyle(fontSize: 14)),
                                ],
                              ),
                              // Divider - Non on last item
                              if (key !=
                                  monthlySymptomAverages[month]!.keys.last)
                                pw.Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: PdfColors.black,
                                ),
                              pw.SizedBox(height: 5),
                            ]),
                        ],
                      ),
                      pw.SizedBox(height: 25),
                    ],
                  )
                ]));
      }
    }
    final path = await savePDF(pdf);
    OpenFile.open(path);
  }

  Future<String> savePDF(pw.Document pdf) async {
    final output = await getTemporaryDirectory();
    final file = File(
        "${output.path}/${FirebaseAuth.instance.currentUser!.email}_long_covid_report.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
