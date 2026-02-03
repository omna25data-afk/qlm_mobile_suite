class MarriageContract {
  final String uuid;
  final String registryEntryUuid;
  final String? husbandName;
  final String? groomNationalId;
  final DateTime? husbandBirthDate;
  final int? groomAge;
  final String? wifeName;
  final String? brideNationalId;
  final DateTime? wifeBirthDate;
  final int? wifeAge;
  final int? brideAge;
  final String? guardianName;
  final String? guardianRelation;
  final double? dowryAmount;
  final double? dowryPaid;
  final List<String>? witnesses;

  MarriageContract({
    required this.uuid,
    required this.registryEntryUuid,
    this.husbandName,
    this.groomNationalId,
    this.husbandBirthDate,
    this.groomAge,
    this.wifeName,
    this.brideNationalId,
    this.wifeBirthDate,
    this.wifeAge,
    this.brideAge,
    this.guardianName,
    this.guardianRelation,
    this.dowryAmount,
    this.dowryPaid,
    this.witnesses,
  });
}
