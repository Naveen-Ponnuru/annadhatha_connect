import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  final String id;
  final String retailerId;
  final String retailerName;
  final String retailerPhone;
  final String groupId;
  final String groupName;
  final List<String> listingIds;
  final List<OrderItem> items;
  final double totalQuantity;
  final String quantityUnit;
  final double totalAmount;
  final String currency;
  final String status; // pending, confirmed, in_transit, delivered, cancelled, refunded
  final String paymentStatus; // pending, held, released, refunded, failed
  final String? paymentId;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String? hubId;
  final String? hubName;
  final String? verificationId;
  final String? deliveryAddress;
  final String? deliveryCity;
  final String? deliveryState;
  final String? deliveryPincode;
  final String? deliveryInstructions;
  final DateTime? deliveryDate;
  final DateTime? deliveredAt;
  final String? deliveryPerson;
  final String? deliveryPersonPhone;
  final String? trackingNumber;
  final Map<String, dynamic>? qualityReport;
  final String? notes;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? additionalInfo;

  const OrderModel({
    required this.id,
    required this.retailerId,
    required this.retailerName,
    required this.retailerPhone,
    required this.groupId,
    required this.groupName,
    required this.listingIds,
    required this.items,
    required this.totalQuantity,
    required this.quantityUnit,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.paymentStatus,
    this.paymentId,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.hubId,
    this.hubName,
    this.verificationId,
    this.deliveryAddress,
    this.deliveryCity,
    this.deliveryState,
    this.deliveryPincode,
    this.deliveryInstructions,
    this.deliveryDate,
    this.deliveredAt,
    this.deliveryPerson,
    this.deliveryPersonPhone,
    this.trackingNumber,
    this.qualityReport,
    this.notes,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    this.additionalInfo,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel.fromJson({
      'id': doc.id,
      ...data,
      'items': (data['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      'deliveryDate': data['deliveryDate'] != null 
          ? (data['deliveryDate'] as Timestamp).toDate() 
          : null,
      'deliveredAt': data['deliveredAt'] != null 
          ? (data['deliveredAt'] as Timestamp).toDate() 
          : null,
      'createdAt': (data['createdAt'] as Timestamp).toDate(),
      'updatedAt': (data['updatedAt'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json['items'] = items.map((item) => item.toJson()).toList();
    if (deliveryDate != null) {
      json['deliveryDate'] = Timestamp.fromDate(deliveryDate!);
    }
    if (deliveredAt != null) {
      json['deliveredAt'] = Timestamp.fromDate(deliveredAt!);
    }
    json['createdAt'] = Timestamp.fromDate(createdAt);
    json['updatedAt'] = Timestamp.fromDate(updatedAt);
    json.remove('id');
    return json;
  }

  OrderModel copyWith({
    String? id,
    String? retailerId,
    String? retailerName,
    String? retailerPhone,
    String? groupId,
    String? groupName,
    List<String>? listingIds,
    List<OrderItem>? items,
    double? totalQuantity,
    String? quantityUnit,
    double? totalAmount,
    String? currency,
    String? status,
    String? paymentStatus,
    String? paymentId,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    String? hubId,
    String? hubName,
    String? verificationId,
    String? deliveryAddress,
    String? deliveryCity,
    String? deliveryState,
    String? deliveryPincode,
    String? deliveryInstructions,
    DateTime? deliveryDate,
    DateTime? deliveredAt,
    String? deliveryPerson,
    String? deliveryPersonPhone,
    String? trackingNumber,
    Map<String, dynamic>? qualityReport,
    String? notes,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalInfo,
  }) {
    return OrderModel(
      id: id ?? this.id,
      retailerId: retailerId ?? this.retailerId,
      retailerName: retailerName ?? this.retailerName,
      retailerPhone: retailerPhone ?? this.retailerPhone,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      listingIds: listingIds ?? this.listingIds,
      items: items ?? this.items,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentId: paymentId ?? this.paymentId,
      razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId ?? this.razorpayPaymentId,
      hubId: hubId ?? this.hubId,
      hubName: hubName ?? this.hubName,
      verificationId: verificationId ?? this.verificationId,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryCity: deliveryCity ?? this.deliveryCity,
      deliveryState: deliveryState ?? this.deliveryState,
      deliveryPincode: deliveryPincode ?? this.deliveryPincode,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      deliveryPerson: deliveryPerson ?? this.deliveryPerson,
      deliveryPersonPhone: deliveryPersonPhone ?? this.deliveryPersonPhone,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      qualityReport: qualityReport ?? this.qualityReport,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  bool get isPending => status == 'pending';
  
  bool get isConfirmed => status == 'confirmed';
  
  bool get isInTransit => status == 'in_transit';
  
  bool get isDelivered => status == 'delivered';
  
  bool get isCancelled => status == 'cancelled';
  
  bool get isRefunded => status == 'refunded';
  
  bool get isPaymentPending => paymentStatus == 'pending';
  
  bool get isPaymentHeld => paymentStatus == 'held';
  
  bool get isPaymentReleased => paymentStatus == 'released';
  
  bool get isPaymentRefunded => paymentStatus == 'refunded';
  
  bool get isPaymentFailed => paymentStatus == 'failed';
  
  String get deliveryLocationString {
    final parts = <String>[];
    if (deliveryAddress != null) parts.add(deliveryAddress!);
    if (deliveryCity != null) parts.add(deliveryCity!);
    if (deliveryState != null) parts.add(deliveryState!);
    if (deliveryPincode != null) parts.add(deliveryPincode!);
    return parts.join(', ');
  }
  
  String get statusDisplayString {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'refunded':
        return 'Refunded';
      default:
        return 'Unknown';
    }
  }
  
  String get paymentStatusDisplayString {
    switch (paymentStatus) {
      case 'pending':
        return 'Payment Pending';
      case 'held':
        return 'Payment Held';
      case 'released':
        return 'Payment Released';
      case 'refunded':
        return 'Payment Refunded';
      case 'failed':
        return 'Payment Failed';
      default:
        return 'Unknown';
    }
  }
  
  String get totalAmountDisplayString => '₹${totalAmount.toStringAsFixed(2)}';
  
  String get quantityDisplayString => '${totalQuantity.toStringAsFixed(2)} $quantityUnit';
}

@JsonSerializable()
class OrderItem {
  final String listingId;
  final String farmerId;
  final String farmerName;
  final String cropName;
  final double quantity;
  final String quantityUnit;
  final double pricePerUnit;
  final String priceUnit;
  final double totalPrice;
  final String? notes;

  const OrderItem({
    required this.listingId,
    required this.farmerId,
    required this.farmerName,
    required this.cropName,
    required this.quantity,
    required this.quantityUnit,
    required this.pricePerUnit,
    required this.priceUnit,
    required this.totalPrice,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  String get priceDisplayString => '₹${pricePerUnit.toStringAsFixed(2)}/$priceUnit';
  
  String get quantityDisplayString => '${quantity.toStringAsFixed(2)} $quantityUnit';
  
  String get totalPriceDisplayString => '₹${totalPrice.toStringAsFixed(2)}';
}
