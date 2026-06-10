import 'package:flutter/material.dart';
import 'package:porquinho_app/widgets/appbar_padrao.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils/animated_route.dart';
import 'politica_privacidade_screen.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarPadrao(titulo: 'Configurações'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🎨 APARÊNCIA
          _secao(context, 'Aparência'),
          RadioGroup<ThemeMode>(
            groupValue: themeProvider.themeMode,
            onChanged: (mode) {
              switch (mode) {
                case ThemeMode.light:
                  themeProvider.setLight();
                  break;
                case ThemeMode.dark:
                  themeProvider.setDark();
                  break;
                case ThemeMode.system:
                case null:
                  themeProvider.setSystem();
                  break;
              }
            },
            child: Column(
              children: const [
                RadioListTile<ThemeMode>(
                  title: Text('Sistema'),
                  secondary: Icon(Icons.phone_android),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text('Claro'),
                  secondary: Icon(Icons.light_mode),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: Text('Escuro'),
                  secondary: Icon(Icons.dark_mode),
                  value: ThemeMode.dark,
                ),
              ],
            ),
          ),

          const Divider(height: 32),

          // ℹ️ SOBRE
          _secao(context, 'Sobre'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Política de Privacidade'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                animatedRoute(const PoliticaPrivacidadeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _secao(BuildContext context, String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 4),
      child: Text(
        titulo,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
