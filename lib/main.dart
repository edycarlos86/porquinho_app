import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:porquinho_app/ads/ads_service.dart';
import 'package:porquinho_app/ads/consent_service.dart';
import 'package:porquinho_app/models/porquinho_model.dart';
import 'package:provider/provider.dart';

import 'providers/porquinho_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 📦 HIVE PRIMEIRO (BACKUP + PERSISTÊNCIA)
  await Hive.initFlutter();
  Hive.registerAdapter(PorquinhoAdapter());
  await Hive.openBox<Porquinho>('porquinhos');
  await Hive.openBox('settings');

  // 📢 ADMOB
  await MobileAds.instance.initialize();

  // 🧪 Em debug, registra este aparelho como dispositivo de teste para
  // que os anúncios de teste sejam servidos de forma confiável.
  if (kDebugMode) {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: ['F33446C6B9A5F22B49BA197E12407B32'],
      ),
    );
  }

  // 🔐 CONSENTIMENTO (UMP): carrega anúncios quando permitido.
  // Em debug, carrega mesmo sem consentimento configurado (para testar).
  ConsentService.instance.gatherConsent(() async {
    final podeAnunciar = await ConsentInformation.instance.canRequestAds();
    if (podeAnunciar || kDebugMode) {
      AdsService.instance.loadInterstitial();
      AdsService.instance.loadAppOpenAd();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PorquinhoProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Meu Porquinho',

            // 🌗 CONTROLE DE TEMA
            themeMode: themeProvider.themeMode,

            // 🌞 TEMA CLARO
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFE91E63),
              ),
              scaffoldBackgroundColor: const Color(0xFFF8F6F3),
            ),

darkTheme: ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  // 🌑 FUNDO REAL
  scaffoldBackgroundColor: const Color(0xFF121212),

  // 🎨 ESQUEMA DE CORES DARK
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFE91E63), // rosa destaque
    secondary: Color(0xFF4CAF50), // verde progresso
    surface: Color(0xFF1E1E1E), // cards
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
  ),

  // 🧱 CARDS
  cardColor: const Color(0xFF1E1E1E),

  // 📝 TEXTOS (MUITO IMPORTANTE)
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    bodySmall: TextStyle(color: Colors.white60),
    labelLarge: TextStyle(color: Colors.white),
  ),

  // 🔝 APPBAR
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),

  // ➕ FAB
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFE91E63),
    foregroundColor: Colors.white,
  ),

  // 🧾 DIALOGS / BOTTOM SHEET
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFF1E1E1E),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF1E1E1E),
  ),

  // 🔘 BOTÕES
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFE91E63),
      foregroundColor: Colors.white,
    ),
  ),
),


            // 🚀 SPLASH
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
