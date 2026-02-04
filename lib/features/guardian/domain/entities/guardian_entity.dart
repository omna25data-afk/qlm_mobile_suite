class Guardian {
  final String uuid;
  final String? firstName;
  final String? fatherName;
  final String? familyName;
  final String? fullName;
  final String? phoneNumber;
  final String? homePhone;
  final DateTime? birthDate;
  final String? birthPlace;
  final String? proofType;
  final String? proofNumber;
  final String? issuingAuthority;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String? qualification;
  final String? job;
  final String? workplace;
  final int? specializationAreaId;
  final String? specializationAreaName;
  final String? weaponLicenseNumber;
  final String? weaponLicenseType;
  final DateTime? weaponLicenseExpiry;
  final String? electronicCardNumber;
  final DateTime? electronicCardIssueDate;
  final DateTime? electronicCardExpiryDate;
  final String? employmentStatus;
  final DateTime? stopDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Guardian({
    required this.uuid,
    this.firstName,
    this.fatherName,
    this.familyName,
    this.fullName,
    this.phoneNumber,
    this.homePhone,
    this.birthDate,
    this.birthPlace,
    this.proofType,
    this.proofNumber,
    this.issuingAuthority,
    this.issueDate,
    this.expiryDate,
    this.qualification,
    this.job,
    this.workplace,
    this.specializationAreaId,
    this.specializationAreaName,
    this.weaponLicenseNumber,
    this.weaponLicenseType,
    this.weaponLicenseExpiry,
    this.electronicCardNumber,
    this.electronicCardIssueDate,
    this.electronicCardExpiryDate,
    this.employmentStatus,
    this.stopDate,
    this.createdAt,
    this.updatedAt,
  });
}
