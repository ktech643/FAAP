class ScanHistoryModel {
  final int? id;
  final String barcode;
  final String productName;
  final String? brand;
  final String? imageUrl;
  final String riskLevel;
  final List<String> harmfulAdditives;
  final DateTime scanDate;
  final bool isFavorite;
  
  ScanHistoryModel({
    this.id,
    required this.barcode,
    required this.productName,
    this.brand,
    this.imageUrl,
    required this.riskLevel,
    required this.harmfulAdditives,
    required this.scanDate,
    this.isFavorite = false,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'product_name': productName,
      'brand': brand,
      'image_url': imageUrl,
      'risk_level': riskLevel,
      'harmful_additives': harmfulAdditives.join(','),
      'scan_date': scanDate.millisecondsSinceEpoch,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }
  
  factory ScanHistoryModel.fromMap(Map<String, dynamic> map) {
    return ScanHistoryModel(
      id: map['id'],
      barcode: map['barcode'],
      productName: map['product_name'],
      brand: map['brand'],
      imageUrl: map['image_url'],
      riskLevel: map['risk_level'],
      harmfulAdditives: map['harmful_additives'] != null
          ? (map['harmful_additives'] as String).split(',').where((e) => e.isNotEmpty).toList()
          : [],
      scanDate: DateTime.fromMillisecondsSinceEpoch(map['scan_date']),
      isFavorite: map['is_favorite'] == 1,
    );
  }
  
  ScanHistoryModel copyWith({
    int? id,
    String? barcode,
    String? productName,
    String? brand,
    String? imageUrl,
    String? riskLevel,
    List<String>? harmfulAdditives,
    DateTime? scanDate,
    bool? isFavorite,
  }) {
    return ScanHistoryModel(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      riskLevel: riskLevel ?? this.riskLevel,
      harmfulAdditives: harmfulAdditives ?? this.harmfulAdditives,
      scanDate: scanDate ?? this.scanDate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}