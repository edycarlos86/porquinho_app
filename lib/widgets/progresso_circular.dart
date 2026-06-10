import 'package:flutter/material.dart';
import '../utils/moeda_util.dart';

class ProgressoCircular extends StatelessWidget {
  final double progresso; // 0.0 a 1.0
  final double valorAtual;
  final double meta;
  final double size;

  const ProgressoCircular({
    super.key,
    required this.progresso,
    required this.valorAtual,
    required this.meta,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progresso.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        final percentual = (value * 100).clamp(0, 100);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 🔵 ARCO
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: size * 0.08,

                  // 👉 FUNDO DO ARCO (ADAPTA AO TEMA)
                  backgroundColor: theme.brightness == Brightness.dark
                      ? Colors.white12
                      : Colors.grey.shade300,

                  // 👉 COR DO PROGRESSO
                  color: colors.secondary,
                ),
              ),

              // 🔵 TEXTO CENTRAL
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 💰 VALOR ATUAL
                  Text(
                    MoedaUtil.formatar(valorAtual),
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: size * 0.14,
                      fontWeight: FontWeight.w700,
                      color: textTheme.titleMedium?.color,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // 🎯 META
                  Text(
                    'de ${MoedaUtil.formatar(meta)}',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: size * 0.07,
                      color: textTheme.bodySmall?.color,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // 📊 PERCENTUAL
                  Text(
                    '${percentual.toStringAsFixed(1)}%',
                    style: textTheme.titleSmall?.copyWith(
                      fontSize: size * 0.09,
                      fontWeight: FontWeight.bold,
                      color: percentual >= 100
                          ? Colors.green
                          : colors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
