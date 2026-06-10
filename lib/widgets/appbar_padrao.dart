import 'package:flutter/material.dart';

class AppBarPadrao extends StatelessWidget
    implements PreferredSizeWidget {
  final String titulo;

  /// Opcional: se não informar, usa o tema
  final Color? cor;

  final List<Widget>? actions;
  final bool centerTitle;

  const AppBarPadrao({
    super.key,
    required this.titulo,
    this.cor,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    return AppBar(
      // 🔑 Se passar cor, usa. Senão, usa o tema
      backgroundColor: cor ?? appBarTheme.backgroundColor,
      elevation: appBarTheme.elevation ?? 0,
      centerTitle: centerTitle,

      // 🎨 ÍCONES ADAPTÁVEIS
      iconTheme:
          appBarTheme.iconTheme ?? const IconThemeData(color: Colors.white),

      // 📝 TEXTO ADAPTÁVEL
      titleTextStyle: appBarTheme.titleTextStyle ??
          theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),

      title: Text(titulo),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
