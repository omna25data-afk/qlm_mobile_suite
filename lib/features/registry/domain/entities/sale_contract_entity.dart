class SaleContract {
  final String uuid;
  final String registryEntryUuid;
  final String? sellerName;
  final String? sellerNationalId;
  final String? buyerName;
  final String? buyerNationalId;
  final String? saleType; // movable, non-movable
  final String? saleSubtype;
  final double? saleArea;
  final String? saleAreaQasab;
  final double? saleAreaSqm;
  final double? salePrice;
  final double? taxAmount;
  final String? taxReceiptNumber;
  final double? zakatAmount;
  final String? zakatReceiptNumber;
  final String? propertyType;
  final String? propertyLocation;
  final String? propertyBoundaries;
  final String? deedNumber;
  final String? itemDescription;
  final String? paymentMethod;
  final List<String>? witnesses;

  SaleContract({
    required this.uuid,
    required this.registryEntryUuid,
    this.sellerName,
    this.sellerNationalId,
    this.buyerName,
    this.buyerNationalId,
    this.saleType,
    this.saleSubtype,
    this.saleArea,
    this.saleAreaQasab,
    this.saleAreaSqm,
    this.salePrice,
    this.taxAmount,
    this.taxReceiptNumber,
    this.zakatAmount,
    this.zakatReceiptNumber,
    this.propertyType,
    this.propertyLocation,
    this.propertyBoundaries,
    this.deedNumber,
    this.itemDescription,
    this.paymentMethod,
    this.witnesses,
  });
}
