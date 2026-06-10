import 'package:flutter/material.dart';
import 'package:porquinho_app/utils/animated_route.dart';
import 'package:provider/provider.dart';

import '../providers/porquinho_provider.dart';
import 'criar_porquinho_screen.dart';
import 'porquinho_detalhe_screen.dart';
import 'editar_porquinho_screen.dart';
import 'estatisticas_screen.dart';
import 'configuracoes_screen.dart';
import '../widgets/progresso_circular.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fabScale = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeOutCubic,
    );

    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PorquinhoProvider>(context);
    final porquinhos = provider.porquinhos;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      // ❌ remove cor fixa
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,



      // 🔝 APPBAR FINTECH (ADAPTÁVEL)
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.primary,
        centerTitle: true,
        title: const Text(
          'Minhas Caixinhas',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // ⚙️ CONFIGURAÇÕES
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configurações',
            onPressed: () {
              Navigator.push(
                context,
                animatedRoute(const ConfiguracoesScreen()),
              );
            },
          ),

          // 📊 ESTATÍSTICAS
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Estatísticas',
            onPressed: () {
              Navigator.push(
                context,
                animatedRoute(const EstatisticasScreen()),
              );
            },
          ),
        ],
      ),

      // 📄 BODY
      body: porquinhos.isEmpty
          ? Center(
              child: Text(
                'Nenhuma caixinha criada',
                style: theme.textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: porquinhos.length,
              itemBuilder: (context, index) {
                final p = porquinhos[index];
                final concluida = p.totalDepositado >= p.meta;

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      animatedRoute(
                        PorquinhoDetalheScreen(
                          porquinhoId: p.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        if (theme.brightness == Brightness.light)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 🔵 HERO + PROGRESSO
                        Hero(
                          tag: 'porquinho_${p.id}',
                          child: ProgressoCircular(
                            progresso: p.progresso,
                            valorAtual: p.totalDepositado,
                            meta: p.meta,
                            size: 90,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // 🔵 INFORMAÇÕES
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      p.nome,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'editar') {
                                        Navigator.push(
                                          context,
                                          animatedRoute(
                                            EditarPorquinhoScreen(
                                              porquinhoId: p.id,
                                            ),
                                          ),
                                        );
                                      } else if (value == 'excluir') {
                                        _confirmarExclusao(
                                            context, provider, p.id);
                                      }
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                        value: 'editar',
                                        child: Text('Editar'),
                                      ),
                                      PopupMenuItem(
                                        value: 'excluir',
                                        child: Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              if (concluida)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    '🏆 Concluída',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                              Text(
                                'Depósitos de 1 até ${p.depositoMaximo}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // ➕ FAB ANIMADO
      floatingActionButton: ScaleTransition(
        scale: _fabScale,
        child: FloatingActionButton(
          heroTag: 'fabHome',
          backgroundColor: colors.primary,
          onPressed: () {
            Navigator.push(
              context,
              animatedRoute(const CriarPorquinhoScreen()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // =========================
  // ❗ CONFIRMAÇÃO EXCLUSÃO
  // =========================
  void _confirmarExclusao(
    BuildContext context,
    PorquinhoProvider provider,
    String porquinhoId,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir caixinha'),
        content:
            const Text('Tem certeza que deseja excluir esta caixinha?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.excluirPorquinho(porquinhoId);
              Navigator.pop(context);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
