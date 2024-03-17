class QuestionaireAverages {

  // Map of Averages over time
  // {Month: {numberOfQuestionaires: num, section: average, section: average}, Month: {numberOfQuestionaires: num, section: average, section: average}
  // Months in multiples of 2
  final Map<int, Map<String, double>> monthlySectionAverages;

  // Map of overall averages
  // {section: average, section: average}
  final Map<String, double> overallAverages;

  QuestionaireAverages({
    required this.monthlySectionAverages,
    required this.overallAverages,
  });

  Map<String, dynamic> toMap() {
    return {
      'MonthlySectionAverages': {
        for (var month in monthlySectionAverages.keys)
          month.toString(): {
            for (var section in monthlySectionAverages[month]!.keys)
              section: monthlySectionAverages[month]![section],
          }
      },
      'OverallAverages': {
        for (var section in overallAverages.keys)
          section: overallAverages[section],
      },
    };
  }

  factory QuestionaireAverages.fromMap(Map<String, dynamic> map) {
    return QuestionaireAverages(
      monthlySectionAverages: {
        for (var month in map['MonthlySectionAverages'].keys)
          month: {
            for (var section in map['MonthlySectionAverages'][month].keys)
              section: map['MonthlySectionAverages'][month][section],
          }
      },
      overallAverages: {
        for (var section in map['OverallAverages'].keys)
          section: map['OverallAverages'][section],
      },
    );
  }
}