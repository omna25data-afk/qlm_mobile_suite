class GuardianAssignment {
  final int id;
  final String? assignedGuardianId;
  final String? assignedGuardianName;
  final String? originalGuardianId;
  final String? originalGuardianName;
  final int? geographicAreaId;
  final String? geographicAreaName;
  final String? assignmentType; // 'temporary_delegation' or 'permanent_transfer'
  final DateTime? startDate;
  final DateTime? endDate;
  final String? reason;
  final bool isActive;
  final String? notes;

  GuardianAssignment({
    required this.id,
    this.assignedGuardianId,
    this.assignedGuardianName,
    this.originalGuardianId,
    this.originalGuardianName,
    this.geographicAreaId,
    this.geographicAreaName,
    this.assignmentType,
    this.startDate,
    this.endDate,
    this.reason,
    required this.isActive,
    this.notes,
  });

  String get typeText => assignmentType == 'temporary_delegation' ? 'تكليف مؤقت' : 'نقل دائم';
  
  String get statusText {
    if (!isActive) return 'منتهي';
    if (endDate != null && endDate!.isBefore(DateTime.now())) return 'منتهي';
    return 'نشط';
  }
}
