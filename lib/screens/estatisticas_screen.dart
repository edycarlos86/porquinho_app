import 'package:flutter/material.dart';
import 'package:porquinho_app/widgets/appbar_padrao.dart';
import 'package:provider/provider.dart';

import '../providers/porquinho_provider.dart';
import '../utils/moeda_util.dart';

class EstatisticasScreen extends StatelessWidget {
  const EstatisticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PorquinhoProvider>(context);
    final porquinhos = provider.porquinhos;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final totalGuardado = porquinhos.fold<double>(
      0,
      (soma, p) => soma + p.totalDepositado,
    );

    final concluidas =
        porquinhos.where((p) => p.totalDepositado >= p.meta).length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // 🔝 APPBAR (AGORA RESPEITA O TEMA)
      appBar: const AppBarPadrao(
        titulo: 'Estatísticas',
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _card(
              context,
              titulo: '💰 Total guardado',
              valor: MoedaUtil.formatar(totalGuardado),
              destaque: colors.secondary,
              isDark: isDark,
            ),
            _card(
              context,
              titulo: '🐷 Caixinhas criadas',
              valor: porquinhos.length.toString(),
              destaque: colors.primary,
              isDark: isDark,
            ),
            _card(
              context,
              titulo: '🏆 Caixinhas concluídas',
              valor: concluidas.toString(),
              destaque: Colors.green,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required String titulo,
    required String valor,
    required Color destaque,
    required bool isDark,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            valor,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: destaque,
            ),
          ),
        ],
      ),
    );
  }
}
