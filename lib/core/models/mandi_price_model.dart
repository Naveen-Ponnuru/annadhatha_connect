import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mandi_price_model.g.dart';

@JsonSerializable()
class MandiPriceModel {
  final String id;
  final String cropName;
  final String cropCategory;
  final String mandiName;
  final String state;
  final String district;
  final double price;
  final String priceUnit;
  final String? variety;
  final String? grade;
  final double? minPrice;
  final double? maxPrice;
  final double? modalPrice;
  final String? priceTrend; // up, down, stable
  final double? priceChange;
  final double? priceChangePercent;
  final DateTime priceDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? additionalInfo;

  const MandiPriceModel({
    required this.id,
    required this.cropName,
    required this.cropCategory,
    required this.mandiName,
    required this.state,
    required this.district,
    required this.price,
    required this.priceUnit,
    this.variety,
    this.grade,
    this.minPrice,
    this.maxPrice,
    this.modalPrice,
    this.priceTrend,
    this.priceChange,
    this.priceChangePercent,
    required this.priceDate,
    required this.createdAt,
    required this.updatedAt,
    this.additionalInfo,
  });

  factory MandiPriceModel.fromJson(Map<String, dynamic> json) => _$MandiPriceModelFromJson(json);
  Map<String, dynamic> toJson() => _$MandiPriceModelToJson(this);

  factory MandiPriceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MandiPriceModel.fromJson({
      'id': doc.id,
      ...data,
      'priceDate': (data['priceDate'] as Timestamp).toDate(),
      'createdAt': (data['createdAt'] as Timestamp).toDate(),
      'updatedAt': (data['updatedAt'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json['priceDate'] = Timestamp.fromDate(priceDate);
    json['createdAt'] = Timestamp.fromDate(createdAt);
    json['updatedAt'] = Timestamp.fromDate(updatedAt);
    json.remove('id');
    return json;
  }

  MandiPriceModel copyWith({
    String? id,
    String? cropName,
    String? cropCategory,
    String? mandiName,
    String? state,
    String? district,
    double? price,
    String? priceUnit,
    String? variety,
    String? grade,
    double? minPrice,
    double? maxPrice,
    double? modalPrice,
    String? priceTrend,
    double? priceChange,
    double? priceChangePercent,
    DateTime? priceDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalInfo,
  }) {
    return MandiPriceModel(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      cropCategory: cropCategory ?? this.cropCategory,
      mandiName: mandiName ?? this.mandiName,
      state: state ?? this.state,
      district: district ?? this.district,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      variety: variety ?? this.variety,
      grade: grade ?? this.grade,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      modalPrice: modalPrice ?? this.modalPrice,
      priceTrend: priceTrend ?? this.priceTrend,
      priceChange: priceChange ?? this.priceChange,
      priceChangePercent: priceChangePercent ?? this.priceChangePercent,
      priceDate: priceDate ?? this.priceDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  bool get isPriceUp => priceTrend == 'up';
  
  bool get isPriceDown => priceTrend == 'down';
  
  bool get isPriceStable => priceTrend == 'stable';
  
  String get priceDisplayString => '₹${price.toStringAsFixed(2)}/$priceUnit';
  
  String get priceChangeDisplayString {
    if (priceChange == null || priceChangePercent == null) {
      return 'No change';
    }
    
    final change = priceChange!;
    final percent = priceChangePercent!;
    final sign = change > 0 ? '+' : '';
    
    return '$sign₹${change.toStringAsFixed(2)} ($sign${percent.toStringAsFixed(1)}%)';
  }
  
  String get locationString => '$mandiName, $district, $state';
  
  String get priceTrendIcon {
    switch (priceTrend) {
      case 'up':
        return '↗';
      case 'down':
        return '↘';
      case 'stable':
        return '→';
      default:
        return '?';
    }
  }
  
  String get priceTrendColor {
    switch (priceTrend) {
      case 'up':
        return 'green';
      case 'down':
        return 'red';
      case 'stable':
        return 'blue';
      default:
        return 'gray';
    }
  }
}
