import 'package:flutter/material.dart';
import 'package:porquinho_app/widgets/appbar_padrao.dart';

class PoliticaPrivacidadeScreen extends StatelessWidget {
  const PoliticaPrivacidadeScreen({super.key});

  // 🗓️ Atualize esta data sempre que o texto mudar.
  static const String _ultimaAtualizacao = '10/06/2026';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarPadrao(titulo: 'Política de Privacidade'),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Última atualização: $_ultimaAtualizacao',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 20),

              _paragrafo(
                context,
                'O aplicativo "Meu Porquinho" foi desenvolvido para ajudar você a '
                'organizar seus depósitos e metas de economia. Esta política explica '
                'como suas informações são tratadas.',
              ),

              _titulo(context, '1. Dados que armazenamos'),
              _paragrafo(
                context,
                'Todas as suas caixinhas, depósitos e preferências (como o tema) são '
                'salvos apenas no seu próprio dispositivo. Não enviamos esses dados '
                'para nenhum servidor e não temos acesso a eles.',
              ),

              _titulo(context, '2. Anúncios'),
              _paragrafo(
                context,
                'Este aplicativo exibe anúncios fornecidos pelo Google AdMob. Para isso, '
                'o Google pode coletar e utilizar identificadores do dispositivo a fim de '
                'exibir anúncios e medir seu desempenho. O uso dessas informações é regido '
                'pela Política de Privacidade do Google.',
              ),

              _titulo(context, '3. Dados pessoais'),
              _paragrafo(
                context,
                'O aplicativo não solicita cadastro, login, nome, e-mail ou qualquer dado '
                'pessoal identificável. Não coletamos informações pessoais diretamente.',
              ),

              _titulo(context, '4. Crianças'),
              _paragrafo(
                context,
                'O aplicativo não é direcionado a crianças e não coleta intencionalmente '
                'dados de menores de idade.',
              ),

              _titulo(context, '5. Exclusão de dados'),
              _paragrafo(
                context,
                'Como os dados ficam apenas no seu dispositivo, você pode removê-los a '
                'qualquer momento excluindo as caixinhas dentro do app ou desinstalando o '
                'aplicativo.',
              ),

              _titulo(context, '6. Contato'),
              _paragrafo(
                context,
                'Em caso de dúvidas sobre esta política, entre em contato pelo e-mail: '
                'edytricoloor@gmail.com.',
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titulo(BuildContext context, String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        texto,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _paragrafo(BuildContext context, String texto) {
    return Text(
      texto,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
    );
  }
}
