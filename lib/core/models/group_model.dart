import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

@JsonSerializable()
class GroupModel {
  final String id;
  final String name;
  final String cropName;
  final String cropCategory;
  final String? description;
  final String? location;
  final String? city;
  final String? state;
  final String? pincode;
  final double totalQuantity;
  final String quantityUnit;
  final double minPrice;
  final double maxPrice;
  final double averagePrice;
  final String priceUnit;
  final List<String> farmerIds;
  final List<String> listingIds;
  final int farmerCount;
  final DateTime harvestDate;
  final String status; // active, closed, cancelled
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final Map<String, dynamic>? qualityStandards;
  final Map<String, dynamic>? additionalInfo;

  const GroupModel({
    required this.id,
    required this.name,
    required this.cropName,
    required this.cropCategory,
    this.description,
    this.location,
    this.city,
    this.state,
    this.pincode,
    required this.totalQuantity,
    required this.quantityUnit,
    required this.minPrice,
    required this.maxPrice,
    required this.averagePrice,
    required this.priceUnit,
    required this.farmerIds,
    required this.listingIds,
    required this.farmerCount,
    required this.harvestDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.qualityStandards,
    this.additionalInfo,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel.fromJson({
      'id': doc.id,
      ...data,
      'harvestDate': (data['harvestDate'] as Timestamp).toDate(),
      'createdAt': (data['createdAt'] as Timestamp).toDate(),
      'updatedAt': (data['updatedAt'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json['harvestDate'] = Timestamp.fromDate(harvestDate);
    json['createdAt'] = Timestamp.fromDate(createdAt);
    json['updatedAt'] = Timestamp.fromDate(updatedAt);
    json.remove('id');
    return json;
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? cropName,
    String? cropCategory,
    String? description,
    String? location,
    String? city,
    String? state,
    String? pincode,
    double? totalQuantity,
    String? quantityUnit,
    double? minPrice,
    double? maxPrice,
    double? averagePrice,
    String? priceUnit,
    List<String>? farmerIds,
    List<String>? listingIds,
    int? farmerCount,
    DateTime? harvestDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    Map<String, dynamic>? qualityStandards,
    Map<String, dynamic>? additionalInfo,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cropName: cropName ?? this.cropName,
      cropCategory: cropCategory ?? this.cropCategory,
      description: description ?? this.description,
      location: location ?? this.location,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      averagePrice: averagePrice ?? this.averagePrice,
      priceUnit: priceUnit ?? this.priceUnit,
      farmerIds: farmerIds ?? this.farmerIds,
      listingIds: listingIds ?? this.listingIds,
      farmerCount: farmerCount ?? this.farmerCount,
      harvestDate: harvestDate ?? this.harvestDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      qualityStandards: qualityStandards ?? this.qualityStandards,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  bool get isActive => status == 'active';
  
  bool get isClosed => status == 'closed';
  
  bool get isCancelled => status == 'cancelled';
  
  String get locationString {
    final parts = <String>[];
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (pincode != null) parts.add(pincode!);
    return parts.join(', ');
  }
  
  String get priceRangeString => '₹${minPrice.toStringAsFixed(2)} - ₹${maxPrice.toStringAsFixed(2)}/$priceUnit';
  
  String get quantityDisplayString => '${totalQuantity.toStringAsFixed(2)} $quantityUnit';
  
  String get statusDisplayString {
    switch (status) {
      case 'active':
        return 'Active';
      case 'closed':
        return 'Closed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
  
  double get priceSpread => maxPrice - minPrice;
  
  bool get hasPriceVariation => priceSpread > 0;
}
