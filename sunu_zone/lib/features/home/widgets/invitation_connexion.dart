import 'package:flutter/material.dart';
import 'package:sunu_zone/features/auth/connexion_page.dart';
import 'package:sunu_zone/features/auth/inscription_page.dart';

class InvitationConnexion extends StatelessWidget {
  const InvitationConnexion({
    super.key,
    required this.titre,
    required this.message,
  });

  final String titre;
  final String message;

  void _ouvrir(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.lock_outline,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              titre,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => _ouvrir(context, const ConnexionPage()),
              child: const Text('Se connecter'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _ouvrir(context, const InscriptionPage()),
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
