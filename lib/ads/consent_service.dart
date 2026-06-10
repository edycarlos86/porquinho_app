import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 🔐 Fluxo de consentimento de anúncios (Google UMP / GDPR / LGPD).
///
/// Atualiza as informações de consentimento e, se necessário, exibe o
/// formulário do Google antes de qualquer anúncio ser carregado.
/// As mensagens são configuradas no painel do AdMob → Privacy & messaging.
class ConsentService {
  ConsentService._();
  static final ConsentService instance = ConsentService._();

  /// Reúne o consentimento e chama [onComplete] quando o processo termina
  /// (com sucesso ou falha). Anúncios só devem ser carregados depois disso,
  /// verificando [ConsentInformation.instance.canRequestAds].
  void gatherConsent(void Function() onComplete) {
    final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        // Mostra o formulário apenas se for exigido na região do usuário.
        await ConsentForm.loadAndShowConsentFormIfRequired((formError) {
          onComplete();
        });
      },
      (FormError error) {
        // Falha ao atualizar o consentimento: segue mesmo assim.
        // (O SDK não servirá anúncios se o consentimento não permitir.)
        onComplete();
      },
    );
  }
}
