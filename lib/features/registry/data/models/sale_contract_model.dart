import 'dart:convert';
import 'package:qlm_mobile_suite/features/registry/domain/entities/sale_contract_entity.dart';

class SaleContractModel extends SaleContract {
  SaleContractModel({
    required super.uuid,
    required super.registryEntryUuid,
    super.sellerName,
    super.sellerNationalId,
    super.buyerName,
    super.buyerNationalId,
    super.saleType,
    super.saleSubtype,
    super.saleArea,
    super.saleAreaQasab,
    super.saleAreaSqm,
    super.salePrice,
    super.taxAmount,
    super.taxReceiptNumber,
    super.zakatAmount,
    super.zakatReceiptNumber,
    super.propertyType,
    super.propertyLocation,
    super.propertyBoundaries,
    super.deedNumber,
    super.itemDescription,
    super.paymentMethod,
    super.witnesses,
  });

  factory SaleContractModel.fromJson(Map<String, dynamic> json) {
    return SaleContractModel(
      uuid: json['uuid'],
      registryEntryUuid: json['registry_entry_uuid'] ?? json['registry_entry_id']?.toString() ?? '',
      sellerName: json['seller_name'],
      sellerNationalId: json['seller_national_id'],
      buyerName: json['buyer_name'],
      buyerNationalId: json['buyer_national_id'],
      saleType: json['sale_type'],
      saleSubtype: json['sale_subtype'],
      saleArea: _toDouble(json['sale_area']),
      saleAreaQasab: json['sale_area_qasab'],
      saleAreaSqm: _toDouble(json['sale_area_sqm']),
      salePrice: _toDouble(json['sale_price']),
      taxAmount: _toDouble(json['tax_amount']),
      taxReceiptNumber: json['tax_receipt_number'],
      zakatAmount: _toDouble(json['zakat_amount']),
      zakatReceiptNumber: json['zakat_receipt_number'],
      propertyType: json['property_type'],
      propertyLocation: json['property_location'],
      propertyBoundaries: json['property_boundaries'],
      deedNumber: json['deed_number'],
      itemDescription: json['item_description'],
      paymentMethod: json['payment_method'],
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
      'seller_name': sellerName,
      'seller_national_id': sellerNationalId,
      'buyer_name': buyerName,
      'buyer_national_id': buyerNationalId,
      'sale_type': saleType,
      'sale_subtype': saleSubtype,
      'sale_area': saleArea,
      'sale_area_qasab': saleAreaQasab,
      'sale_area_sqm': saleAreaSqm,
      'sale_price': salePrice,
      'tax_amount': taxAmount,
      'tax_receipt_number': taxReceiptNumber,
      'zakat_amount': zakatAmount,
      'zakat_receipt_number': zakatReceiptNumber,
      'property_type': propertyType,
      'property_location': propertyLocation,
      'property_boundaries': propertyBoundaries,
      'deed_number': deedNumber,
      'item_description': itemDescription,
      'payment_method': paymentMethod,
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
