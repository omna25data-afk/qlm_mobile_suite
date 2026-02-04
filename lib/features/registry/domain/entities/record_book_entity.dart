class RecordBook {
  final int id;
  final int legitimateGuardianId;
  final String? bookNumber;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final bool isFull;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RecordBook({
    required this.id,
    required this.legitimateGuardianId,
    this.bookNumber,
    this.startDate,
    this.endDate,
    this.status,
    this.isFull = false,
    this.createdAt,
    this.updatedAt,
  });
}
