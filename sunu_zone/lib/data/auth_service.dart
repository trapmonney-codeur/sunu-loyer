import '../models/utilisateur.dart';

abstract class AuthService {
  /// L'utilisateur connecté à cet instant, ou null.
  Utilisateur? get utilisateurCourant;

  /// Émet une valeur à chaque connexion, déconnexion ou changement de profil.
  Stream<Utilisateur?> get changements;

  Future<void> seConnecter({
    required String telephone,
    required String motDePasse,
  });

  Future<void> creerCompte({
    required String nom,
    required String telephone,
    required String motDePasse,
  });

  Future<void> seDeconnecter();
}

/// Erreur d'authentification avec un message prêt à afficher.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
