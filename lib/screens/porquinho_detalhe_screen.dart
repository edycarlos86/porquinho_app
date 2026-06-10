import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import '../ads/ads_service.dart';
import '../providers/porquinho_provider.dart';
import '../widgets/progresso_circular.dart';
import '../utils/moeda_util.dart';

class PorquinhoDetalheScreen extends StatefulWidget {
  final String porquinhoId;

  const PorquinhoDetalheScreen({
    super.key,
    required this.porquinhoId,
  });

  @override
  State<PorquinhoDetalheScreen> createState() =>
      _PorquinhoDetalheScreenState();
}

class _PorquinhoDetalheScreenState
    extends State<PorquinhoDetalheScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;

  // 🔢 +R$ animado
  late AnimationController _valorAnimadoController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  OverlayEntry? _overlayEntry;

  // 🎯 PULSO NO PROGRESSO
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    // +R$
    _valorAnimadoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _valorAnimadoController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.6),
    ).animate(
      CurvedAnimation(
        parent: _valorAnimadoController,
        curve: Curves.easeOutCubic,
      ),
    );

    // 🔥 PULSO
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _valorAnimadoController.dispose();
    _pulseController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  /// 🔥 INTERSTITIAL
  void _onConcluirCaixinha() {
    Future.delayed(const Duration(seconds: 3), () {
      AdsService.instance.showInterstitial(onFinished: () {});
    });
  }

  // =========================
  // 🔢 +R$ ANIMADO
  // =========================
  void _mostrarValorAnimado(BuildContext context, int valor) {
    final overlay = Overlay.of(context);

    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: MediaQuery.of(context).size.height * 0.28,
        left: 0,
        right: 0,
        child: IgnorePointer(
          child: Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    '+ R\$ $valor',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);

    _valorAnimadoController.forward(from: 0).whenComplete(() {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PorquinhoProvider>(context);
    final porquinho = provider.getById(widget.porquinhoId);

    // 🛡️ Caixinha excluída enquanto a tela estava aberta: evita crash.
    if (porquinho == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        centerTitle: true,
        title: Text(
          porquinho.nome,
          style: theme.appBarTheme.titleTextStyle,
        ),
        iconTheme: theme.appBarTheme.iconTheme,
      ),

      body: Stack(
        children: [
          Column(
            children: [
              // 🔵 PROGRESSO COM PULSO
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Center(
                  child: Hero(
                    tag: 'porquinho_${porquinho.id}',
                    child: ScaleTransition(
                      scale: _pulseAnimation,
                      child: ProgressoCircular(
                        progresso: porquinho.progresso,
                        valorAtual: porquinho.totalDepositado,
                        meta: porquinho.meta,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🔵 GRID
Expanded(
  child: GridView.builder(
    padding: const EdgeInsets.fromLTRB(
      16, // esquerda
      16, // topo
      16, // direita
      32, // 👈 fundo (respiro)
    ),
    itemCount: porquinho.depositoMaximo,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final valor = index + 1;
                    final feito =
                        porquinho.depositosFeitos.contains(valor);

                    final bgColor =
                        feito ? colors.secondary : theme.cardColor;

                    final textColor =
                        feito ? Colors.white : theme.textTheme.bodyMedium!.color;

                    return GestureDetector(
                      onTap: () {
                        if (feito) {
                          _confirmarDesfazer(
                              context, provider, porquinho.id, valor);
                        } else {
                          final concluido =
                              provider.adicionarDeposito(
                                  porquinho.id, valor);

                          _pulseController.forward(from: 0);
                          _mostrarValorAnimado(context, valor);

                          if (concluido) {
                            _confettiController.play();
                            _mostrarDialogoConclusao(context);
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '$valor',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // 🎉 CONFETTI
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality:
                  BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.pink,
                Colors.blue,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  void _confirmarDesfazer(
    BuildContext context,
    PorquinhoProvider provider,
    String porquinhoId,
    int valor,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Desfazer depósito'),
        content: Text(
          'Deseja desfazer o depósito de ${MoedaUtil.formatar(valor.toDouble())}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.removerDeposito(porquinhoId, valor);
              Navigator.pop(context);
            },
            child: const Text(
              'Desfazer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoConclusao(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('🎉 Parabéns!'),
        content: const Text('Você concluiu esta caixinha!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _onConcluirCaixinha();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
