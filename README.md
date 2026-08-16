# 🏙️ PGCity — Next-Gen PG & Co-Living Discovery Mobile App

<p align="center">
  <img src="https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=1000&auto=format&fit=crop&q=80" alt="PGCity Mobile App Banner" width="100%" style="border-radius: 12px;" />
</p>

<p align="center">
  <b>A modern, immersive, map-first PG & student co-living discovery mobile application built with Flutter for Android & iOS.</b><br/>
  <i>Engineered strictly following the PGCity PRD, Mobile Screen Specifications, and Power Ecosystem Features.</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-v3.41%2B-blue?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-v3.0%2B-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS-brightgreen" alt="Platforms" />
  <img src="https://img.shields.io/badge/License-MIT-amber" alt="License" />
  <img src="https://img.shields.io/badge/Tests-24%20Passed-success" alt="Tests" />
  <img src="https://img.shields.io/badge/Analysis-0%20Issues-brightgreen" alt="Analysis" />
</p>

---

## 📑 Table of Contents

- [Key Features](#-key-features)
- [Power Ecosystem Features](#-power-ecosystem-features)
- [Authentication & Apple Compliance](#-authentication--security)
- [Appearance, Fonts & Localization](#-appearance-customization--i18n)
- [Diagnostics & Firebase Crashlytics](#-diagnostics--logging)
- [Screenshots & UI Highlights](#-ui-and-design-system)
- [Architecture & Tech Stack](#-architecture--tech-stack)
- [Project Directory Structure](#-project-directory-structure)
- [Running Tests & Quality Assurance](#-running-tests--quality-assurance)
- [Admin Management Portal](#-admin-management-portal)

---

## ✨ Key Features

### 1. 🗺️ Map-First Discovery (`HomeScreen`)
- **Custom Vector Canvas Map**: Native 2D canvas drawing streets, urban blocks, green spaces, Sabarmati river, and pulsing user radar marker.
- **Signature 45° Price Pins**: Interactive custom markers displaying monthly rent badges that expand on selection.
- **Search & Locality Filter**: Real-time filtering across major student and IT hubs (Navrangpura, Satellite, Bodakdev, SG Highway).
- **Filter Tags**: Instant toggles for `All`, `Girls PG`, `Boys PG`, `Under ₹10k`, `Above ₹10k`, and `Roommate Matcher`.
- **Compare Dock Banner**: Floating dock showing real-time property count ready for side-by-side matrix comparison.
- **Bottom Sliding Preview Card**: Quick glance at rent, distance to landmarks, verified badge, compare toggle, and direct "View PG →" navigation.

### 2. 🏠 Dedicated 14-Section PG Mini-Website (`PGWebScreen`)
1. **Hero Header**: High-resolution cover carousel, gender badges, verified shield, and live like counter.
2. **Interactive Quick Power Tools Bar**: Instant buttons for **Compare PG**, **Cost Calculator**, **Parent Share Brochure**, and **Chat Manager**.
3. **360° Virtual Tour Card**: Drag-to-rotate panoramic room inspection with room navigation (*Bedroom, Study, Dining*).
4. **Video Vlog Tour**: Embedded YouTube-style video player with timeline scrubber and chapter timestamps.
5. **Photo Lightbox Gallery**: Full-screen pinch-to-zoom image viewer with thumbnail filmstrip.
6. **Quick Stats Grid**: Notice period, lock-in duration, gate closing hours, and meal types (Pure Veg / Jain).
7. **Sharing & Pricing Matrix**: 1, 2, 3, and 4 sharing breakdowns with security deposits and room amenities.
8. **Curated Amenities**: High-speed WiFi, AC, Geyser, RO Water, Biometric Access, Housekeeping, Laundry, Power Backup, Gym, CCTV.
9. **Meal Schedule**: Breakfast, Lunch, High Tea, and Dinner menus with dietary indicators.
10. **House Rules & Policies**: Curfew, visitor entry policies, smoking/alcohol prohibitions, and security guidelines.
11. **Locality & Landmarks**: Distance to nearby universities, metro stations, IT corridors, and hospitals with live Google Maps directions.
12. **Verified Owner / Manager Profile**: Property manager credentials, badges, and response time metrics.
13. **Rewarded Ad Contact Unlock**: 4-second rewarded video ad simulation unlocking verified phone number with direct dial (`tel:`) and WhatsApp messaging.
14. **Student Reviews & Ratings**: Breakdown of cleanliness, food quality, safety, and resident feedback.
15. **Sticky Floating Action Bar**: Live Like button, Contact button, and primary **"Enroll Now"** CTA.

### 3. 📝 2-Step Enrollment Application Flow
- **Step 1 — Application Form**: Auto-populates personal details from saved profile (Name, Phone, Email, Gender, Age, Occupation) with move-in date picker and sharing type selection.
- **Step 2 — OTP Verification**: 6-digit OTP code verification with countdown timer and instant demo auto-fill (`482100`).
- **Confirmation Modal**: Generates unique application token (`ENR-...`) with status tracking summary.

---

## ⚡ Power Ecosystem Features

### 1. 📊 Side-by-Side PG Comparison Matrix (`PGCompareScreen`)
- Compare up to **3 properties simultaneously** across pricing, security deposit, notice periods, room sharing configurations, and amenities checklist (Wi-Fi, AC, Food, Power Backup, Gym, CCTV).
- Visual indicator badges, highlight tags, and direct one-tap navigation to full PG mini-websites.

### 2. 🤝 Roommate Matcher Hub (`RoommateFinderScreen`)
- Browse verified student and working professional flatmate profiles.
- Filter profiles by **Target Area**, **Dietary Preference** (*Pure Veg, Jain, Eggetarian, Non-Veg*), and **Sleep Schedule** (*Early Bird vs Night Owl*).
- Interactive "Post My Roommate Profile" bottom sheet with instant posting and phone/WhatsApp contact initiation.

### 3. 🧮 Interactive True Rent & Move-in Calculator (`RentCalculatorModal`)
- Dynamic slider adjustments for **AC Electricity Units** with per-unit tariff breakdown.
- **Room Sharing Toggle** (Single Private, Double Sharing, Triple Sharing) adjusting base rent dynamically.
- Optional **Laundry & Housekeeping Add-on** toggle.
- Full Move-In Cash summary showing first month rent, refundable security deposit, and upfront cash required.

### 4. 👨‍👩‍👦 Parent Share & WhatsApp Brochure (`PGBrochureModal` & `PGShareService`)
- Clean visual card designed for sharing property specifics with parents and guardians.
- Displays full cost breakdown, curfew timings, meals, nearby colleges, and simulated 360 Tour QR code.
- Pre-formatted WhatsApp share message including Google Maps pin, landlord phone, and deep link.

### 5. 💬 In-App Landlord Chat with Auto-Response Assistant (`PGLandlordChatScreen`)
- Direct chat thread with property managers and resident caretakers.
- Preset quick inquiry chips: *“Is 2-sharing vacant?”*, *“Can I visit today at 5 PM?”*, *“Is Jain food available?”*, *“What is the security deposit?”*.
- Automated intelligent manager response engine simulating realistic property manager replies.
- Direct phone call escalation button.

### 6. 📄 Digital Rental Agreement & Monthly HRA Invoices (`RentReceiptsScreen`)
- View active 11-month tenancy contract terms, lock-in period, and escrow deposit receipts.
- Downloadable signed Tenancy Agreement PDF simulation.
- Monthly rent invoice cards displaying base rent, electricity sub-charges, maintenance, UPI transaction references, and HRA tax receipt downloads.

### 7. 🔒 Biometric App Unlock (`BiometricAuthService`)
- FaceID and Fingerprint authentication toggle in Settings.
- Encrypted local key persistence ensuring sensitive lease and payment data is secured.

---

## 🔐 Authentication & Security

- **Multi-Method Login**:
  - Mobile Number + SMS OTP (`482100`)
  - Mobile Number + Password
  - Email Address + Password
- **Social Sign-In**:
  - Google Sign-In (`Sign in with Google`)
  - Apple Sign-In (`Sign in with Apple` for iOS & cross-platform)
- **Apple App Store Guideline 5.1.1(v) Compliance**:
  - Mandatory "Delete Account" button with 2-step confirmation dialog and complete data wipe.

---

## 🎨 Appearance Customization & i18n

- **Themes**: System Default, Crisp Light Mode (`#F6F1E6`), and Sleek Dark Mode (`#0F172A`).
- **Typography Engine**:
  - `Inter` (Clean Minimalist Sans)
  - `Plus Jakarta Sans` (Modern Tech Geometric)
  - `Outfit` (Contemporary Friendly Sans)
  - `DM Sans` (High Legibility Editorial)
- **Tri-Lingual Localization**:
  - English (`en`)
  - Hindi (`hi`)
  - Gujarati (`gu`)
- **In-App Rating System**: 5-star interactive review modal with feature tags (`📸 Real Photos`, `🔒 Safe`, `⚡ Fast Response`).
- **Version Numbering**: Dynamic version display (`v1.0.0 (Build 100)`) in Settings and Login screen.

---

## 🩺 Diagnostics & Logging

- **FoodEye-Grade In-App Logger (`AppLoggerScreen`)**:
  - Filterable by level (`DEBUG`, `INFO`, `WARNING`, `ERROR`).
  - Search query filter, live log counter, and formatted clipboard export.
- **Firebase Crashlytics Pipeline (`CrashlyticsService`)**:
  - Breadcrumb trails, user identifiers, custom key-value pairs, and simulated crash triggers for QA testing.

---

## 🏗️ Architecture & Tech Stack

```
lib/
├── core/
│   ├── constants/        # AppColors, AppTypography, AppDimensions
│   ├── localization/     # AppStrings (EN, HI, GU dictionaries)
│   ├── services/         # CrashlyticsService, BiometricAuthService, PGShareService
│   ├── theme/            # AppTheme light/dark configurations
│   └── utils/            # AppLogger, CurrencyFormatter
├── data/
│   ├── models/           # PGModel, UserModel, EnrollmentModel, RoommateModel,
│   │                     # ChatMessageModel, RentReceiptModel
│   └── repositories/     # PGRepository, UserRepository, EnrollmentRepository
├── presentation/
│   ├── controllers/      # AppState (Unified ChangeNotifier state management)
│   ├── screens/
│   │   ├── admin/        # AdminDashboardScreen, AdminPGEditorScreen, AppLoggerScreen
│   │   ├── auth/         # LoginScreen
│   │   ├── chat/         # PGLandlordChatScreen
│   │   ├── compare/      # PGCompareScreen
│   │   ├── enrollment/   # EnrollmentSheet
│   │   ├── home/         # HomeScreen
│   │   ├── pg_detail/    # PGWebScreen, VirtualTour360Screen, VideoTourScreen, etc.
│   │   ├── profile/      # ProfileScreen, RentReceiptsScreen, Settings Modals
│   │   ├── roommates/    # RoommateFinderScreen
│   │   └── saved/        # LikedPGsScreen
│   └── widgets/          # PGPreviewCard, RentCalculatorModal, PGBrochureModal, etc.
└── main.dart             # App Entry point & bootstrap
```

---

## 🧪 Running Tests & Quality Assurance

```bash
# 1. Run Flutter static analyzer (0 warnings, 0 errors)
flutter analyze

# 2. Run all 24 unit & widget test suites
flutter test
```

### Test Suite Highlights:
- ✅ Seed PGs loading & integrity check
- ✅ Gender, locality & price filter combinations
- ✅ Persistent bookmarking & like counter mutations
- ✅ Authentication flows (OTP, Password, Google, Apple)
- ✅ Apple Account Deletion compliance
- ✅ Enrollment token generation & cancellation
- ✅ Contact unlock reward deductions
- ✅ Multi-language string key completeness (EN/HI/GU)
- ✅ Theme Mode & Font Family switching
- ✅ In-app rating storage & feedback tags
- ✅ AppLogger filtering & Crashlytics breadcrumbs
- ✅ PG Comparison matrix limit enforcement (Max 3)
- ✅ Roommate Matcher profile addition & querying
- ✅ Landlord Chat engine & auto-replies
- ✅ Biometric unlock persistence
- ✅ Parent WhatsApp brochure formatting

---

## 📄 License
Licensed under the **MIT License**. Created with ❤️ for students and young professionals finding quality co-living spaces in Ahmedabad.
