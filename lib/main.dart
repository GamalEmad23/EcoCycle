import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/services/notification_service.dart';
import 'package:eco_cycle/features/admin_nav_bar/admin_nav_bar.dart';
import 'package:eco_cycle/features/admin_profile/cubit/admin_cubit.dart';
import 'package:eco_cycle/features/auth/cubit/auth_cubit.dart';
import 'package:eco_cycle/features/nav_bar/cubit/nav_bar_cubit.dart';
import 'package:eco_cycle/features/nav_bar/view/nav_bar.dart';
import 'package:eco_cycle/features/profile/cubit/cubit/profile_cubit.dart';
import 'package:eco_cycle/features/splash_screen/view/splash_screen.dart';
import 'package:eco_cycle/features/statistics/cubit/statistics_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/themes/cubit/theme_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().init();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),

      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(create: (context) => NavBarCubit()),
          BlocProvider(create: (context) => AdminCubit()),
          BlocProvider(create: (context) => ThemeCubit()..loadTheme()),
          BlocProvider(
            create: (context) => ProfileCubit()..getSavedLang(context),
            child: Container(),
          ),
          BlocProvider(
            create: (context) => StatisticsCubit()..getStatisticsData(),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<User?> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        AppColors.isDarkMode = themeMode == ThemeMode.dark;
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: themeMode,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeAnimationDuration: const Duration(milliseconds: 180),
          themeAnimationCurve: Curves.easeOutCubic,
          debugShowCheckedModeBanner: false,
          home: StreamBuilder<User?>(
            stream: _authStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }

              final user = snapshot.data;

              if (user != null && user.emailVerified) {
                final isAdmin =
                    user.email == "emadg6139@gmail.com" ||
                    user.email == "ahmedsorour628@gmail.com";
                return isAdmin ? const AdminNavBar() : const NavBar();
              }

              return const SplashScreen();
            },
          ),
        );
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: AppColors.green,
        secondary: AppColors.primary,
        surface: AppColors.white,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: baseTheme.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.green,
      ),
      dividerColor: AppColors.border,
      cardColor: AppColors.white,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        hintStyle: TextStyle(color: AppColors.textGrey),
        prefixIconColor: AppColors.textGrey,
        suffixIconColor: AppColors.textGrey,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.green, width: 2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.textGrey,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.green,
        unselectedLabelColor: AppColors.textGrey,
        indicatorColor: AppColors.green,
      ),
    );
  }
}
