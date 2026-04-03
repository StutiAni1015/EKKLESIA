import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_colors.dart';
import 'core/app_localizations.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const EkklesiaApp());
}

class EkklesiaApp extends StatelessWidget {
  const EkklesiaApp({super.key});

  // Supported locales mirror the languages in LanguageSelectionScreen
  static const _supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('ko'),
    Locale('zh'),
    Locale('hi'),
    Locale('ar'),
    Locale('sw'),
    Locale('tl'),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocaleNotifier,
      builder: (context, locale, _) {
        return AppLocalizationsScope(
          localizations: AppLocalizations(locale),
          child: MaterialApp(
            title: 'Ekklesia',
            debugShowCheckedModeBanner: false,

            // Locale wiring
            locale: locale,
            supportedLocales: _supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              scaffoldBackgroundColor: AppColors.ivory,
              fontFamily: 'sans-serif',
              useMaterial3: true,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                },
              ),
              splashFactory: InkRipple.splashFactory,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: AppColors.backgroundDark,
              fontFamily: 'sans-serif',
              useMaterial3: true,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                },
              ),
              splashFactory: InkRipple.splashFactory,
            ),
            home: const WelcomeScreen(
              languageCode: 'en',
              languageNativeName: 'English',
            ),
          ),
        );
      },
    );
  }
}
