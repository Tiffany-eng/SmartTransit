# Smart Transit Kigali

A Flutter app that helps commuters in Kigali find routes, track buses live, and
stay informed even when they're offline — built from a 12-screen Figma design
with real Firebase authentication, persisted user preferences, and an
offline/SMS fallback mode for low-connectivity areas.

> Your smart way to move.

---

## Table of contents

- [Features](#features)
- [Screens](#screens)
- [Tech stack](#tech-stack)
- [Architecture](#architecture)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Clone and install](#clone-and-install)
  - [Firebase setup](#firebase-setup)
  - [Run the app](#run-the-app)
- [Project structure](#project-structure)
- [Testing](#testing)
- [Persisted settings](#persisted-settings)
- [Known limitations](#known-limitations)
- [Contributing](#contributing)

---

## Features

- **Email/password + Google authentication** via Firebase Auth, with email
  verification on sign-up and a "forgot password" reset flow.
- **Persistent login** — the session Firebase already restored from disk is
  what the splash screen checks, so users don't have to log in again on every
  app restart.
- **Route search & live tracking** — search for a route, see it on a live map
  with an animated "you are here" marker, and drill into bus details (bus
  number, capacity, ETA, status).
- **Offline / SMS fallback mode** — when connectivity drops, the app switches
  to an SMS-based flow for checking routes and tracking a bus, so the core
  experience still works without mobile data.
- **Push notifications & preferences** — toggle push notifications, SMS data
  fallback, and dark mode from the Profile screen; all three survive an app
  restart.
- **Light & dark themes** with a single design-token source of truth
  (`AppColors` / `AppTheme`) shared across every screen.
- **Smooth, consistent motion** — staggered fade-in-up entrances and
  slide+fade page transitions are used throughout instead of the default
  Material page transitions.

## Screens

| # | Screen | Notes |
|---|--------|-------|
| 1 | Splash | Checks the restored Firebase session, then routes to Login or Home |
| 2 | Login | Email/password + "Continue with Google" |
| 3 | Register | Email/password sign-up with confirm-password check |
| 4 | Home | Quick actions: find a route, live map, nearby stops |
| 5 | Find your Route (search) | Search and pick a route |
| 6 | Live Tracking | Map + bottom sheet with ETA and next stop |
| 7 | Bus Details | Bus number, operator, capacity, stop-by-stop progress |
| 8 | Notifications | Recent alerts, push notification toggle |
| 9 | Profile | Account summary, preferences, logout |
| 10 | Data & Sync Preferences | SMS fallback toggle |
| 11 | Route Error | Shown when connectivity/tracking fails |
| 12 | Home — Offline SMS Mode | Home screen's fallback when offline |
| 13 | Tracking — Offline SMS Sync | Live tracking's fallback when offline |

## Tech stack

| Concern | Choice |
|---|---|
| Framework | Flutter (Dart >=3.0.0 <4.0.0) |
| State management | [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) Cubits |
| Auth | [`firebase_auth`](https://pub.dev/packages/firebase_auth) + [`google_sign_in`](https://pub.dev/packages/google_sign_in) |
| Backend init | [`firebase_core`](https://pub.dev/packages/firebase_core) |
| Local persistence | [`shared_preferences`](https://pub.dev/packages/shared_preferences) |
| Typography | [`google_fonts`](https://pub.dev/packages/google_fonts) (Inter) |
| Value equality | [`equatable`](https://pub.dev/packages/equatable) |

See [`pubspec.yaml`](pubspec.yaml) for exact versions.

## Architecture

The app follows a Clean Architecture split — `presentation` / `domain` /
`data` / `core` — so screens only ever depend on abstract `domain` contracts,
never on Firebase or SharedPreferences directly:

```
presentation  →  domain (interfaces)  ←  data (Firebase / SharedPreferences)
```

- **`domain/`** — pure Dart entities (`AppUser`, `AppSettings`) and repository
  *interfaces* (`AuthRepository`, `SettingsRepository`). No Flutter or
  Firebase imports.
- **`data/`** — the only layer that touches `firebase_auth`, `google_sign_in`,
  and `shared_preferences`. Implements the `domain` interfaces.
- **`presentation/`** — `AuthCubit` and `SettingsCubit` are the only classes
  that call into `domain` repositories; screens call cubit methods
  (`context.read<AuthCubit>().signIn(...)`) and render with
  `BlocBuilder`/`BlocConsumer`.
- **`core/`** — design tokens: `AppColors` and light/dark `ThemeData`.

This means swapping Firebase for another auth provider, or SharedPreferences
for a different local store, only requires new `data/` implementations — the
`presentation` and `domain` layers don't change.

For the full rationale behind the Cubit choice, the persisted-settings flow,
and the auth-restore flow on launch, see [`ARCHITECTURE.md`](ARCHITECTURE.md).

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- A configured Firebase project with **Email/Password** and **Google**
  sign-in providers enabled (Authentication → Sign-in method)
- A connected device, emulator, or simulator

### Clone and install

```bash
git clone <this-repo-url>
cd SmartTransit
flutter pub get
```

### Firebase setup

This repo ships with `lib/firebase_options.dart` and
`android/app/google-services.json` already generated for the
`smart-transit-kigali` Firebase project, so it runs out of the box for
Android. To point the app at your **own** Firebase project instead:

1. Install the [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup)
   if you don't have it: `dart pub global activate flutterfire_cli`
2. Run `flutterfire configure` from the project root and select your Firebase
   project — this regenerates `lib/firebase_options.dart` and drops the
   platform config files (`google-services.json`,
   `GoogleService-Info.plist`) in the right place.
3. Enable **Email/Password** and **Google** under Authentication → Sign-in
   method in the Firebase console.
4. For Google Sign-In on Android, add your debug (and release) SHA-1/SHA-256
   fingerprints to the Firebase project settings, or Google Sign-In will fail
   silently on that platform.

### Run the app

```bash
flutter run
```

To jump straight to any of the 12 main screens instead of navigating through
the app manually, use the small "apps" button in the top-right corner of
every screen (see [Known limitations](#known-limitations) — it's a demo aid,
not shipped functionality). Register isn't in that list since it's reached
from Login's "Create account" link.

## Project structure

```
lib/
  main.dart                    # App entry point / composition root
  firebase_options.dart        # Generated by `flutterfire configure`
  core/
    theme/app_theme.dart       # Colors, type, component theming (light + dark)
  domain/
    entities/                  # AppUser, AppSettings — pure Dart
    repositories/               # AuthRepository, SettingsRepository — abstract contracts
  data/
    datasources/
      auth_remote_data_source.dart      # FirebaseAuth + GoogleSignIn calls
      settings_local_data_source.dart   # raw SharedPreferences get/set
    repositories/
      auth_repository_impl.dart
      settings_repository_impl.dart
  presentation/
    cubit/
      auth/auth_cubit.dart, auth_state.dart
      settings/settings_cubit.dart, settings_state.dart
    screens/                    # One file per screen
    widgets/                     # Shared building blocks
      fade_in_up.dart             # Staggered entrance animation
      slide_route.dart            # Slide+fade page transition
      pill_back_button.dart       # Rounded back button
      home_header_bar.dart        # Bell / Kigali chip / avatar
      action_card.dart            # Find Route / Live Map / Nearby Stops cards
      pulsing_map_dot.dart        # "You are here" animated map marker
      settings_toggle_row.dart    # Reusable on/off switch row
      dev_jump_menu.dart          # Demo-only: jump to any screen instantly
test/
  fakes/fake_repositories.dart   # In-memory AuthRepository/SettingsRepository fakes
  settings_cubit_test.dart       # SettingsCubit persistence tests
  widget_test.dart
```

## Testing

```bash
flutter test
```

`test/settings_cubit_test.dart` exercises `SettingsCubit` end-to-end against
a real `SettingsRepositoryImpl`/`SettingsLocalDataSource` backed by
`shared_preferences`' mock, verifying that toggling dark mode and SMS
fallback actually persists across a fresh read (not just in-memory state).
`test/fakes/fake_repositories.dart` provides lightweight fakes for widget
tests that need an `AuthRepository`/`SettingsRepository` without touching
Firebase.

## Persisted settings

Three preferences are loaded on startup and written through immediately on
every toggle, so they survive a restart:

| Setting | Where it's toggled | Default |
|---|---|---|
| Dark mode | Profile → "Dark Mode" | Light |
| Push notifications | Notifications screen | On |
| SMS data fallback | Data & Sync Preferences | On |

## Known limitations

- `widgets/dev_jump_menu.dart` adds a small "apps" button to every screen so
  you can jump straight to any screen without replaying the whole app flow.
  It's a demo aid only — remove the file and its usages before shipping.
- Dark mode swaps `MaterialApp.themeMode` globally, so Material defaults
  (buttons, inputs, dialogs, snackbars) follow it, but most screens reference
  `AppColors` constants directly instead of `Theme.of(context)`, so those
  specific surfaces won't re-skin. Re-theming them is a UI pass outside the
  current scope.
- Bus numbers, ETAs, routes, and notifications shown are static/sample data —
  swap in real backend/API calls where indicated in each screen file.
- `android/app/google-services.json` is committed for convenience (its API
  key is restricted by package name/SHA fingerprint, not a secret by itself)
  — replace it with your own project's file if you fork this app.

## Contributing

1. Fork the repo and create a feature branch.
2. Keep new screens/widgets consistent with the existing `Clean Architecture`
   split — screens should depend on `domain` interfaces, never on
   `firebase_auth` or `shared_preferences` directly.
3. Run `flutter analyze` and `flutter test` before opening a PR.
