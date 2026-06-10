import 'package:flutter/material.dart';
import 'package:porquinho_app/widgets/appbar_padrao.dart';
import 'package:provider/provider.dart';

import '../models/porquinho_model.dart';
import '../providers/porquinho_provider.dart';

class EditarPorquinhoScreen extends StatefulWidget {
  final String porquinhoId;

  const EditarPorquinhoScreen({
    super.key,
    required this.porquinhoId,
  });

  @override
  State<EditarPorquinhoScreen> createState() =>
      _EditarPorquinhoScreenState();
}

class _EditarPorquinhoScreenState extends State<EditarPorquinhoScreen> {
  final _nomeController = TextEditingController();
  final _metaController = TextEditingController();
  final _depositoController = TextEditingController();

  bool _temDepositos = false;

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<PorquinhoProvider>(context, listen: false);
    final porquinho = provider.getById(widget.porquinhoId);

    // 🛡️ Caixinha já não existe: fecha a tela com segurança.
    if (porquinho == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return;
    }

    _temDepositos = porquinho.depositosFeitos.isNotEmpty;

    _nomeController.text = porquinho.nome;
    _depositoController.text =
        porquinho.depositoMaximo.toString();

    _metaController.text =
        Porquinho.calcularMeta(porquinho.depositoMaximo)
            .toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<PorquinhoProvider>(context, listen: false);

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // 🔝 APPBAR (RESPEITA O TEMA)
      appBar: const AppBarPadrao(
        titulo: 'Editar Caixinha',
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
              enabled: !_temDepositos,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Depósito máximo',
                helperText: _temDepositos
                    ? '⚠️ Não é possível alterar após iniciar os depósitos'
                    : 'Ex: 50, 100, 200 (depósitos de 1 até esse valor)',
              ),
              onChanged: _temDepositos
                  ? null
                  : (value) {
                      final depositoMaximo =
                          int.tryParse(value) ?? 0;

                      setState(() {
                        _metaController.text =
                            Porquinho.calcularMeta(depositoMaximo)
                                .toStringAsFixed(0);
                      });
                    },
            ),

            const SizedBox(height: 12),

            // 🔒 META (SEMPRE BLOQUEADA)
            TextField(
              controller: _metaController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Meta calculada',
                prefixText: 'R\$ ',
              ),
            ),

            const Spacer(),

           // 💾 SALVAR
Padding(
  padding: const EdgeInsets.only(bottom: 24), // 👈 margem inferior
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        final depositoMaximo =
            int.parse(_depositoController.text);

        provider.editarPorquinho(
          id: widget.porquinhoId,
          nome: _nomeController.text,
          depositoMaximo: depositoMaximo,
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
        'Salvar alterações',
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
