import 'package:flutter/material.dart';
import 'package:sunu_zone/annonce_detail/annonce_detail.dart';
import 'package:sunu_zone/data/depots.dart';
import 'package:sunu_zone/features/home/widgets/etat_vide.dart';
import 'package:sunu_zone/models/annonces.dart';
import 'package:sunu_zone/models/filtres_annonces.dart';
import 'annonce_card.dart';

class ListeAnnonces extends StatefulWidget {
  const ListeAnnonces({
    super.key,
    required this.filtres,
    required this.onReinitialiser,
  });

  final FiltresAnnonces filtres;
  final VoidCallback onReinitialiser;

  @override
  State<ListeAnnonces> createState() => _ListeAnnoncesState();
}

class _ListeAnnoncesState extends State<ListeAnnonces> {
  late Stream<List<Annonce>> _flux;

  @override
  void initState() {
    super.initState();
    _flux = annonceRepository.annoncesPubliees();
  }

  void _recharger() {
    setState(() => _flux = annonceRepository.annoncesPubliees());
  }

  void _ouvrirDetail(Annonce annonce) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AnnonceDetailPage(annonce: annonce)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Annonce>>(
      stream: _flux,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('Erreur Firestore : ${snapshot.error}');
          return EtatVide(
            icone: Icons.cloud_off_outlined,
            titre: 'Impossible de charger les annonces',
            message: 'Vérifiez votre connexion, puis réessayez.',
            libelleAction: 'Réessayer',
            onAction: _recharger,
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final annonces = snapshot.data!;
        if (annonces.isEmpty) {
          return const EtatVide(
            icone: Icons.home_work_outlined,
            titre: 'Aucune annonce pour le moment',
            message: 'Les nouvelles annonces apparaîtront ici.',
          );
        }

        final affichees = widget.filtres.appliquer(annonces);
        if (affichees.isEmpty) {
          return EtatVide(
            icone: Icons.search_off,
            titre: 'Aucun résultat',
            message: 'Essayez d\'autres mots ou retirez un filtre.',
            libelleAction: 'Réinitialiser les filtres',
            onAction: widget.onReinitialiser,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          itemCount: affichees.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final annonce = affichees[index];
            return AnnonceCard(
              annonce: annonce,
              onTap: () => _ouvrirDetail(annonce),
            );
          },
        );
      },
    );
  }
}
