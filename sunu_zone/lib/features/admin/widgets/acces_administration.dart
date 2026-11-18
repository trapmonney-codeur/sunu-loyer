import 'package:flutter/material.dart';
import 'package:sunu_zone/data/depots.dart';
import '../admin_page.dart';

/// Affiche le bouton « Administration » seulement pour un administrateur.
class AccesAdministration extends StatefulWidget {
  const AccesAdministration({super.key, required this.utilisateurId});

  final String utilisateurId;

  @override
  State<AccesAdministration> createState() => _AccesAdministrationState();
}

class _AccesAdministrationState extends State<AccesAdministration> {
  late final Stream<bool> _flux = adminRepository.estAdministrateur(
    widget.utilisateurId,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _flux,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FilledButton.tonalIcon(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AdminPage()));
            },
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: const Text('Administration'),
          ),
        );
      },
    );
  }
}
