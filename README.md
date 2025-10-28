# Annadhatha Connect

A comprehensive Flutter-based direct trade platform connecting farmers and retailers with transparent escrow-based payments, voice-based crop entry, and real-time mandi price integration.

## 🌟 Features

### For Farmers
- **OTP-based Authentication** with Firebase Auth
- **KYC Verification** with document upload (Aadhaar/PAN)
- **Voice-based Crop Entry** using Google Speech-to-Text
- **Manual Crop Entry** with detailed forms
- **Dashboard** showing active listings, joined groups, and wallet summary
- **Real-time Notifications** for group creation and price updates

### For Retailers
- **Browse Farmer Groups** with advanced filtering
- **Place Orders** with escrow-based payments
- **Order History** and tracking
- **Cart Management** for bulk orders
- **Real-time Price Updates** from mandi data

### For Hubs
- **Quality Verification** system
- **Weight Verification** tools
- **Order Management** dashboard
- **Payment Release** controls

### Core Features
- **Multi-language Support** (English, Hindi, Tamil)
- **Responsive Design** with Material 3
- **Real-time Data Sync** with Firestore
- **Push Notifications** via FCM
- **Offline Support** with local caching
- **Secure Payments** with Razorpay integration

## 🏗️ Architecture

### Frontend (Flutter)
- **MVVM Architecture** with Riverpod state management
- **Go Router** for navigation
- **Material 3** design system
- **Responsive UI** for mobile, tablet, and web
- **Internationalization** with ARB files

### Backend (Firebase)
- **Firebase Auth** for authentication
- **Cloud Firestore** for data storage
- **Firebase Storage** for file uploads
- **Cloud Functions** for business logic
- **Firebase Messaging** for notifications

### Integrations
- **Razorpay** for payment processing
- **Google Speech-to-Text** for voice input
- **eNAM API** for mandi prices (mock implementation)

## 📱 Screenshots

*Screenshots will be added after UI implementation*

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.2.0 or higher)
- Firebase CLI
- Node.js (18 or higher) for Cloud Functions
- Android Studio / Xcode for mobile development

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/annadhatha-connect.git
   cd annadhatha-connect
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Install Cloud Functions dependencies**
   ```bash
   cd functions
   npm install
   ```

4. **Configure Firebase**
   - Create a Firebase project
   - Enable Authentication, Firestore, Storage, and Functions
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories

5. **Update Firebase configuration**
   - Update `lib/firebase_options.dart` with your Firebase project details
   - Update `functions/src/index.ts` with your API keys

6. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project named "annadhatha-connect"

2. **Enable Services**
   - Authentication (Phone, Email)
   - Firestore Database
   - Firebase Storage
   - Cloud Functions
   - Firebase Messaging

3. **Configure Authentication**
   - Enable Phone authentication
   - Add your app's SHA-1 fingerprint (Android)

4. **Set up Firestore Rules**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

5. **Deploy Cloud Functions**
   ```bash
   cd functions
   npm run build
   firebase deploy --only functions
   ```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── models/             # Data models
│   ├── providers/          # Riverpod providers
│   ├── services/           # Business logic services
│   ├── theme/              # App theming
│   ├── router/             # Navigation routing
│   └── widgets/            # Reusable widgets
├── features/
│   ├── auth/               # Authentication screens
│   ├── farmer/             # Farmer-specific screens
│   ├── retailer/           # Retailer-specific screens
│   ├── hub/                # Hub-specific screens
│   └── shared/             # Shared screens
├── l10n/                   # Localization files
└── main.dart               # App entry point

functions/
├── src/
│   └── index.ts            # Cloud Functions
├── package.json
└── tsconfig.json

assets/
├── images/                 # Image assets
├── icons/                  # Icon assets
├── animations/             # Lottie animations
├── translations/           # Translation files
└── fonts/                  # Custom fonts
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```env
FIREBASE_PROJECT_ID=your-project-id
RAZORPAY_KEY_ID=your-razorpay-key
RAZORPAY_KEY_SECRET=your-razorpay-secret
GOOGLE_STT_API_KEY=your-google-stt-key
```

### Firebase Configuration
Update the following files with your Firebase project details:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Analysis
flutter analyze

# Format code
dart format .
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🚀 Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
firebase deploy --only hosting
```

### Cloud Functions
```bash
cd functions
npm run build
firebase deploy --only functions
```

## 📊 Monitoring

### Firebase Analytics
- User engagement tracking
- Feature usage analytics
- Performance monitoring

### Crashlytics
- Crash reporting
- Performance monitoring
- User feedback

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- Material Design team for the design system
- Open source contributors

## 📞 Support

For support, email support@annadhatha.com or join our Slack channel.

## 🔮 Roadmap

- [ ] Advanced analytics dashboard
- [ ] Machine learning for price prediction
- [ ] Blockchain integration for transparency
- [ ] IoT integration for crop monitoring
- [ ] Multi-currency support
- [ ] Advanced reporting features

---

Made with ❤️ by the Annadhatha Team