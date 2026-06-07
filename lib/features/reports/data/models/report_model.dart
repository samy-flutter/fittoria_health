class ReportModel {
  final int id;
  final String reportType;
  final String title;
  final String periodFrom;
  final String periodTo;
  final String createdAt;
  final String byName;
  final String source;

  ReportModel({
    required this.id,
    required this.reportType,
    required this.title,
    required this.periodFrom,
    required this.periodTo,
    required this.createdAt,
    required this.byName,
    required this.source,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as int? ?? 0,
      reportType: json['report_type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      periodFrom: json['period_from'] as String? ?? '',
      periodTo: json['period_to'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      byName: json['by_name'] as String? ?? '',
      source: json['source'] as String? ?? '',
    );
  }
}
