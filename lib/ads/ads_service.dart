import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  // =====================
  // 🔵 INTERSTITIAL
  // =====================
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;

  static final String _interstitialAdUnitId = kReleaseMode
      ? 'ca-app-pub-9415478156291287/7565990553' // PRODUÇÃO
      : 'ca-app-pub-3940256099942544/1033173712'; // TESTE

  void loadInterstitial() {
    if (_isInterstitialLoading || _interstitialAd != null) return;

    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  void showInterstitial({VoidCallback? onFinished}) {
    if (_interstitialAd == null) {
      onFinished?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
        onFinished?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
        onFinished?.call();
      },
    );

    _interstitialAd!.show();
  }

  // =====================
  // 🟢 APP OPEN AD
  // =====================
  AppOpenAd? _appOpenAd;
  bool _isAppOpenLoading = false;

  /// `true` quando há um App-Open Ad carregado e pronto para exibir.
  bool get isAppOpenAvailable => _appOpenAd != null;

  static final String _appOpenAdUnitId = kReleaseMode
      ? 'ca-app-pub-9415478156291287/8704345233' // PRODUÇÃO (bloco "ABERTURA")
      : 'ca-app-pub-3940256099942544/3419835294'; // TESTE

  void loadAppOpenAd() {
    if (_isAppOpenLoading || _appOpenAd != null) return;

    _isAppOpenLoading = true;

    AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAppOpenLoading = false;
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          _isAppOpenLoading = false;
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable() {
    if (_appOpenAd == null) return;

    _appOpenAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }
}
