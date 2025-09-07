# FAAP Scan - Food Additive & Preservative Scanner

A comprehensive Flutter application that helps users make healthier food choices by scanning product barcodes and analyzing food additives and preservatives.

## Features

### Core Functionality
- **Barcode Scanning**: Instant product scanning using device camera
- **Additive Analysis**: Detailed information about food additives and preservatives
- **Risk Assessment**: Color-coded risk levels (High, Medium, Low) for products
- **Health Tracking**: Monitor your additive consumption over time
- **Search & Discovery**: Search products, additives, and brands
- **Personalization**: Set dietary preferences, allergies, and health goals

### Advanced Features
- **Health Dashboard**: Visualize consumption patterns with charts and insights
- **Avoid List**: Create a personalized list of additives to avoid
- **Alternative Suggestions**: Find healthier product alternatives (Premium)
- **Family Profiles**: Manage health preferences for multiple users (Premium)
- **Export Reports**: Download health reports for healthcare providers (Premium)

## Architecture

The app follows a clean architecture pattern with:
- **Feature-based folder structure**: Each feature is self-contained
- **Provider state management**: Efficient state handling across the app
- **Repository pattern**: Clean separation of data sources
- **Reusable components**: Consistent UI through shared widgets

## Technology Stack

- **Flutter**: Cross-platform mobile development
- **Provider**: State management
- **Go Router**: Navigation
- **Mobile Scanner**: Barcode scanning
- **FL Chart**: Data visualization
- **SQLite**: Local data storage
- **Dio**: Network requests

## Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── theme/              # Design system (colors, typography, spacing)
│   ├── router/             # Navigation configuration
│   └── services/           # App-wide services (DB, API, Analytics)
├── features/               # Feature modules
│   ├── onboarding/         # User onboarding flow
│   ├── home/               # Home dashboard
│   ├── scanning/           # Barcode scanning functionality
│   ├── search/             # Search and discovery
│   ├── health/             # Health tracking dashboard
│   └── profile/            # User profile and settings
└── shared/                 # Shared components
    └── widgets/            # Reusable UI components
```

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio or VS Code with Flutter extensions
- iOS/Android device or emulator

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/faap-scan.git
cd faap-scan
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Configuration

1. **Firebase Setup** (for analytics):
   - Add `google-services.json` (Android) to `android/app/`
   - Add `GoogleService-Info.plist` (iOS) to `ios/Runner/`

2. **API Configuration**:
   - Update the base URL in `lib/core/services/api_service.dart`

## Design System

The app uses a comprehensive design system including:

- **Color Palette**: Primary (Green), Secondary (Blue), Warning (Yellow), Error (Red)
- **Typography**: Inter font family with predefined text styles
- **Spacing**: 8-point grid system
- **Components**: Consistent buttons, cards, inputs, and navigation

## Key Screens

1. **Onboarding Flow**:
   - Splash screen with brand identity
   - Value proposition slides
   - Permission requests
   - Health profile setup

2. **Home Dashboard**:
   - Quick scan access
   - Health score widget
   - Recent scans carousel
   - Quick actions grid

3. **Scanning Experience**:
   - Real-time camera view
   - Barcode detection
   - Processing animation
   - Detailed results display

4. **Health Dashboard**:
   - Health score visualization
   - Weekly activity charts
   - Additive consumption breakdown
   - Personalized insights

5. **Search & Discovery**:
   - Multi-category search
   - Recent searches
   - Popular additives
   - Comprehensive results

## Performance Optimizations

- Lazy loading for images and heavy components
- Code splitting for feature modules
- Efficient database queries with indexing
- Animation performance monitoring
- Battery-conscious scanning

## Accessibility

- Screen reader compatibility
- High contrast mode support
- Text size scaling up to 200%
- Large touch targets (minimum 44px)
- Color blindness friendly design

## Testing

Run tests with:
```bash
flutter test
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the excellent framework
- Mobile Scanner package contributors
- FL Chart for beautiful visualizations
- The open-source community for various packages used