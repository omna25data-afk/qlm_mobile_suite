import 'dart:convert';
import 'package:qlm_mobile_suite/features/registry/domain/entities/marriage_contract_entity.dart';

class MarriageContractModel extends MarriageContract {
  MarriageContractModel({
    required super.uuid,
    required super.registryEntryUuid,
    super.husbandName,
    super.groomNationalId,
    super.husbandBirthDate,
    super.groomAge,
    super.wifeName,
    super.brideNationalId,
    super.wifeBirthDate,
    super.wifeAge,
    super.brideAge,
    super.guardianName,
    super.guardianRelation,
    super.dowryAmount,
    super.dowryPaid,
    super.witnesses,
  });

  factory MarriageContractModel.fromJson(Map<String, dynamic> json) {
    return MarriageContractModel(
      uuid: json['uuid'],
      registryEntryUuid: json['registry_entry_uuid'] ?? json['registry_entry_id']?.toString() ?? '',
      husbandName: json['husband_name'],
      groomNationalId: json['groom_national_id'],
      husbandBirthDate: json['husband_birth_date'] != null ? DateTime.parse(json['husband_birth_date']) : null,
      groomAge: json['groom_age'],
      wifeName: json['wife_name'],
      brideNationalId: json['bride_national_id'],
      wifeBirthDate: json['wife_birth_date'] != null ? DateTime.parse(json['wife_birth_date']) : null,
      wifeAge: json['wife_age'],
      brideAge: json['bride_age'],
      guardianName: json['guardian_name'],
      guardianRelation: json['guardian_relation'],
      dowryAmount: _toDouble(json['dowry_amount']),
      dowryPaid: _toDouble(json['dowry_paid']),
      witnesses: json['witnesses'] != null 
          ? (json['witnesses'] is String 
              ? List<String>.from(jsonDecode(json['witnesses'])) 
              : List<String>.from(json['witnesses']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'registry_entry_uuid': registryEntryUuid,
      'husband_name': husbandName,
      'groom_national_id': groomNationalId,
      'husband_birth_date': husbandBirthDate?.toIso8601String(),
      'groom_age': groomAge,
      'wife_name': wifeName,
      'bride_national_id': brideNationalId,
      'wife_birth_date': wifeBirthDate?.toIso8601String(),
      'wife_age': wifeAge,
      'bride_age': brideAge,
      'guardian_name': guardianName,
      'guardian_relation': guardianRelation,
      'dowry_amount': dowryAmount,
      'dowry_paid': dowryPaid,
      'witnesses': witnesses != null ? jsonEncode(witnesses) : null,
    };
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }
}
