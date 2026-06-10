import 'package:flutter/material.dart';
import 'package:porquinho_app/widgets/appbar_padrao.dart';
import 'package:provider/provider.dart';

import '../models/porquinho_model.dart';
import '../providers/porquinho_provider.dart';
import '../utils/moeda_util.dart';

class CriarPorquinhoScreen extends StatefulWidget {
  const CriarPorquinhoScreen({super.key});

  @override
  State<CriarPorquinhoScreen> createState() =>
      _CriarPorquinhoScreenState();
}

class _CriarPorquinhoScreenState extends State<CriarPorquinhoScreen> {
  final _nomeController = TextEditingController();
  final _depositoController = TextEditingController();

  double? _metaPreview;

  void _calcularMetaPreview() {
    final depositoMax = int.tryParse(_depositoController.text);
    if (depositoMax != null && depositoMax > 0) {
      setState(() {
        _metaPreview = Porquinho.calcularMeta(depositoMax);
      });
    } else {
      setState(() {
        _metaPreview = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<PorquinhoProvider>(context, listen: false);

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // 🔝 APPBAR (RESPEITA O TEMA)
      appBar: const AppBarPadrao(
        titulo: 'Criar Caixinha',
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 NOME
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),

            const SizedBox(height: 12),

            // 🔢 DEPÓSITO MÁXIMO
            TextField(
              controller: _depositoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Depósito máximo',
                helperText:
                    'Ex: 50, 100, 200 (depósitos de 1 até esse valor)',
              ),
              onChanged: (_) => _calcularMetaPreview(),
            ),

            const SizedBox(height: 16),

            // 📊 PREVIEW DA META
            if (_metaPreview != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.cardColor
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calculate,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Meta calculada: ${MoedaUtil.formatar(_metaPreview!)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const Spacer(),

// ✅ BOTÃO CRIAR
Padding(
  padding: const EdgeInsets.only(bottom: 24), // 👈 margem inferior
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        provider.adicionarPorquinho(
          _nomeController.text,
          int.parse(_depositoController.text),
        );
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text(
        'Criar Caixinha',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
