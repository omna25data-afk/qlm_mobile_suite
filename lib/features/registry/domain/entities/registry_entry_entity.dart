class RegistryEntry {
  final String uuid;
  final int? serialNumber;
  final int? hijriYear;
  final int? constraintTypeId;
  final int? contractTypeId;
  final int? subtype1;
  final int? subtype2;
  
  // Party Names (Common for all contracts)
  final String? firstPartyName;
  final String? secondPartyName;
  
  // Writer Info
  final String? writerType; // guardian, documentation, external
  final int? writerId;
  final int? otherWriterId;
  final String? writerName;
  
  // Dates
  final DateTime? documentHijriDate;
  final DateTime? documentGregorianDate;
  
  // Documentation Data (doc_)
  final int? docRecordBookId;
  final String? docRecordBookNumber;
  final int? docPageNumber;
  final int? docEntryNumber;
  final String? docBoxNumber;
  final String? docDocumentNumber;
  final DateTime? docHijriDate;
  final DateTime? docGregorianDate;
  
  // Fee Data (decimal values stored as double)
  final double? feeAmount;
  final bool? hasAuthenticationFee;
  final double? authenticationFeeAmount;
  final bool? hasTransferFee;
  final double? transferFeeAmount;
  final bool? hasOtherFee;
  final double? otherFeeAmount;
  final double? penaltyAmount;
  final double? supportAmount;
  final String? receiptNumber;
  final double? sustainabilityAmount;
  final String? exemptionType;
  final String? exemptionReason;
  
  // Guardian Record Info (guardian_)
  final int? guardianId;
  final int? guardianRecordBookId;
  final String? guardianRecordBookNumber;
  final int? guardianPageNumber;
  final int? guardianEntryNumber;
  final DateTime? guardianHijriDate;
  
  // System State
  final String status; // draft, documented, archived
  final String? deliveryStatus;
  final String? notes;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Sync Meta (Local only)
  final bool isSynced;

  RegistryEntry({
    required this.uuid,
    this.serialNumber,
    this.hijriYear,
    this.constraintTypeId,
    this.contractTypeId,
    this.subtype1,
    this.subtype2,
    this.firstPartyName,
    this.secondPartyName,
    this.writerType,
    this.writerId,
    this.otherWriterId,
    this.writerName,
    this.documentHijriDate,
    this.documentGregorianDate,
    this.docRecordBookId,
    this.docRecordBookNumber,
    this.docPageNumber,
    this.docEntryNumber,
    this.docBoxNumber,
    this.docDocumentNumber,
    this.docHijriDate,
    this.docGregorianDate,
    this.feeAmount,
    this.hasAuthenticationFee,
    this.authenticationFeeAmount,
    this.hasTransferFee,
    this.transferFeeAmount,
    this.hasOtherFee,
    this.otherFeeAmount,
    this.penaltyAmount,
    this.supportAmount,
    this.receiptNumber,
    this.sustainabilityAmount,
    this.exemptionType,
    this.exemptionReason,
    this.guardianId,
    this.guardianRecordBookId,
    this.guardianRecordBookNumber,
    this.guardianPageNumber,
    this.guardianEntryNumber,
    this.guardianHijriDate,
    required this.status,
    this.deliveryStatus,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
  });
}
