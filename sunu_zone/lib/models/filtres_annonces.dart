import 'package:sunu_zone/core/utils/formatters.dart';
import 'package:sunu_zone/models/annonces.dart';

enum TriAnnonces {
  recentes('Plus récentes'),
  prixCroissant('Prix croissant'),
  prixDecroissant('Prix décroissant');

  const TriAnnonces(this.libelle);

  final String libelle;
}

class FiltresAnnonces {
  const FiltresAnnonces({
    this.texte = '',
    this.type,
    this.prixMax,
    this.piecesMin,
    this.tri = TriAnnonces.recentes,
  });

  final String texte;
  final String? type;
  final int? prixMax;
  final int? piecesMin;
  final TriAnnonces tri;

  /// Nombre de filtres actifs (la recherche par texte n'est pas comptée).
  int get nombreActifs =>
      (type != null ? 1 : 0) +
      (prixMax != null ? 1 : 0) +
      (piecesMin != null ? 1 : 0) +
      (tri != TriAnnonces.recentes ? 1 : 0);

  bool get aucunCritere => texte.trim().isEmpty && nombreActifs == 0;

  /// Même filtres, avec un nouveau texte de recherche.
  FiltresAnnonces avecTexte(String nouveauTexte) {
    return FiltresAnnonces(
      texte: nouveauTexte,
      type: type,
      prixMax: prixMax,
      piecesMin: piecesMin,
      tri: tri,
    );
  }

  /// Applique la recherche, les filtres et le tri à une liste d'annonces.
  List<Annonce> appliquer(List<Annonce> annonces) {
    final mots = normaliserTexte(
      texte.trim(),
    ).split(' ').where((mot) => mot.isNotEmpty).toList();

    final resultat = annonces.where((annonce) {
      if (type != null && annonce.type != type) return false;
      if (prixMax != null && annonce.prix > prixMax!) return false;
      if (piecesMin != null && annonce.nbPieces < piecesMin!) return false;

      if (mots.isNotEmpty) {
        final contenu = normaliserTexte(
          '${annonce.quartier} ${annonce.type} ${annonce.description}',
        );
        if (!mots.every(contenu.contains)) return false;
      }
      return true;
    }).toList();

    switch (tri) {
      case TriAnnonces.recentes:
        break; // la liste reçue est déjà triée du plus récent au plus ancien
      case TriAnnonces.prixCroissant:
        resultat.sort((a, b) => a.prix.compareTo(b.prix));
      case TriAnnonces.prixDecroissant:
        resultat.sort((a, b) => b.prix.compareTo(a.prix));
    }
    return resultat;
  }
}
