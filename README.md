# 🏙️ PGCity — Next-Gen Student & Professional Co-Living Mobile Platform

<p align="center">
  <img src="https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=1200&auto=format&fit=crop&q=80" alt="PGCity Mobile Banner" width="100%" style="border-radius: 16px; box-shadow: 0 8px 30px rgba(0,0,0,0.12);" />
</p>

<p align="center">
  <b>A state-of-the-art, map-first PG & student co-living discovery mobile application built with Flutter for Android & iOS.</b><br/>
  <i>Integrated with Groq LLaMA 3.3 70B AI Assistant, 360° Gyroscopic Tours, Roommate Finder, Weekly Tiffin Menus, Emergency Safety SOS, and Tenancy Lifecycle Management.</i>
</p>

<p align="center">
  <a href="#-architecture--tech-stack"><img src="https://img.shields.io/badge/Flutter-v3.41%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  <a href="#-architecture--tech-stack"><img src="https://img.shields.io/badge/Dart-v3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" /></a>
  <a href="#-groq-ai-assistant"><img src="https://img.shields.io/badge/AI_Engine-Groq_LLaMA_3.3_70B-6366F1?style=for-the-badge&logo=openai&logoColor=white" alt="Groq AI" /></a>
  <a href="#-testing--quality-assurance"><img src="https://img.shields.io/badge/Tests-25%20Passed-10B981?style=for-the-badge&logo=checkmarx&logoColor=white" alt="Tests" /></a>
  <a href="#-testing--quality-assurance"><img src="https://img.shields.io/badge/Analysis-0%20Issues-38BDF8?style=for-the-badge&logo=dart&logoColor=white" alt="Analysis" /></a>
  <a href="#-license"><img src="https://img.shields.io/badge/License-MIT-F59E0B?style=for-the-badge" alt="License" /></a>
</p>

---

## 📑 Table of Contents

- [✨ Core Highlights & Value Proposition](#-core-highlights--value-proposition)
- [🤖 Groq AI Assistant & Markdown Engine](#-groq-ai-assistant--markdown-engine)
- [🗺️ Map-First Discovery Engine](#️-map-first-discovery-engine)
- [🏠 Comprehensive 15-Section PG Mini-Website](#-comprehensive-15-section-pg-mini-website)
- [⚡ Power Ecosystem Features](#-power-ecosystem-features)
  - [1. 📊 Side-by-Side PG Comparison Matrix](#1--side-by-side-pg-comparison-matrix)
  - [2. 🤝 Roommate Matcher Hub](#2--roommate-matcher-hub)
  - [3. 🍲 Weekly Tiffin & Food Menu Planner](#3--weekly-tiffin--food-menu-planner)
  - [4. 🛡️ Women Safety & Emergency SOS Center](#4-️-women-safety--emergency-sos-center)
  - [5. 💬 Resident Community Q&A Forum](#5--resident-community-qa-forum)
  - [6. 🧮 Interactive True Rent Calculator](#6--interactive-true-rent-calculator)
  - [7. 👨‍👩‍👦 WhatsApp Parent Share Brochure](#7--whatsapp-parent-share-brochure)
  - [8. 💬 In-App Landlord Chat Assistant](#8--in-app-landlord-chat-assistant)
  - [9. 📄 Digital Tenancy Contract & HRA Invoices](#9--digital-tenancy-contract--hra-invoices)
- [🔐 Authentication & Apple Compliance](#-authentication--security)
- [🎨 Design System, Typography & Tri-Lingual i18n](#-appearance-customization--i18n)
- [📁 Secure Environment Variables (.env)](#-secure-environment-variables-env)
- [🏗️ Architecture & Directory Structure](#-architecture--tech-stack)
- [🧪 Testing & Quality Assurance](#-testing--quality-assurance)
- [📄 License](#-license)

---

## ✨ Core Highlights & Value Proposition

- **Zero Clutter, Maximum Clarity**: Seamless student & young professional co-living discovery designed specifically for Ahmedabad and Gandhinagar hubs (Navrangpura, Satellite, Bodakdev, SG Highway, Infocity).
- **Native 2D Vector Canvas Map**: High-performance custom map renderer drawing roads, water bodies, metro lines, and Sabarmati river with animated radar markers.
- **Physical Verification**: Every space is 100% verified with 360° gyroscopic virtual room tours and video walkthroughs.
- **Transparent Tenancy**: Instant breakdown of security deposits, lock-in terms, curfew hours, and electricity sub-meter tariffs.

---

## 🤖 Groq AI Assistant & Markdown Engine

Integrated with Groq Cloud's ultra-fast **LLaMA 3.3 70B Versatile** model (`EnvConfig.groqApiKey`), the PGCity AI Assistant offers personalized co-living guidance.

### Capabilities:
- **Custom Markdown & Rich Text Renderer**: Parses headings (`###`), bold text (`**bold**`), bullet points (`•`, `-`, `1.`), and inline tags (`` `tag` ``) into styled native widgets without raw syntax artifacts.
- **Contextual Local Knowledge**: Preloaded with live Ahmedabad PG inventory, college proximities (LDCE, CEPT, Nirma, IIM-A, DAIICT), and meal plans (Gujarati, Kathiyawadi, Pure Veg, Jain).
- **Interactive Property Recommendations**: In-chat property cards with thumbnail photos, rent tags, and one-tap "View Details →" navigation.
- **Zero-Latency Offline Fallback**: Heuristic response engine for seamless offline availability.

### Seamless Entry Points:
- 🔘 **Compact Circular FAB** on `HomeScreen` with glowing AI gradient and sparkle icon.
- 🏷️ **Quick Action Filter Chip** in the top navigation bar.
- ⚡ **"Ask AI about this PG"** in the property action bar.
- 👤 **Resident Tools Menu** on `ProfileScreen`.

---

## 🗺️ Map-First Discovery Engine

- **Signature 45° Price Pins**: Interactive custom markers displaying monthly rent badges that expand smoothly upon tap.
- **Dynamic Locality Filtering**: Real-time filtering across major college and corporate corridors.
- **Filter Tags**: Instant toggles for `All`, `Girls PG`, `Boys PG`, `Under ₹10k`, `Above ₹10k`, `AI Assistant`, `Roommates`, `Tiffin Menu`, and `Safety SOS`.
- **Sliding Preview Card**: Quick glance at rent, distance to landmarks, verified shield, compare toggle, and direct "View PG →" CTA.
- **Compare Dock Banner**: Bottom dock tracking selected properties for side-by-side comparison.

---

## 🏠 Comprehensive 15-Section PG Mini-Website

1. **Hero Header**: High-resolution cover carousel, gender badges, verified shield, and live like counter.
2. **Interactive Quick Power Tools Bar**: Instant buttons for **Ask AI**, **Tiffin Menu**, **Resident Q&A**, **Compare PG**, **Cost Calculator**, **Parent Share Brochure**, and **Chat Manager**.
3. **360° Virtual Tour Card**: Drag-to-rotate panoramic room inspection with room navigation (*Bedroom, Study, Dining*).
4. **Video Vlog Tour**: Embedded video player with chapter timestamps and timeline scrubber.
5. **Photo Lightbox Gallery**: Full-screen pinch-to-zoom image viewer with thumbnail filmstrip.
6. **Quick Stats Grid**: Notice period, lock-in duration, gate closing hours, and meal options.
7. **Sharing & Pricing Matrix**: 1, 2, 3, and 4 sharing breakdowns with security deposits.
8. **Curated Amenities Checklist**: High-speed WiFi, AC, Geyser, RO Water, Biometric Access, Housekeeping, Laundry, Power Backup, Gym, CCTV.
9. **Meal Schedule**: Breakfast, Lunch, High Tea, and Dinner menus with dietary indicators.
10. **House Rules & Policies**: Curfew, visitor entry policies, smoking/alcohol prohibitions.
11. **Locality & Landmarks**: Distance to nearby universities, metro stations, and hospitals with live Google Maps directions.
12. **Verified Owner / Manager Profile**: Caretaker credentials, badges, and response time metrics.
13. **Rewarded Ad Contact Unlock**: 4-second rewarded video ad simulation unlocking verified phone number with direct dial (`tel:`) and WhatsApp messaging.
14. **Student Reviews & Ratings**: Breakdown of cleanliness, food quality, safety, and resident feedback.
15. **Sticky Floating Action Bar**: Live Like button, Contact button, and primary **"Enroll Now"** CTA.

---

## ⚡ Power Ecosystem Features

### 1. 📊 Side-by-Side PG Comparison Matrix
- Compare up to **3 properties simultaneously** across pricing, security deposits, notice periods, room sharing, and amenities.
- Horizontally scrollable responsive matrix cards with full readability on all screen sizes.

### 2. 🤝 Roommate Matcher Hub
- Browse verified student and working professional flatmate profiles.
- Filter by **Target Locality**, **Dietary Preference** (*Pure Veg, Jain, Eggetarian, Non-Veg*), and **Sleep Schedule** (*Early Bird vs Night Owl*).
- "Post My Profile" bottom sheet with instant contact initiation.

### 3. 🍲 Weekly Tiffin & Food Menu Planner
- Complete 7-day meal planner (Monday to Sunday) covering Breakfast, Lunch, High Tea, and Dinner.
- Dietary badges for **Pure Veg**, **Jain Options**, **Swaminarayan**, and **Kathiyawadi specials**.
- **Daily Meal Attendance RSVP** (*"Attending Lunch" / "Skipping Dinner"*) helping kitchens reduce food waste.
- FSSAI Certified hygiene badge.

### 4. 🛡️ Women Safety & Emergency SOS Center
- 1-tap **SOS Alert Dispatch** generating emergency SMS/WhatsApp messages with live GPS coordinates.
- Direct dial hotlines: **Women Helpline (1091)**, **National Emergency (112)**, **Ambulance (108)**, **Tele-MANAS Counseling (14416)**.
- Local Ahmedabad police stations directory (Navrangpura, Vastrapur, Satellite, Infocity).

### 5. 💬 Resident Community Q&A Forum
- Transparent tenant discussion board with question submission, upvoting, and verified resident staff answers.

### 6. 🧮 Interactive True Rent Calculator
- Dynamic sliders for **AC Electricity Units** with per-unit tariff breakdown.
- Sharing toggles adjusting base rent dynamically with move-in cash breakdown.

### 7. 👨‍👩‍👦 WhatsApp Parent Share Brochure
- Visual summary card formatted for parents with property specifics, curfew hours, meals, and simulated 360 Tour QR code.

### 8. 💬 In-App Landlord Chat Assistant
- Direct chat thread with property managers featuring preset quick inquiry chips and automated auto-replies.

### 9. 📄 Digital Tenancy Contract & HRA Invoices
- View active 11-month tenancy contract terms, lock-in period, security deposit escrow status, and monthly HRA tax invoices.

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
  - Complete account deletion workflow with 2-step confirmation dialog and personal data erasure.
- **Biometric App Lock**:
  - FaceID and Fingerprint authentication persistence (`BiometricAuthService`).

---

## 🎨 Appearance Customization & i18n

- **Themes**: Crisp Light Mode (`#F6F1E6`), Sleek Dark Mode (`#0F172A`), and System Default.
- **Dynamic Typography**:
  - `Inter` (Clean Minimalist Sans)
  - `Plus Jakarta Sans` (Modern Geometric)
  - `Outfit` (Contemporary Friendly Sans)
  - `DM Sans` (Editorial High Legibility)
- **Tri-Lingual Localization**: English (`en`), Hindi (`hi`), Gujarati (`gu`).
- **In-App Rating**: 5-star interactive review modal with feature feedback tags.

---

## 📁 Secure Environment Variables (.env)

PGCity features an automated `EnvConfig` manager that loads environment credentials safely:

```env
# .env file
GROQ_API_KEY=your_groq_api_key_here
GROQ_MODEL=llama-3.3-70b-versatile
GROQ_BASE_URL=https://api.groq.com/openai/v1/chat/completions
```

- Included [`.env.example`](file:///g:/Projects/PG%20City/pgcity/.env.example) template for developer setup.
- `.env` is ignored in `.gitignore` to prevent secret leakage and loaded via `EnvConfig.initialize()` at startup.

---

## 🏗️ Architecture & Tech Stack

```
lib/
├── core/
│   ├── config/           # EnvConfig (.env parser & environment variable manager)
│   ├── constants/        # AppColors, AppTypography, AppDimensions
│   ├── localization/     # AppStrings (EN, HI, GU tri-lingual dictionary)
│   ├── services/         # GroqAiService, BiometricAuthService, PGShareService, CrashlyticsService
│   ├── theme/            # AppTheme (Light & Dark theme definitions)
│   └── utils/            # AppLogger, CurrencyFormatter
├── data/
│   ├── models/           # PGModel, UserModel, EnrollmentModel, RoommateModel,
│   │                     # ChatMessageModel, RentReceiptModel
│   └── repositories/     # PGRepository, UserRepository, EnrollmentRepository
├── presentation/
│   ├── controllers/      # AppState (Unified ChangeNotifier state manager)
│   ├── screens/
│   │   ├── admin/        # AdminDashboardScreen, AdminPGEditorScreen
│   │   ├── ai_assistant/ # PGAiAssistantScreen (Groq LLaMA 3.3 Chatbot with Markdown engine)
│   │   ├── auth/         # LoginScreen (Multi-method auth & Apple deletion)
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

## 🧪 Testing & Quality Assurance

```bash
# 1. Format entire codebase
dart format .

# 2. Run Flutter static analyzer (0 warnings, 0 errors)
flutter analyze

# 3. Run all 25 unit & state test suites
flutter test
```

### Test Suite Results:
- ✅ `Seed PGs are loaded correctly on initial launch`
- ✅ `Gender and Price filtering works properly`
- ✅ `Search filtering by name and locality`
- ✅ `Toggle Like persists liked state and adjusts like count`
- ✅ `Contact unlock persists and increments unlock count`
- ✅ `Enrollment submission and admin status transition`
- ✅ `OTP validation succeeds with demo and generated codes`
- ✅ `Authentication: Mobile + OTP, Password, Email, Google, Apple`
- ✅ `Apple Account Deletion compliance`
- ✅ `Theme Mode & Font Selection`
- ✅ `Multi-language localization (EN / HI / GU)`
- ✅ `In-App Rating & Feedback`
- ✅ `PG Comparison matrix limit enforcement (Max 3)`
- ✅ `Roommate Matcher profile addition & querying`
- ✅ `In-App Landlord Chat auto-response assistant`
- ✅ `Biometric quick unlock toggle & persistence`
- ✅ `PG Share Service: Formatted Parent WhatsApp message`
- ✅ `Groq AI Assistant: Message processing and PG matching`

---

## 📄 License
Distributed under the **MIT License**. Created with ❤️ for students and young professionals finding quality co-living spaces in Ahmedabad.
