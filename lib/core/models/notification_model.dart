import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type; // order_placed, order_confirmed, order_delivered, payment_released, group_created, price_updated, kyc_approved, kyc_rejected
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final String? actionUrl;
  final String? actionText;
  final Map<String, dynamic>? additionalInfo;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.imageUrl,
    this.data,
    required this.isRead,
    required this.createdAt,
    this.readAt,
    this.actionUrl,
    this.actionText,
    this.additionalInfo,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel.fromJson({
      'id': doc.id,
      ...data,
      'createdAt': (data['createdAt'] as Timestamp).toDate(),
      'readAt': data['readAt'] != null 
          ? (data['readAt'] as Timestamp).toDate() 
          : null,
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json['createdAt'] = Timestamp.fromDate(createdAt);
    if (readAt != null) {
      json['readAt'] = Timestamp.fromDate(readAt!);
    }
    json.remove('id');
    return json;
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? type,
    String? imageUrl,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
    DateTime? readAt,
    String? actionUrl,
    String? actionText,
    Map<String, dynamic>? additionalInfo,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      actionUrl: actionUrl ?? this.actionUrl,
      actionText: actionText ?? this.actionText,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  bool get isOrderNotification => type.startsWith('order_');
  
  bool get isPaymentNotification => type.startsWith('payment_');
  
  bool get isGroupNotification => type.startsWith('group_');
  
  bool get isKycNotification => type.startsWith('kyc_');
  
  bool get isPriceNotification => type.startsWith('price_');
  
  String get typeDisplayString {
    switch (type) {
      case 'order_placed':
        return 'Order Placed';
      case 'order_confirmed':
        return 'Order Confirmed';
      case 'order_delivered':
        return 'Order Delivered';
      case 'payment_released':
        return 'Payment Released';
      case 'group_created':
        return 'Group Created';
      case 'price_updated':
        return 'Price Updated';
      case 'kyc_approved':
        return 'KYC Approved';
      case 'kyc_rejected':
        return 'KYC Rejected';
      default:
        return 'Notification';
    }
  }
  
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
