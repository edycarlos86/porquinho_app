import 'package:intl/intl.dart';

class MoedaUtil {
  static final NumberFormat _real =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  static String formatar(double valor) {
    return _real.format(valor);
  }
}
