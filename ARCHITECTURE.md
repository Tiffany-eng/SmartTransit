# Architecture

## Folders

```
lib/
  core/theme/app_theme.dart        # design tokens, light + dark ThemeData
  data/
    datasources/
      auth_remote_data_source.dart      # FirebaseAuth + GoogleSignIn calls
      settings_local_data_source.dart   # raw SharedPreferences get/set
    repositories/
      auth_repository_impl.dart
      settings_repository_impl.dart
  domain/
    entities/
      app_user.dart              # {uid, email, emailVerified}
      app_settings.dart          # {themeMode, notificationsEnabled, smsFallbackEnabled}
    repositories/
      auth_repository.dart       # abstract contract
      settings_repository.dart   # abstract contract
  presentation/
    cubit/
      auth/auth_cubit.dart, auth_state.dart
      settings/settings_cubit.dart, settings_state.dart
    screens/
    widgets/
  main.dart
```

`presentation` only talks to `domain` interfaces — no screen imports
`firebase_auth` or `shared_preferences` directly. `data` is the only layer
that implements those interfaces and touches Firebase/SharedPreferences.
`main.dart` wires the concrete `data` classes into the `domain` interfaces
once, at startup, so everything above it works against the abstraction.

## State management: Cubit (flutter_bloc)

Went with `Cubit`, not full event-based `Bloc`, and not Riverpod/GetX.

`flutter_bloc` is the library the class's BLoC video is built on, so the
folder layout above follows the same shape we already saw. Within
`flutter_bloc`, a plain `Cubit` was enough for this app — there are only two
pieces of shared state (the auth session and the three settings), and
`cubit.signIn(email, password)` is simpler to read than defining a
`SignInRequested` event class and an `on<SignInRequested>` handler for the
same one-line effect. Cubits are still just `Stream<State>` underneath, so
nothing here would need to change if a screen's logic later grew complex
enough to justify events.

`AuthCubit` and `SettingsCubit` are the only classes that call into the
`domain` repositories. Screens call cubit methods
(`context.read<AuthCubit>().signIn(...)`) and render with
`BlocBuilder`/`BlocConsumer`.

## Persisted settings (SharedPreferences)

`SettingsCubit` loads all three on startup and writes through immediately on
every toggle, so they survive a restart:

- Dark mode — Profile screen, "Dark Mode" switch
- Push notifications — Notifications screen, toggle at the top
- SMS data fallback — Data & Sync Preferences screen (existing toggle, now
  actually persisted instead of resetting on every launch)

One limitation: dark mode swaps `MaterialApp.themeMode` globally, so
Material defaults (buttons, inputs, dialogs, snackbars) follow it, but most
screens hardcode colors like `Colors.white` / `AppColors.textDark` directly
instead of reading `Theme.of(context)`, so those specific screens won't
visually re-skin. That's a UI pass outside this branch's scope.

## Auth flow

`AuthCubit` subscribes to `AuthRepository.authStateChanges` once, at
construction, and emits `Authenticated`/`Unauthenticated` whenever Firebase's
session changes — including the first emission after launch, which reflects
whatever session Firebase already restored from disk. `SplashScreen` reads
that state after its animation delay instead of reading `FirebaseAuth`
directly.
