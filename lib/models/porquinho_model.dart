import 'package:hive/hive.dart';

part 'porquinho_model.g.dart';

@HiveType(typeId: 0)
class Porquinho extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nome;

  @HiveField(2)
  double meta;

  @HiveField(3)
  int depositoMaximo;

  @HiveField(4)
  List<int> depositosFeitos;

  Porquinho({
    required this.id,
    required this.nome,
    required this.meta,
    required this.depositoMaximo,
    required this.depositosFeitos,
  });

  /// Meta = soma de 1 até [depositoMaximo] (1 + 2 + ... + n).
  static double calcularMeta(int depositoMaximo) {
    return depositoMaximo * (depositoMaximo + 1) / 2;
  }

  double get totalDepositado {
    return depositosFeitos.fold(0, (soma, v) => soma + v);
  }

  double get progresso {
    if (meta == 0) return 0;
    return totalDepositado / meta;
  }
}
