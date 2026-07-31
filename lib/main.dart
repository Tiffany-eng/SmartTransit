import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/settings_local_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'presentation/cubit/auth/auth_cubit.dart';
import 'presentation/cubit/settings/settings_cubit.dart';
import 'presentation/cubit/settings/settings_state.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authRepository = AuthRepositoryImpl(AuthRemoteDataSource());
  final settingsRepository = SettingsRepositoryImpl(SettingsLocalDataSource());

  runApp(SmartTransitApp(
    authRepository: authRepository,
    settingsRepository: settingsRepository,
  ));
}

class SmartTransitApp extends StatelessWidget {
  final AuthRepository authRepository;
  final SettingsRepository settingsRepository;

  const SmartTransitApp({
    super.key,
    required this.authRepository,
    required this.settingsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<SettingsRepository>.value(value: settingsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(authRepository)),
          BlocProvider(create: (context) => SettingsCubit(settingsRepository)),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            return MaterialApp(
              title: 'Smart Transit Kigali',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: settingsState.settings.themeMode,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
