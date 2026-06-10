import 'dart:async';
import 'package:flutter/material.dart';
import 'package:porquinho_app/ads/ads_service.dart';
import 'home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ⏱️ Tempo mínimo de splash (sempre) e máximo de espera pelo anúncio.
  static const Duration _tempoMinimo = Duration(seconds: 2);
  static const Duration _esperaMaximaAnuncio = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _aguardarEContinuar();
  }

  Future<void> _aguardarEContinuar() async {
    final inicio = DateTime.now();

    // Espera o App-Open carregar, respeitando o limite máximo.
    while (mounted &&
        !AdsService.instance.isAppOpenAvailable &&
        DateTime.now().difference(inicio) < _esperaMaximaAnuncio) {
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Garante o tempo mínimo de splash mesmo se o anúncio carregar rápido.
    final decorrido = DateTime.now().difference(inicio);
    if (decorrido < _tempoMinimo) {
      await Future.delayed(_tempoMinimo - decorrido);
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );

    // App-Open aparece por cima da home (formato correto para abertura do app).
    AdsService.instance.showAppOpenAdIfAvailable();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE91E63), // rosa do app
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🐷 ÍCONE
            Image.asset(
              'assets/icon/icon.png', // ajuste se necessário
              width: 120,
              height: 120,
            ),

            const SizedBox(height: 20),

            // 📝 NOME DO APP
            const Text(
              'Meu Porquinho',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Organize seus depósitos',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
