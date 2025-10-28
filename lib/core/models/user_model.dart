import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String phoneNumber;
  final String? email;
  final String role; // farmer, retailer, hub, admin
  final String? firstName;
  final String? lastName;
  final String? profileImageUrl;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? aadhaarNumber;
  final String? panNumber;
  final String? aadhaarImageUrl;
  final String? panImageUrl;
  final String kycStatus; // pending, approved, rejected
  final String? kycRejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final Map<String, dynamic>? preferences;
  final String? fcmToken;
  final String? language;
  final String? timezone;
  final double? rating;
  final int? totalOrders;
  final int? totalTrades;
  final double? totalRevenue;
  final bool isVerified;
  final String? verificationNotes;
  final Map<String, dynamic>? additionalInfo;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.profileImageUrl,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.aadhaarNumber,
    this.panNumber,
    this.aadhaarImageUrl,
    this.panImageUrl,
    required this.kycStatus,
    this.kycRejectionReason,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.preferences,
    this.fcmToken,
    this.language,
    this.timezone,
    this.rating,
    this.totalOrders,
    this.totalTrades,
    this.totalRevenue,
    required this.isVerified,
    this.verificationNotes,
    this.additionalInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({
      'id': doc.id,
      ...data,
      'createdAt': (data['createdAt'] as Timestamp).toDate(),
      'updatedAt': (data['updatedAt'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json['createdAt'] = Timestamp.fromDate(createdAt);
    json['updatedAt'] = Timestamp.fromDate(updatedAt);
    json.remove('id');
    return json;
  }

  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? email,
    String? role,
    String? firstName,
    String? lastName,
    String? profileImageUrl,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? aadhaarNumber,
    String? panNumber,
    String? aadhaarImageUrl,
    String? panImageUrl,
    String? kycStatus,
    String? kycRejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? preferences,
    String? fcmToken,
    String? language,
    String? timezone,
    double? rating,
    int? totalOrders,
    int? totalTrades,
    double? totalRevenue,
    bool? isVerified,
    String? verificationNotes,
    Map<String, dynamic>? additionalInfo,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      panNumber: panNumber ?? this.panNumber,
      aadhaarImageUrl: aadhaarImageUrl ?? this.aadhaarImageUrl,
      panImageUrl: panImageUrl ?? this.panImageUrl,
      kycStatus: kycStatus ?? this.kycStatus,
      kycRejectionReason: kycRejectionReason ?? this.kycRejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
      fcmToken: fcmToken ?? this.fcmToken,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
      totalTrades: totalTrades ?? this.totalTrades,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      isVerified: isVerified ?? this.isVerified,
      verificationNotes: verificationNotes ?? this.verificationNotes,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
  
  String get displayName => fullName.isNotEmpty ? fullName : phoneNumber;
  
  bool get isKycApproved => kycStatus == 'approved';
  
  bool get isKycPending => kycStatus == 'pending';
  
  bool get isKycRejected => kycStatus == 'rejected';
  
  bool get isFarmer => role == 'farmer';
  
  bool get isRetailer => role == 'retailer';
  
  bool get isHub => role == 'hub';
  
  bool get isAdmin => role == 'admin';
  
  String get locationString {
    final parts = <String>[];
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (pincode != null) parts.add(pincode!);
    return parts.join(', ');
  }
}
