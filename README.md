# 🏙️ PGCity — Next-Gen PG & Co-Living Discovery Mobile App

<p align="center">
  <img src="https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=1000&auto=format&fit=crop&q=80" alt="PGCity Mobile App Banner" width="100%" style="border-radius: 12px;" />
</p>

<p align="center">
  <b>A modern, immersive, map-first PG & student co-living discovery mobile application built with Flutter for Android & iOS.</b><br/>
  <i>Integrated with Groq AI LLaMA 3.3 Assistant, 360° Virtual Tours, Roommate Matcher, Weekly Tiffin Menus, Emergency Safety SOS, and Tenancy Management.</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-v3.41%2B-blue?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-v3.0%2B-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/AI_Engine-Groq_LLaMA_3.3_70B-purple" alt="Groq AI" />
  <img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS-brightgreen" alt="Platforms" />
  <img src="https://img.shields.io/badge/License-MIT-amber" alt="License" />
  <img src="https://img.shields.io/badge/Tests-25%20Passed-success" alt="Tests" />
  <img src="https://img.shields.io/badge/Analysis-0%20Issues-brightgreen" alt="Analysis" />
</p>

---

## 📑 Table of Contents

- [Key Features](#-key-features)
- [🤖 Groq AI Assistant](#-groq-ai-assistant)
- [⚡ Power Ecosystem Features](#-power-ecosystem-features)
- [🔐 Authentication & Security](#-authentication--security)
- [🎨 Appearance, Fonts & Localization](#-appearance-customization--i18n)
- [📁 Environment Variables (.env)](#-environment-variables-env)
- [🏗️ Architecture & Tech Stack](#-architecture--tech-stack)
- [🧪 Running Tests & Quality Assurance](#-running-tests--quality-assurance)
- [Admin Management Portal](#-admin-management-portal)

---

## 🤖 Groq AI Assistant

Powered by Groq's ultra-fast **LLaMA 3.3 70B Versatile** engine (`EnvConfig.groqApiKey`), the built-in AI Assistant is accessible from anywhere in the app:
- **Interactive Chat Interface (`PGAiAssistantScreen`)**:
  - Context-aware recommendations matching user's budget, preferred locality in Ahmedabad, room sharing, and diet.
  - Preset quick query pills (*"Girls PG in Navrangpura under 8k"*, *"Best PGs with pure veg & Jain food"*, *"Explain notice period & deposit rules"*).
  - Tappable property cards inside chat bubbles linking directly to full PG mini-websites.
  - Offline fallback knowledge base for zero-network resilience.
- **Entry Points**:
  - Floating Action Button on `HomeScreen` with gradient AI glow.
  - Top filter bar shortcut chip.
  - "Ask AI about this PG" button in `PGWebScreen`.
  - Resident Tools hub in `ProfileScreen`.

---

## ✨ Key Features

### 1. 🗺️ Map-First Discovery (`HomeScreen`)
- **Custom Vector Canvas Map**: Native 2D canvas drawing streets, urban blocks, green spaces, Sabarmati river, and pulsing user radar marker.
- **Signature 45° Price Pins**: Interactive custom markers displaying monthly rent badges that expand on selection.
- **Search & Locality Filter**: Real-time filtering across major student and IT hubs (Navrangpura, Satellite, Bodakdev, SG Highway).
- **Filter Tags**: Instant toggles for `All`, `Girls PG`, `Boys PG`, `Under ₹10k`, `Above ₹10k`, `AI Assistant`, `Roommates`, `Tiffin Menu`, and `Safety SOS`.
- **Compare Dock Banner**: Floating dock showing real-time property count ready for side-by-side matrix comparison.
- **Bottom Sliding Preview Card**: Quick glance at rent, distance to landmarks, verified badge, compare toggle, and direct "View PG →" navigation.

### 2. 🏠 Dedicated 14-Section PG Mini-Website (`PGWebScreen`)
1. **Hero Header**: High-resolution cover carousel, gender badges, verified shield, and live like counter.
2. **Interactive Quick Power Tools Bar**: Instant buttons for **Ask AI**, **Tiffin Menu**, **Resident Q&A**, **Compare PG**, **Cost Calculator**, **Parent Share Brochure**, and **Chat Manager**.
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

---

## ⚡ Power Ecosystem Features

### 1. 📊 Side-by-Side PG Comparison Matrix (`PGCompareScreen`)
- Compare up to **3 properties simultaneously** across pricing, security deposit, notice periods, room sharing configurations, and amenities checklist (Wi-Fi, AC, Food, Power Backup, Gym, CCTV).

### 2. 🤝 Roommate Matcher Hub (`RoommateFinderScreen`)
- Browse verified student and working professional flatmate profiles.
- Filter profiles by **Target Area**, **Dietary Preference** (*Pure Veg, Jain, Eggetarian, Non-Veg*), and **Sleep Schedule** (*Early Bird vs Night Owl*).
- "Post My Profile" bottom sheet with phone/WhatsApp contact initiation.

### 3. 🍲 Live Weekly Tiffin & Food Menu Planner (`TiffinMenuScreen`)
- Day-by-day food menu (Mon–Sun) covering Breakfast, Lunch, High Tea, and Dinner.
- Dietary tags for Pure Veg, Jain, Swaminarayan, and Kathiyawadi specials.
- Daily Meal Attendance RSVP (*"Attending Lunch" / "Skipping Dinner"*).

### 4. 🛡️ Women Safety & Emergency SOS Center (`SafetyCenterModal`)
- 1-tap Emergency SOS dispatching SMS/WhatsApp alerts with live GPS pin to parents/guardians.
- Direct dial hotlines: Women Helpline (`1091`), Police Emergency (`112`), Ambulance (`108`), Tele-MANAS Counseling (`14416`).
- Directory of local Ahmedabad police stations (Navrangpura, Vastrapur, Satellite, Infocity).

### 5. 💬 Resident Community Q&A Forum (`CommunityQAModal`)
- Forum for prospective tenants to ask questions and receive verified answers from current residents and wardens.

### 6. 🧮 Interactive True Rent & Move-in Calculator (`RentCalculatorModal`)
- Dynamic slider adjustments for **AC Electricity Units** with per-unit tariff breakdown.
- Sharing toggle adjusting base rent dynamically with move-in cash breakdown.

### 7. 👨‍👩‍👦 Parent Share & WhatsApp Brochure (`PGBrochureModal` & `PGShareService`)
- Formatted visual summary with simulated 360 Tour QR code and 1-tap WhatsApp sharing.

### 8. 📄 Digital Rental Agreement & Monthly HRA Invoices (`RentReceiptsScreen`)
- View active 11-month tenancy contract terms, lock-in period, and escrow deposit receipts with HRA tax receipt downloads.

### 9. 🔒 Biometric App Unlock (`BiometricAuthService`)
- FaceID and Fingerprint authentication toggle in Settings.

---

## 📁 Environment Variables (.env)

PGCity uses an automated `EnvConfig` manager to securely load environment variables:

```env
# .env file
GROQ_API_KEY=your_groq_api_key_here
GROQ_MODEL=llama-3.3-70b-versatile
GROQ_BASE_URL=https://api.groq.com/openai/v1/chat/completions
```

- Included `.env.example` template for development setup.
- `.env` is declared in `pubspec.yaml` assets and initialized at app bootstrap (`await EnvConfig.initialize()`).

---

## 🔐 Authentication & Security

- **Multi-Method Login**:
  - Mobile Number + SMS OTP (`482100`)
  - Mobile Number + Password
  - Email Address + Password
- **Social Sign-In**:
  - Google Sign-In (`Sign in with Google`)
  - Apple Sign-In (`Sign in with Apple`)
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
- **Tri-Lingual Localization**: English (`en`), Hindi (`hi`), Gujarati (`gu`).
- **In-App Rating System**: 5-star interactive review modal with feature feedback tags.

---

## 🏗️ Architecture & Tech Stack

```
lib/
├── core/
│   ├── config/           # EnvConfig (.env loader & environment variable manager)
│   ├── constants/        # AppColors, AppTypography, AppDimensions
│   ├── localization/     # AppStrings (EN, HI, GU dictionaries)
│   ├── services/         # GroqAiService, BiometricAuthService, PGShareService, CrashlyticsService
│   ├── theme/            # AppTheme light/dark configurations
│   └── utils/            # AppLogger, CurrencyFormatter
├── data/
│   ├── models/           # PGModel, UserModel, EnrollmentModel, RoommateModel,
│   │                     # ChatMessageModel, RentReceiptModel
│   └── repositories/     # PGRepository, UserRepository, EnrollmentRepository
├── presentation/
│   ├── controllers/      # AppState (Unified ChangeNotifier state management)
│   ├── screens/
│   │   ├── admin/        # AdminDashboardScreen, AdminPGEditorScreen
│   │   ├── ai_assistant/ # PGAiAssistantScreen (Groq LLaMA 3.3 Chatbot)
│   │   ├── auth/         # LoginScreen
│   │   ├── chat/         # PGLandlordChatScreen
│   │   ├── community/    # CommunityQAModal (Resident Discussion Forum)
│   │   ├── compare/      # PGCompareScreen (Side-by-Side Matrix)
│   │   ├── enrollment/   # EnrollmentSheet
│   │   ├── food/         # TiffinMenuScreen (7-day Food Planner & RSVP)
│   │   ├── home/         # HomeScreen
│   │   ├── pg_detail/    # PGWebScreen, VirtualTour360Screen, VideoTourScreen, etc.
│   │   ├── profile/      # ProfileScreen, RentReceiptsScreen, Settings Modals
│   │   ├── roommates/    # RoommateFinderScreen
│   │   ├── safety/       # SafetyCenterModal (Emergency SOS & 1091 Helpline)
│   │   └── saved/        # LikedPGsScreen
│   └── widgets/          # PGPreviewCard, RentCalculatorModal, PGBrochureModal, etc.
└── main.dart             # App Entry point & bootstrap
```

---

## 🧪 Running Tests & Quality Assurance

```bash
# 1. Format entire codebase
dart format .

# 2. Run Flutter static analyzer (0 warnings, 0 errors)
flutter analyze

# 3. Run all 25 unit & widget test suites
flutter test
```

### Test Suite Highlights:
- ✅ Seed PGs loading & integrity check
- ✅ Gender, locality & price filter combinations
- ✅ Persistent bookmarking & like counter mutations
- ✅ Authentication flows (OTP, Password, Google, Apple)
- ✅ Apple Account Deletion compliance
- ✅ Multi-language string key completeness (EN/HI/GU)
- ✅ Theme Mode & Font Family switching
- ✅ In-app rating storage & feedback tags
- ✅ PG Comparison matrix limit enforcement (Max 3)
- ✅ Roommate Matcher profile addition & querying
- ✅ Landlord Chat engine & auto-replies
- ✅ Biometric unlock persistence
- ✅ Parent WhatsApp brochure formatting
- ✅ Groq AI Assistant message processing & local matching

---

## 📄 License
Licensed under the **MIT License**. Created with ❤️ for students and young professionals finding quality co-living spaces in Ahmedabad.
