import '../core/utils/formatters.dart';

class Annonce {
  final String id;
  final String type;
  final int nbPieces;
  final int surfaceM2;
  final int prix;
  final String quartier;

  /// Au moins une photo. La première sert de couverture.
  final List<String> images;

  final String description;
  final String proprietaire;

  /// Chiffres uniquement, indicatif inclus (ex. 221770000000).
  final String telephone;

  const Annonce({
    required this.id,
    required this.type,
    required this.nbPieces,
    required this.surfaceM2,
    required this.prix,
    required this.quartier,
    required this.images,
    required this.description,
    required this.proprietaire,
    required this.telephone,
  });

  /// Photo affichée sur la carte de l'accueil.
  String get imageCouverture => images.isEmpty ? '' : images.first;

  /// "350 000 FCFA / mois"
  String get prixAffiche => '${formaterMilliers(prix)} FCFA / mois';

  /// "Appartement · 3 pièces"
  String get descriptionCourte {
    final pieces = nbPieces > 1 ? 'pièces' : 'pièce';
    return '$type · $nbPieces $pieces';
  }

  /// Première lettre du nom, pour l'avatar.
  String get initialeProprietaire =>
      proprietaire.isEmpty ? '?' : proprietaire[0].toUpperCase();
}
