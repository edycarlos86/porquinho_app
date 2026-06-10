import 'package:flutter_test/flutter_test.dart';
import 'package:porquinho_app/models/porquinho_model.dart';

void main() {
  group('Porquinho', () {
    test('totalDepositado soma os depósitos feitos', () {
      final p = Porquinho(
        id: '1',
        nome: 'Teste',
        meta: 55,
        depositoMaximo: 10,
        depositosFeitos: [1, 2, 3],
      );

      expect(p.totalDepositado, 6);
    });

    test('progresso é total dividido pela meta', () {
      final p = Porquinho(
        id: '1',
        nome: 'Teste',
        meta: 10,
        depositoMaximo: 4,
        depositosFeitos: [1, 4],
      );

      expect(p.progresso, 0.5);
    });

    test('progresso é 0 quando a meta é 0', () {
      final p = Porquinho(
        id: '1',
        nome: 'Teste',
        meta: 0,
        depositoMaximo: 0,
        depositosFeitos: [],
      );

      expect(p.progresso, 0);
    });
  });
}
