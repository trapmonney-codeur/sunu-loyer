import 'package:flutter/material.dart';
import 'package:sunu_zone/annonce_detail/annonce_detail.dart';
import 'package:sunu_zone/features/home/widgets/etat_vide.dart';
import 'package:sunu_zone/models/annonces.dart';
import '../../../data/depots.dart';
import 'annonce_card.dart';

class ListeAnnonces extends StatefulWidget {
  const ListeAnnonces({super.key});

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

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          itemCount: annonces.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final annonce = annonces[index];
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
