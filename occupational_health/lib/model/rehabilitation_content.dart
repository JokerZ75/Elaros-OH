class RehabilitationContent {
  final String name;
  final String url;

  RehabilitationContent({
    required this.name,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'URL': url,
    };
  }

  factory RehabilitationContent.fromMap(Map<String, dynamic> map) {
    return RehabilitationContent(
      name: map['Name'],
      url: map['URL'],
    );
  }
}