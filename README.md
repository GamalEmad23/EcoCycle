# ♻️ EcoCycle

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge)
![Build](https://img.shields.io/badge/Build-Passing-brightgreen?style=for-the-badge)

**EcoCycle** is an innovative Flutter application designed to promote and facilitate recycling. The app connects regular users with recycling administrators, providing a seamless process for submitting recycling requests, tracking statistics, and encouraging eco-friendly habits. Powered by machine learning (TFLite) and Firebase, EcoCycle is a modern solution to a cleaner environment.

---

## 📸 Screenshots

*(Replace the placeholder image links with actual screenshots or a GIF of your app)*

<div align="center">
  <img src="https://via.placeholder.com/200x400.png?text=Splash+Screen" width="200" />
  <img src="https://via.placeholder.com/200x400.png?text=Onboarding" width="200" />
  <img src="https://via.placeholder.com/200x400.png?text=Home+Screen" width="200" />
  <img src="https://via.placeholder.com/200x400.png?text=Map+Picker" width="200" />
  <img src="https://via.placeholder.com/200x400.png?text=ML+Scanner" width="200" />
</div>

---

## ✨ Features

### For Users 🧑‍💼
- **Authentication:** Secure Sign-Up/Sign-In using Firebase Auth & Google Sign-In.
- **Onboarding:** A clean introduction to the app's goals and functionality.
- **Machine Learning Integration:** Uses `tflite_flutter` to classify and identify recyclable materials using the device's camera.
- **Recycling Requests:** Easily submit requests to have recyclables picked up.
- **Maps & Geolocation:** Integrated with `flutter_map` and `geolocator` to select accurate pickup locations.
- **Statistics & Tracking:** View personal recycling impact using beautiful charts (`fl_chart`).
- **Localization:** Supports multiple languages using `easy_localization`.

### For Admins 👨‍💻
- **Admin Dashboard:** A separate navigation flow for administrators to manage the system.
- **Order Management:** View, accept, and manage users' recycling requests.
- **Admin Profile:** Specific settings and controls for staff members.

---

## 🛠️ Tech Stack & Architecture

This project is built using modern Flutter development practices. 

- **Framework:** Flutter (SDK: `^3.10.4`)
- **Language:** Dart
- **State Management:** BLoC (`flutter_bloc`, `bloc`) and GetX (`get`) are utilized to manage complex app states efficiently.
- **Backend as a Service (BaaS):** Firebase
  - *Authentication:* User login/registration.
  - *Firestore:* Real-time NoSQL database for orders and user data.
  - *Storage:* For uploading user and request-related images.
  - *Crashlytics:* For tracking errors and app crashes.
- **Machine Learning:** `tflite_flutter` for on-device ML processing.
- **Maps:** `flutter_map`, `flutter_osm_plugin`, and `latlong2`.

### Folder Structure (Feature-First Architecture)
The codebase follows a scalable Feature-First Architecture, dividing the app into `core` and `features`.

```text
lib/
├── core/
│   ├── Data/        # Core data models and local/remote data sources
│   ├── helper/      # Helper functions and utilities
│   ├── responsive/  # Responsive design configurations
│   ├── services/    # Global services (Firebase, ML, Location)
│   ├── themes/      # App color schemes and typography
│   ├── utils/       # Common utilities and constants
│   └── widgets/     # Reusable global UI widgets
│
├── features/
│   ├── admin_nav_bar/      # Admin navigation
│   ├── admin_orders/       # Admin order management
│   ├── admin_profile/      # Admin profile settings
│   ├── auth/               # Login & Registration
│   ├── home/               # User Home screen
│   ├── map/                # Location picking and routing
│   ├── nav_bar/            # User bottom navigation
│   ├── onBording/          # Intro screens
│   ├── profile/            # User profile management
│   ├── recycling_request/  # Request submission flow
│   ├── splash_screen/      # Initial loading screen
│   └── statistics/         # User recycling charts and data
│
└── main.dart               # Entry point
```

---

## ⚙️ Environment Setup & API Keys

Since the project uses Firebase and Machine Learning, you need to set up the necessary environment files and models before running the app. 

### 1. Firebase Setup
The project requires Firebase configuration files which are excluded from version control for security.
- **Android:** Add your `google-services.json` file to `android/app/`
- **iOS:** Add your `GoogleService-Info.plist` file to `ios/Runner/`

### 2. Machine Learning Assets
Ensure your TFLite model and labels are present in the assets directory:
- Model path: `assets/model/model.tflite`
- Labels path: `assets/model/labels.txt`

*(If using an `.env` file for additional API keys, make sure to duplicate `.env.example` as `.env` and fill in your keys).*

---

## 🚀 Setup Instructions

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version `3.10.4` or higher)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/GamalEmad23/EcoCycle.git
   cd EcoCycle
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify Environment Setup:**
   Ensure step **"Environment Setup & API Keys"** is completed.

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 🤝 Contribution Guidelines

We welcome contributions! Please follow these steps:
1. **Fork** the project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a **Pull Request**.

---

## 📝 License

This project is licensed under the MIT License.