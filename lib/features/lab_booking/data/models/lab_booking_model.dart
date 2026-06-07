class LabBooking {
  final int id;
  final String collectionMode;
  final List<String> testNames;
  final String preferredDate;
  final String? preferredSlot;
  final double totalAmount;
  final String status;
  final String? labName;

  LabBooking({
    required this.id,
    required this.collectionMode,
    required this.testNames,
    required this.preferredDate,
    this.preferredSlot,
    required this.totalAmount,
    required this.status,
    this.labName,
  });
}
