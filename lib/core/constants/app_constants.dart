class AppConstants {
  // App Info
  static const String appName = 'Annadhatha Connect';
  static const String appVersion = '1.0.0';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String listingsCollection = 'listings';
  static const String groupsCollection = 'groups';
  static const String ordersCollection = 'orders';
  static const String notificationsCollection = 'notifications';
  static const String mandiPricesCollection = 'mandiPrices';
  static const String transactionsCollection = 'transactions';
  static const String hubsCollection = 'hubs';
  static const String verificationsCollection = 'verifications';
  
  // User Roles
  static const String farmerRole = 'farmer';
  static const String retailerRole = 'retailer';
  static const String hubRole = 'hub';
  static const String adminRole = 'admin';
  
  // Order Status
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderInTransit = 'in_transit';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';
  static const String orderRefunded = 'refunded';
  
  // Payment Status
  static const String paymentPending = 'pending';
  static const String paymentHeld = 'held';
  static const String paymentReleased = 'released';
  static const String paymentRefunded = 'refunded';
  static const String paymentFailed = 'failed';
  
  // KYC Status
  static const String kycPending = 'pending';
  static const String kycApproved = 'approved';
  static const String kycRejected = 'rejected';
  
  // Verification Status
  static const String verificationPending = 'pending';
  static const String verificationApproved = 'approved';
  static const String verificationRejected = 'rejected';
  
  // Notification Types
  static const String notificationOrderPlaced = 'order_placed';
  static const String notificationOrderConfirmed = 'order_confirmed';
  static const String notificationOrderDelivered = 'order_delivered';
  static const String notificationPaymentReleased = 'payment_released';
  static const String notificationGroupCreated = 'group_created';
  static const String notificationPriceUpdated = 'price_updated';
  static const String notificationKycApproved = 'kyc_approved';
  static const String notificationKycRejected = 'kyc_rejected';
  
  // Crop Categories
  static const List<String> cropCategories = [
    'Cereals',
    'Pulses',
    'Oilseeds',
    'Vegetables',
    'Fruits',
    'Spices',
    'Medicinal Plants',
    'Flowers',
    'Other'
  ];
  
  // Units
  static const List<String> quantityUnits = [
    'kg',
    'quintal',
    'ton',
    'bag',
    'piece',
    'dozen',
    'bunch'
  ];
  
  // Price Units
  static const List<String> priceUnits = [
    'per_kg',
    'per_quintal',
    'per_ton',
    'per_bag',
    'per_piece',
    'per_dozen',
    'per_bunch'
  ];
  
  // Indian States
  static const List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry'
  ];
  
  // API Endpoints
  static const String baseUrl = 'https://api.annadhatha.com';
  static const String mandiPriceUrl = '$baseUrl/mandi-prices';
  static const String razorpayUrl = '$baseUrl/razorpay';
  
  // Razorpay Configuration
  static const String razorpayKeyId = 'rzp_test_1234567890'; // Replace with actual key
  static const String razorpayKeySecret = 'your_secret_key'; // Replace with actual secret
  
  // Google STT Configuration
  static const String googleSttLanguage = 'hi-IN'; // Hindi India
  static const List<String> supportedLanguages = ['en-IN', 'hi-IN', 'ta-IN'];
  
  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentTypes = ['pdf', 'jpg', 'jpeg', 'png'];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 15);
  static const Duration priceCacheDuration = Duration(minutes: 5);
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;
  
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
}
