# 🏙️ PGCity — Next-Gen PG & Co-Living Discovery Mobile App

<p align="center">
  <img src="https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=1000&auto=format&fit=crop&q=80" alt="PGCity Mobile App Banner" width="100%" style="border-radius: 12px;" />
</p>

<p align="center">
  <b>A modern, immersive, map-first PG & student co-living discovery mobile application built with Flutter for Android & iOS.</b><br/>
  <i>Engineered strictly following the PGCity PRD and UI Mobile Screen Specifications.</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-v3.41%2B-blue?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-v3.0%2B-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS-brightgreen" alt="Platforms" />
  <img src="https://img.shields.io/badge/License-MIT-amber" alt="License" />
  <img src="https://img.shields.io/badge/Tests-7%20Passed-success" alt="Tests" />
  <img src="https://img.shields.io/badge/Analysis-0%20Issues-brightgreen" alt="Analysis" />
</p>

---

## 📑 Table of Contents

- [Key Features](#-key-features)
- [Screenshots & UI Highlights](#-ui-and-design-system)
- [Architecture & Tech Stack](#-architecture--tech-stack)
- [Project Directory Structure](#-project-directory-structure)
- [Data Models & Seed Dataset](#-data-models--seed-dataset)
- [Getting Started](#-getting-started)
- [Running Tests & Quality Assurance](#-running-tests--quality-assurance)
- [DPDP Act 2023 Compliance](#-dpdp-act-2023-compliance)
- [Admin Management Portal](#-admin-management-portal)

---

## ✨ Key Features

### 1. 🗺️ Map-First Discovery (`HomeScreen`)
- **Custom Vector Canvas Map**: Native 2D canvas drawing streets, urban blocks, green spaces, Sabarmati river, and pulsing user radar marker.
- **Signature 45° Price Pins**: Interactive custom markers displaying monthly rent badges that expand on selection.
- **Search & Locality Filter**: Real-time filtering across major student and IT hubs (Navrangpura, Satellite, Bodakdev, SG Highway).
- **Filter Tags**: Instant toggles for `All`, `Girls PG`, `Boys PG`, `Under ₹10k`, and `Above ₹10k`.
- **Bottom Sliding Preview Card**: Quick glance at rent, distance to landmarks, verified badge, and direct "View PG →" navigation.

### 2. 🏠 Dedicated 14-Section PG Mini-Website (`PGWebScreen`)
1. **Hero Header**: High-resolution cover carousel, gender badges, verified shield, and live like counter.
2. **360° Virtual Tour Card**: Drag-to-rotate panoramic room inspection with room navigation (*Bedroom, Study, Dining*).
3. **Video Vlog Tour**: Embedded YouTube-style video player with timeline scrubber and chapter timestamps.
4. **Photo Lightbox Gallery**: Full-screen pinch-to-zoom image viewer with thumbnail filmstrip.
5. **Quick Stats Grid**: Notice period, lock-in duration, gate closing hours, and meal types (Pure Veg / Jain).
6. **Sharing & Pricing Matrix**: 1, 2, 3, and 4 sharing breakdowns with security deposits and room amenities.
7. **Curated Amenities**: High-speed WiFi, AC, Geyser, RO Water, Biometric Access, Housekeeping, Laundry, Power Backup, Gym, CCTV.
8. **Meal Schedule**: Breakfast, Lunch, High Tea, and Dinner menus with dietary indicators.
9. **House Rules & Policies**: Curfew, visitor entry policies, smoking/alcohol prohibitions, and security guidelines.
10. **Locality & Landmarks**: Distance to nearby universities, metro stations, IT corridors, and hospitals with live Google Maps directions.
11. **Verified Owner / Manager Profile**: Property manager credentials, badges, and response time metrics.
12. **Rewarded Ad Contact Unlock**: 4-second rewarded video ad simulation unlocking verified phone number with direct dial (`tel:`) and WhatsApp messaging.
13. **Student Reviews & Ratings**: Breakdown of cleanliness, food quality, safety, and resident feedback.
14. **Sticky Floating Action Bar**: Live Like button, Contact button, and primary **"Enroll Now"** CTA.

### 3. 📝 2-Step Enrollment Application Flow
- **Step 1 — Application Form**: Auto-populates personal details from saved profile (Name, Phone, Email, Gender, Age, Occupation) with move-in date picker and sharing type selection.
- **Step 2 — OTP Verification**: 6-digit OTP code verification with countdown timer and instant demo auto-fill (`482100`).
- **Confirmation Modal**: Generates unique application token (`ENR-...`) with status tracking summary.

### 4. 💖 Saved PGs & Profile Management
- **Liked PGs Tab**: Real-time persistent bookmarks with instant unlike capability.
- **User Profile**: Initials avatar badge (`YM`), active enrollment tracking cards with status badges (`Under Review`, `Accepted`, `Rejected`, `Submitted`).
- **DPDP Act 2023 Compliance**: Privacy notice, consent withdrawal, and **Right to Erasure (Delete Account)** with complete data wipe.

### 5. 🛡️ Admin Management Console
- **KPI Metrics**: Real-time counters for Total PGs, Total Views, Contact Unlocks, and Total Leads.
- **Lead Workflow**: Review submitted enrollment applications, mark as Accepted/Rejected, and add admin notes.
- **PG Onboarding & Editor**: Form to add or edit PGs, upload image URLs, configure rent, security deposits, coordinates, room sharing types, and amenities.

---

## 🎨 UI and Design System

### Curated Color Palette
| Token | Hex | Role |
|---|---|---|
| **Navy** | `#141F29` / `#1C2A38` | Headers, brand surfaces, dark button CTAs |
| **Cream** | `#F6F1E6` | Main scaffold background, warm card undertones |
| **Paper** | `#FFFDF8` | Elevated cards, dialogs, bottom sheets |
| **Marigold** | `#E2A63B` / `#C48B28` | Signature accent, action CTAs, map pins, active badges |
| **Teal** | `#2C6E63` / `#E8F3F1` | Verified indicators, pricing highlights, active filters |
| **Ink & InkSoft** | `#1A2229` / `#5B6672` | Primary typography and subtitle captions |
| **Line** | `#E1D8C4` | Subtle borders and dividers |

### Typography (`GoogleFonts`)
- **Display & Headings**: `Fraunces` (Editorial serif)
- **UI & Body**: `Inter` (Clean, legible sans-serif)
- **Badges, Prices & Codes**: `JetBrains Mono` (Monospace precision)

---

## 🏗️ Architecture & Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart 3)
- **State Management**: Reactive `ChangeNotifier` pattern via central `AppState`
- **Persistence**: `SharedPreferences` for local offline storage (Liked PGs, Unlocked Contacts, User Profile, Enrollments, Custom PGs)
- **Typography**: `google_fonts` (`Fraunces`, `Inter`, `JetBrains Mono`)
- **Formatting**: `intl` (Date & Currency formatting)
- **Device Linking**: `url_launcher` (`tel:`, `https://wa.me/`, `https://maps.google.com/`)

---

## 📂 Project Directory Structure

```
pgcity/
├── android/                         # Android native project files & Gradle scripts
├── ios/                             # iOS native Xcode project & configurations
├── docs/                            # PRD & UI Mobile Screens HTML specifications
│   ├── PRD.html
│   └── Mobile_Screens.html
├── lib/
│   ├── main.dart                    # App entry point, storage initialization & theme setup
│   ├── core/                        # Design tokens, theme & utilities
│   │   ├── constants/
│   │   │   ├── app_colors.dart      # Curated color tokens (Navy, Cream, Marigold, Teal, Ink)
│   │   │   └── app_typography.dart  # GoogleFonts configurations (Fraunces, Inter, JetBrains Mono)
│   │   ├── theme/
│   │   │   └── app_theme.dart       # Material 3 ThemeData with custom components
│   │   └── utils/
│   │       └── currency_formatter.dart # Indian Currency Formatter (₹#,##,###)
│   ├── data/                        # Data models, seed data & repositories
│   │   ├── models/
│   │   │   ├── pg_model.dart        # PGModel, PGType, Availability, Verification, VirtualTour
│   │   │   ├── user_model.dart      # UserModel, UserGender
│   │   │   ├── enrollment_model.dart# EnrollmentModel, EnrollmentStatus
│   │   │   └── notification_model.dart # NotificationModel, NotificationType
│   │   ├── seed_data/
│   │   │   └── pg_seed_data.dart    # 6 authentic curated Ahmedabad PG properties
│   │   └── repositories/
│   │       ├── pg_repository.dart   # Persistent PG CRUD, Likes & Contact Unlocks
│   │       ├── user_repository.dart # User profile persistence & OTP generator
│   │       └── enrollment_repository.dart # Enrollment applications & status management
│   └── presentation/                # UI Screens, Widgets & State Controller
│       ├── controllers/
│       │   └── app_state.dart       # Central ChangeNotifier coordinating state & filters
│       ├── widgets/
│       │   ├── custom_pin_marker.dart   # 45° signature map pin with price tag
│       │   ├── interactive_pg_map.dart  # Vector canvas map with roads, river, pins & radar
│       │   ├── pg_preview_card.dart     # Map sliding preview card
│       │   ├── city_selector_sheet.dart # City switcher modal
│       │   └── notification_sheet.dart  # In-app notification drawer
│       └── screens/
│           ├── main_navigation_screen.dart # 3-tab Bottom navigation bar (Home, Liked, Profile)
│           ├── home/
│           │   └── home_screen.dart     # Discovery map screen, search & filter chips
│           ├── pg_detail/
│           │   ├── pg_web_screen.dart   # 14-section comprehensive PG mini-website
│           │   ├── virtual_tour_360_screen.dart # Interactive 360° panoramic room viewer
│           │   ├── video_tour_screen.dart # YouTube vlog player simulation
│           │   ├── photo_lightbox_screen.dart # Full-screen photo gallery
│           │   └── contact_unlock_sheet.dart # Rewarded video ad contact unlock sheet
│           ├── enrollment/
│           │   ├── enrollment_sheet.dart # 2-step application form with auto profile fill
│           │   ├── otp_verification_screen.dart # 6-digit OTP verification screen
│           │   └── enrollment_success_dialog.dart # Confirmation token dialog
│           ├── liked/
│           │   └── liked_pgs_screen.dart # Saved favorite PGs screen
│           ├── profile/
│           │   ├── profile_screen.dart  # User profile & live enrollment tracking
│           │   ├── edit_profile_sheet.dart # Edit personal details modal
│           │   ├── privacy_policy_modal.dart # DPDP Act 2023 compliance notice
│           │   └── help_support_modal.dart # In-app FAQ & WhatsApp support
│           └── admin/
│               ├── admin_dashboard_screen.dart # Admin KPI metrics & lead manager
│               └── admin_pg_editor_screen.dart # Onboard / edit PG listing form
├── test/
│   └── widget_test.dart             # Unit & integration test suite (7 tests)
├── .gitignore                       # Android & iOS clean gitignore
├── analysis_options.yaml            # Dart static analyzer lint rules
└── pubspec.yaml                     # Dependencies & project metadata
```

---

## 📊 Data Models & Seed Dataset

The app comes pre-loaded with **6 curated authentic PGs** in Ahmedabad:
1. **Sunrise Girls Luxury PG** (Navrangpura) — ₹12,500/mo (Girls PG, Verified)
2. **Green Residency Executive PG** (Satellite) — ₹8,500/mo (Boys PG, Verified)
3. **Apex Elite Boys PG** (Bodakdev) — ₹14,000/mo (Boys PG, Verified)
4. **Stanza Oasis Co-Living** (SG Highway) — ₹9,500/mo (Boys PG, Verified)
5. **Lotus Luxury Girls Hostel** (Navrangpura) — ₹16,000/mo (Girls PG, Verified)
6. **Royal Palms Executive PG** (Satellite) — ₹11,000/mo (Boys PG, Verified)

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`v3.24.0` or later)
- Android Studio / Xcode for simulator / device execution
- Dart SDK (`v3.0.0` or later)

### Installation
```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/pgcity.git

# 2. Navigate to project root
cd pgcity

# 3. Fetch dependencies
flutter pub get
```

### Run on Android
```bash
# Start Android Emulator or connect physical device
flutter run -d android
```

### Run on iOS
```bash
# Start iOS Simulator (macOS only)
open -a Simulator
flutter run -d ios
```

---

## 🧪 Running Tests & Quality Assurance

### Run Unit Tests
```bash
flutter test
```
*Expected Output: `All tests passed! (7/7 tests)`*

### Run Static Analysis
```bash
flutter analyze
```
*Expected Output: `No issues found!`*

---

## 🔒 DPDP Act 2023 Compliance

PGCity is built with privacy-first standards in accordance with India's **Digital Personal Data Protection (DPDP) Act 2023**:
- **Purpose Limitation**: Contact details and enrollment data are processed strictly for accommodation matching.
- **Informed Consent**: Explicit opt-in checkboxes before submitting applications.
- **Right to Erasure**: Full account deletion feature in the Profile screen that permanently wipes user identity, enrollment records, and unlocked contact history.

---

## 👨‍💼 Admin Management Portal

Access the built-in Admin Console from the Profile screen (or top-right badge) to:
- Monitor live analytics: Total PGs, Total Views, Contact Unlocks, and Inbound Leads.
- Review and transition applicant enrollment statuses (`Submitted` ➔ `Under Review` ➔ `Accepted` / `Rejected`).
- Onboard new PG properties with image galleries, room sharing pricing, amenities, and coordinates.

---

<p align="center">
  Crafted with ❤️ for students & young professionals finding their next home.
</p>
