# Smart Transit Kigali — Flutter App

A working Flutter build of all 12 screens from the Smart Transit Kigali Figma file,
wired together with real navigation and matching micro-animations.

## Screens included
1. Splash
2. Login
3. Home
4. Find your Route (search)
5. Live Tracking (map + bottom sheet)
6. Bus Details
7. Notifications
8. Profile
9. Data & Sync Preferences (SMS fallback toggle)
10. Route Error (connection lost)
11. Home — Offline SMS Mode
12. Tracking — Offline SMS Sync

## Run it

```bash
flutter pub get
flutter run
```

Requires the Flutter SDK (stable channel) and a connected device or simulator.
The checked-in project runs as a fully navigable UI demo by default, so no
Firebase credentials are required to launch it.

## Maps and current location

The Live Tracking screen uses Google Maps and the route search screen can use the
device's current location. Create a Google Maps Platform key with the Maps SDK
for Android and Maps SDK for iOS enabled, then restrict it to this app's Android
package/SHA-1 and iOS bundle ID.

- Android: add `MAPS_API_KEY=your_key` to `android/local.properties`.
- iOS: set the `GOOGLE_MAPS_API_KEY` build setting in Xcode (or an untracked
  `.xcconfig` included by the Runner target).

The app requests location access only after the rider taps the **From: Current
Location** field.

## Firebase backend

The app supports Firebase Authentication, Cloud Firestore, and Realtime
Database. To enable those services, run `flutterfire configure`, add the
generated configuration files to the platform projects, enable Email/Password
sign-in, and deploy the checked-in rules/indexes with:

```bash
firebase deploy --only firestore:rules,firestore:indexes,database
```

Then launch with Firebase enabled:

```bash
flutter run --dart-define=ENABLE_FIREBASE=true
```

The full collection contract and access model are documented in
[`docs/FIREBASE_DATA_MODEL.md`](docs/FIREBASE_DATA_MODEL.md). Rider data lives
under `users/{uid}`, while routes/buses are staff-managed and high-frequency bus
locations live in Realtime Database.

## Project structure

```
lib/
  main.dart                  # App entry point
  theme/app_theme.dart       # Colors, type, component theming
  widgets/                   # Shared building blocks
    fade_in_up.dart          # Staggered entrance animation
    slide_route.dart         # Slide+fade page transition
    pill_back_button.dart    # Rounded back button
    home_header_bar.dart     # Bell / Kigali chip / avatar
    action_card.dart         # Find Route / Live Map / Nearby Stops cards
    pulsing_map_dot.dart     # "You are here" animated map marker
    dev_jump_menu.dart       # Demo-only: jump to any screen instantly
  screens/                   # One file per screen, matching the naming above
```

## Notes

- `widgets/dev_jump_menu.dart` adds a small "apps" button in the top-right
  corner of every screen so you can jump
  straight to any of the 12 screens without replaying the whole app. It's
  purely a demo aid — delete the file and its usages before shipping.
- Real navigation is wired the way the product would actually flow: Home →
  Find Route → Live Tracking → Bus Details, Profile → Data & Offline SMS
  Settings, Route Error → Offline SMS Mode, etc.
- Data shown (bus numbers, ETAs, notifications) is static/sample data — swap
  in your backend/API calls where indicated in each screen file.
