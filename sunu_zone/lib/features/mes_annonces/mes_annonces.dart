import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sunu_zone/annonce_detail/annonce_detail.dart';
import 'package:sunu_zone/features/home/widgets/annonce_proprietaire_card.dart';
import 'package:sunu_zone/features/home/widgets/etat_vide.dart';
import 'package:sunu_zone/features/home/widgets/invitation_connexion.dart';
import 'package:sunu_zone/features/publier_annonce/publier_annonce_page.dart';
import 'package:sunu_zone/models/annonces.dart';
import '../../data/depots.dart';
import '../../models/utilisateur.dart';

class MesAnnoncesPage extends StatefulWidget {
  const MesAnnoncesPage({super.key});

  @override
  State<MesAnnoncesPage> createState() => _MesAnnoncesPageState();
}

class _MesAnnoncesPageState extends State<MesAnnoncesPage> {
  late final Stream<Utilisateur?> _session = authService.changements;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Utilisateur?>(
      stream: _session,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final utilisateur = snapshot.data;
        if (utilisateur == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Mes annonces')),
            body: const InvitationConnexion(
              titre: 'Connectez-vous pour gérer vos annonces',
              message:
                  'Un compte est nécessaire pour publier '
                  'et suivre vos annonces.',
            ),
          );
        }

        return _MesAnnoncesConnecte(
          key: ValueKey(utilisateur.id),
          utilisateur: utilisateur,
        );
      },
    );
  }
}

class _MesAnnoncesConnecte extends StatefulWidget {
  const _MesAnnoncesConnecte({super.key, required this.utilisateur});

  final Utilisateur utilisateur;

  @override
  State<_MesAnnoncesConnecte> createState() => _MesAnnoncesConnecteState();
}

class _MesAnnoncesConnecteState extends State<_MesAnnoncesConnecte> {
  late final Stream<List<Annonce>> _flux = annonceRepository
      .annoncesDuProprietaire(widget.utilisateur.id);

  void _ouvrir(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  /// Exécute une opération sur Firestore et informe l'utilisateur du résultat.
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
            'Connexion lente : le changement sera appliqué '
            'dès que le réseau reviendra.',
          ),
        ),
      );
    } catch (erreur) {
      debugPrint('Erreur : $erreur');
      messenger.showSnackBar(
        const SnackBar(content: Text("L'opération a échoué. Réessayez.")),
      );
    }
  }

  Future<void> _supprimer(Annonce annonce) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer cette annonce ?'),
        content: Text(
          '« ${annonce.descriptionCourte} · ${annonce.quartier} » '
          'sera supprimée définitivement.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirme != true || !mounted) return;
    await _executer(
      () => annonceRepository.supprimer(annonce.id),
      'Annonce supprimée.',
    );
  }

  void _surAction(Annonce annonce, ActionAnnonce action) {
    switch (action) {
      case ActionAnnonce.modifier:
        _ouvrir(PublierAnnoncePage(annonceAModifier: annonce));
      case ActionAnnonce.marquerLouee:
        _executer(
          () =>
              annonceRepository.changerStatut(annonce.id, StatutAnnonce.louee),
          'Annonce marquée comme louée.',
        );
      case ActionAnnonce.remettreEnLigne:
        _executer(
          () => annonceRepository.changerStatut(
            annonce.id,
            StatutAnnonce.publiee,
          ),
          'Annonce remise en ligne.',
        );
      case ActionAnnonce.supprimer:
        _supprimer(annonce);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes annonces')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ouvrir(const PublierAnnoncePage()),
        icon: const Icon(Icons.add),
        label: const Text('Publier'),
      ),
      body: StreamBuilder<List<Annonce>>(
        stream: _flux,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint('Erreur Firestore : ${snapshot.error}');
            return const EtatVide(
              icone: Icons.cloud_off_outlined,
              titre: 'Impossible de charger vos annonces',
              message: 'Vérifiez votre connexion, puis réessayez plus tard.',
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final annonces = snapshot.data!;
          if (annonces.isEmpty) {
            return const EtatVide(
              icone: Icons.add_home_work_outlined,
              titre: "Vous n'avez pas encore d'annonce",
              message: 'Touchez « Publier » pour créer la première.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: annonces.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final annonce = annonces[index];
              return AnnonceProprietaireCard(
                annonce: annonce,
                onOuvrir: () => _ouvrir(AnnonceDetailPage(annonce: annonce)),
                onAction: (action) => _surAction(annonce, action),
              );
            },
          );
        },
      ),
    );
  }
}
