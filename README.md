# Lordan - Premium Chat UI/UX (Flutter)

A modern, responsive Flutter application featuring a premium chat interface, glassmorphism design, and multi-language support. Lordan is built for a seamless user experience across mobile, tablet, and desktop devices, focusing on clean, reusable UI components and professional design patterns.

## 🚀 Features & Screens

- **Splash Screen**: Animated logo and tagline, with fade-in benefits and motivational sequence for first-time users.
  - **Welcome Language Screen**: Multi-language selection with responsive layout.
  - **Onboarding Screen**: Role-based introduction in a unified grid (premium roles highlighted).
  - **Login Screen**: Supabase authentication UI (email, Apple, Google login).
  - **Home Screen**: Role grid with premium indicators and responsive design.
  - **Chat Text Screen**: Text conversation UI with input field and send button.
  - **Chat Voice Screen**: Voice interface with microphone button (UI only).
  - **History Screen**: Local session summaries with tap-to-resume functionality.
  - **Settings Screen**: Language, theme, voice settings, privacy & terms.
  - **Paywall / Upgrade Screen**: Premium comparison, plan switcher, glassmorphic pricing card, and CTA button.
  - **FAQ / Trust Screen**: Help and trust information section with expandable questions.

## 🛠️ Tech Stack

- **Flutter SDK** (>=3.5.3)
  - **Dart**
  - **Provider** (state management)
  - **Go Router** (navigation)
  - **Supabase Flutter** (authentication UI)
  - **Google Fonts** (typography)
  - **Font Awesome** (icons)
  - **Intl** (localization)

## 📁 Folder Structure

```
lib/
├── main.dart                 # App entry point
├── theme.dart                # Theme config
├── models/                   # UI state models
├── providers/                # State management
├── screens/                  # UI screens
│   ├── start/                # Onboarding & welcome
│   ├── home/                 # Main screens
│   ├── chat/                 # Chat interfaces
│   └── paywall/              # Upgrade UI
├── service/                  # UI services
└── utils/                    # Helpers & routing
assets/                       # Fonts, icons, images
```

## 📦 Installation Guide

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd lordan_v1
   ```
   2. **Install dependencies**
      ```bash
      flutter pub get
      ```
   3. **Run the application**
      ```bash
      flutter run
      ```

## ▶️ How to Run

- **Android**: `flutter run -d android`
  - **iOS**: `flutter run -d ios`
  - **Web**: `flutter run -d chrome`

## ⚠️ Notes for Client

- This project currently covers **UI only** (no backend functionality).
  - Ready to be extended with API integrations and backend logic.
  - All authentication and chat features are UI placeholders.

## 👨‍💻 Credits

Developed by [Your Name or Fiverr handle]
