import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sunu_zone/annonce_detail/annonce_detail.dart';
import 'package:sunu_zone/data/depots.dart';
import 'package:sunu_zone/features/home/widgets/etat_vide.dart';
import 'package:sunu_zone/models/annonces.dart';
import 'widgets/carte_moderation.dart';
import 'widgets/dialogue_refus.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late final Stream<bool> _estAdmin;

  @override
  void initState() {
    super.initState();
    final utilisateur = authService.utilisateurCourant;
    _estAdmin = utilisateur == null
        ? Stream.value(false)
        : adminRepository.estAdministrateur(utilisateur.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administration')),
      body: StreamBuilder<bool>(
        stream: _estAdmin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data != true) {
            return const EtatVide(
              icone: Icons.lock_outline,
              titre: 'Accès réservé aux administrateurs',
            );
          }
          return const _FileModeration();
        },
      ),
    );
  }
}

class _FileModeration extends StatefulWidget {
  const _FileModeration();

  @override
  State<_FileModeration> createState() => _FileModerationState();
}

class _FileModerationState extends State<_FileModeration> {
  late final Stream<List<Annonce>> _flux = adminRepository.annoncesEnAttente();

  void _voirDetail(Annonce annonce) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AnnonceDetailPage(annonce: annonce)),
    );
  }

  Future<void> _executer(
    Future<void> Function() action,
    String messageSucces,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action().timeout(const Duration(seconds: 15));
      messenger.showSnackBar(SnackBar(content: Text(messageSucces)));
    } on TimeoutException {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Connexion lente : la décision sera enregistrée '
            'dès que le réseau reviendra.',
          ),
        ),
      );
    } catch (erreur) {
      debugPrint('Erreur de modération : $erreur');
      messenger.showSnackBar(
        const SnackBar(content: Text("L'opération a échoué. Réessayez.")),
      );
    }
  }

  Future<void> _valider(Annonce annonce) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Valider cette annonce ?'),
        content: const Text('Elle sera visible par tous les visiteurs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Valider'),
          ),
        ],
      ),
    );

    if (confirme != true || !mounted) return;
    await _executer(
      () => adminRepository.valider(annonce.id),
      'Annonce validée.',
    );
  }

  Future<void> _refuser(Annonce annonce) async {
    final motif = await demanderMotifRefus(context);
    if (motif == null || !mounted) return;
    await _executer(
      () => adminRepository.refuser(annonce.id, motif),
      'Annonce refusée.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<Annonce>>(
      stream: _flux,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('Erreur Firestore : ${snapshot.error}');
          return const EtatVide(
            icone: Icons.cloud_off_outlined,
            titre: 'Impossible de charger les annonces',
            message: 'Vérifiez votre connexion, puis réessayez plus tard.',
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final annonces = snapshot.data!;
        if (annonces.isEmpty) {
          return const EtatVide(
            icone: Icons.task_alt_outlined,
            titre: 'Aucune annonce à valider',
            message: 'Les nouvelles annonces apparaîtront ici.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: annonces.length + 1,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Text(
                '${annonces.length} annonce${annonces.length > 1 ? 's' : ''} '
                'en attente de validation',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              );
            }

            final annonce = annonces[index - 1];
            return CarteModeration(
              annonce: annonce,
              onVoir: () => _voirDetail(annonce),
              onValider: () => _valider(annonce),
              onRefuser: () => _refuser(annonce),
            );
          },
        );
      },
    );
  }
}
