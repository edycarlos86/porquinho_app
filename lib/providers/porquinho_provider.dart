import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/porquinho_model.dart';

class PorquinhoProvider extends ChangeNotifier {
  final Box<Porquinho> _box = Hive.box<Porquinho>('porquinhos');

  List<Porquinho> get porquinhos => _box.values.toList();

  // 🔎 BUSCAR POR ID (null se não existir)
  Porquinho? getById(String id) => _box.get(id);

  // 🐷 CRIAR PORQUINHO
  void adicionarPorquinho(String nome, int depositoMaximo) {
    final metaCalculada = Porquinho.calcularMeta(depositoMaximo);

    final novo = Porquinho(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome,
      meta: metaCalculada,
      depositoMaximo: depositoMaximo,
      depositosFeitos: [],
    );

    _box.put(novo.id, novo);
    notifyListeners();
  }

  // ➕ ADICIONAR DEPÓSITO
  bool adicionarDeposito(String porquinhoId, int valor) {
    final porquinho = _box.get(porquinhoId);
    if (porquinho == null) return false;

    if (!porquinho.depositosFeitos.contains(valor)) {
      porquinho.depositosFeitos.add(valor);
      porquinho.save();
      notifyListeners();

      if (porquinho.totalDepositado >= porquinho.meta) {
        return true; // 🎉 concluído
      }
    }
    return false;
  }

  // ➖ REMOVER DEPÓSITO (DESFAZER)
  void removerDeposito(String porquinhoId, int valor) {
    final porquinho = _box.get(porquinhoId);
    if (porquinho == null) return;

    if (porquinho.depositosFeitos.contains(valor)) {
      porquinho.depositosFeitos.remove(valor);
      porquinho.save();
      notifyListeners();
    }
  }

  // ✏️ EDITAR PORQUINHO
  void editarPorquinho({
    required String id,
    required String nome,
    required int depositoMaximo,
  }) {
    final porquinho = _box.get(id);
    if (porquinho == null) return;

    // 🔒 SE JÁ TEM DEPÓSITOS, NÃO ALTERA DEPÓSITO MÁXIMO
    if (porquinho.depositosFeitos.isNotEmpty) {
      porquinho.nome = nome;
      porquinho.save();
      notifyListeners();
      return;
    }

    // 🧮 RECALCULA META AUTOMATICAMENTE
    final novaMeta = Porquinho.calcularMeta(depositoMaximo);

    porquinho.nome = nome;
    porquinho.depositoMaximo = depositoMaximo;
    porquinho.meta = novaMeta;
    porquinho.save();

    notifyListeners();
  }

  // ❌ EXCLUIR PORQUINHO
  void excluirPorquinho(String id) {
    _box.delete(id);
    notifyListeners();
  }
}
