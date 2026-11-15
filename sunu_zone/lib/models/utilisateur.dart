class Utilisateur {
  const Utilisateur({
    required this.id,
    required this.nom,
    required this.telephone,
  });

  /// Identifiant unique attribué par Firebase.
  final String id;
  final String nom;

  /// Chiffres uniquement, indicatif inclus (ex. 221771234567).
  final String telephone;

  String get nomAffiche => nom.isEmpty ? 'Propriétaire' : nom;

  String get initiale => nomAffiche[0].toUpperCase();
}
