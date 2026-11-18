import '../core/utils/formatters.dart';

enum StatutAnnonce {
  enAttente('En attente'),
  publiee('Publiée'),
  refusee('Refusée'),
  louee('Louée');

  const StatutAnnonce(this.libelle);

  final String libelle;

  /// Retrouve un statut à partir de son nom enregistré ("publiee", ...).
  static StatutAnnonce depuisNom(String? nom) {
    return StatutAnnonce.values.firstWhere(
      (statut) => statut.name == nom,
      orElse: () => StatutAnnonce.enAttente,
    );
  }
}

class Annonce {
  final String id;
  final String type;
  final int nbPieces;
  final int surfaceM2;
  final int prix;
  final String quartier;
  final List<String> images;
  final String description;
  final String proprietaire;
  final String proprietaireId;

  /// Chiffres uniquement, indicatif inclus (ex. 221770000000).
  final String telephone;

  final StatutAnnonce statut;
  final DateTime? dateCreation;

  /// Rempli par l'administrateur quand l'annonce est refusée.
  final String? motifRefus;

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
    this.proprietaireId = '',
    this.statut = StatutAnnonce.enAttente,
    this.dateCreation,
    this.motifRefus,
  });

  /// Construit une annonce à partir d'un document (id + contenu).
  factory Annonce.fromMap(String id, Map<String, dynamic> map) {
    return Annonce(
      id: id,
      type: map['type'] as String? ?? '',
      nbPieces: (map['nbPieces'] as num?)?.toInt() ?? 1,
      surfaceM2: (map['surfaceM2'] as num?)?.toInt() ?? 0,
      prix: (map['prix'] as num?)?.toInt() ?? 0,
      quartier: map['quartier'] as String? ?? '',
      images: List<String>.from(map['images'] as List? ?? const []),
      description: map['description'] as String? ?? '',
      proprietaire: map['proprietaire'] as String? ?? '',
      proprietaireId: map['proprietaireId'] as String? ?? '',
      telephone: map['telephone'] as String? ?? '',
      statut: StatutAnnonce.depuisNom(map['statut'] as String?),
      dateCreation: map['dateCreation'] as DateTime?,
      motifRefus: map['motifRefus'] as String?,
    );
  }

  /// Contenu à enregistrer. L'id (donné par Firestore) et la date
  /// (posée par le serveur) n'en font pas partie.
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'nbPieces': nbPieces,
      'surfaceM2': surfaceM2,
      'prix': prix,
      'quartier': quartier,
      'images': images,
      'description': description,
      'proprietaire': proprietaire,
      'proprietaireId': proprietaireId,
      'telephone': telephone,
      'statut': statut.name,
    };
  }

  /// Champs que le propriétaire a le droit de modifier.
  Map<String, dynamic> toMapContenu() {
    return {
      'type': type,
      'nbPieces': nbPieces,
      'surfaceM2': surfaceM2,
      'prix': prix,
      'quartier': quartier,
      'description': description,
    };
  }

  /// Copie de l'annonce avec quelques champs remplacés.
  Annonce copyWith({
    String? type,
    int? nbPieces,
    int? surfaceM2,
    int? prix,
    String? quartier,
    String? description,
    StatutAnnonce? statut,
  }) {
    return Annonce(
      id: id,
      type: type ?? this.type,
      nbPieces: nbPieces ?? this.nbPieces,
      surfaceM2: surfaceM2 ?? this.surfaceM2,
      prix: prix ?? this.prix,
      quartier: quartier ?? this.quartier,
      images: images,
      description: description ?? this.description,
      proprietaire: proprietaire,
      proprietaireId: proprietaireId,
      telephone: telephone,
      statut: statut ?? this.statut,
      dateCreation: dateCreation,
      motifRefus: motifRefus,
    );
  }

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
