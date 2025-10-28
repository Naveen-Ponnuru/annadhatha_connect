import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crop_listing_model.g.dart';

@JsonSerializable()
class CropListingModel {
  final String id;
  final String farmerId;
  final String farmerName;
  final String farmerPhone;
  final String cropName;
  final String cropCategory;
  final double quantity;
  final String quantityUnit;
  final double pricePerUnit;
  final String priceUnit;
  final double totalPrice;
  final DateTime harvestDate;
  final String? description;
  final List<String> imageUrls;
  final String? location;
  final String? city;
  final String? state;
  final String? pincode;
  final Map<String, dynamic>? qualityParameters;
  final String status; // active, sold, expired, cancelled
  final String? groupId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final String? verificationNotes;
  final Map<String, dynamic>? additionalInfo;

  const CropListingModel({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmerPhone,
    required this.cropName,
    required this.cropCategory,
    required this.quantity,
    required this.quantityUnit,
    required this.pricePerUnit,
    required this.priceUnit,
    required this.totalPrice,
    required this.harvestDate,
    this.description,
    required this.imageUrls,
    this.location,
    this.city,
    this.state,
    this.pincode,
    this.qualityParameters,
    required this.status,
    this.groupId,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
    this.verificationNotes,
    this.additionalInfo,
  });

  factory CropListingModel.fromJson(Map<String, dynamic> json) => _$CropListingModelFromJson(json);
  Map<String, dynamic> toJson() => _$CropListingModelToJson(this);

  factory CropListingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CropListingModel.fromJson({
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

  CropListingModel copyWith({
    String? id,
    String? farmerId,
    String? farmerName,
    String? farmerPhone,
    String? cropName,
    String? cropCategory,
    double? quantity,
    String? quantityUnit,
    double? pricePerUnit,
    String? priceUnit,
    double? totalPrice,
    DateTime? harvestDate,
    String? description,
    List<String>? imageUrls,
    String? location,
    String? city,
    String? state,
    String? pincode,
    Map<String, dynamic>? qualityParameters,
    String? status,
    String? groupId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    String? verificationNotes,
    Map<String, dynamic>? additionalInfo,
  }) {
    return CropListingModel(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      farmerPhone: farmerPhone ?? this.farmerPhone,
      cropName: cropName ?? this.cropName,
      cropCategory: cropCategory ?? this.cropCategory,
      quantity: quantity ?? this.quantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      priceUnit: priceUnit ?? this.priceUnit,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      totalPrice: totalPrice ?? this.totalPrice,
      harvestDate: harvestDate ?? this.harvestDate,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      qualityParameters: qualityParameters ?? this.qualityParameters,
      status: status ?? this.status,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      verificationNotes: verificationNotes ?? this.verificationNotes,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  bool get isActive => status == 'active';
  
  bool get isSold => status == 'sold';
  
  bool get isExpired => status == 'expired';
  
  bool get isCancelled => status == 'cancelled';
  
  String get locationString {
    final parts = <String>[];
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (pincode != null) parts.add(pincode!);
    return parts.join(', ');
  }
  
  String get priceDisplayString => '₹${pricePerUnit.toStringAsFixed(2)}/$priceUnit';
  
  String get quantityDisplayString => '${quantity.toStringAsFixed(2)} $quantityUnit';
  
  bool get isGrouped => groupId != null;
  
  String get statusDisplayString {
    switch (status) {
      case 'active':
        return 'Active';
      case 'sold':
        return 'Sold';
      case 'expired':
        return 'Expired';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}
