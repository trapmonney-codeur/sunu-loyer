import 'package:firebase_auth/firebase_auth.dart';
import '../models/utilisateur.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Domaine fictif : l'utilisateur ne voit jamais cette adresse.
  static const _domaine = 'sunuloyer.invalid';

  String _emailDepuis(String telephone) => '$telephone@$_domaine';

  @override
  Utilisateur? get utilisateurCourant => _versUtilisateur(_auth.currentUser);

  @override
  Stream<Utilisateur?> get changements =>
      _auth.userChanges().map(_versUtilisateur);

  @override
  Future<void> seConnecter({
    required String telephone,
    required String motDePasse,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailDepuis(telephone),
        password: motDePasse,
      );
    } on FirebaseAuthException catch (erreur) {
      throw AuthException(_message(erreur.code));
    }
  }

  @override
  Future<void> creerCompte({
    required String nom,
    required String telephone,
    required String motDePasse,
  }) async {
    try {
      final identifiants = await _auth.createUserWithEmailAndPassword(
        email: _emailDepuis(telephone),
        password: motDePasse,
      );
      await identifiants.user?.updateDisplayName(nom);
    } on FirebaseAuthException catch (erreur) {
      throw AuthException(_message(erreur.code));
    }
  }

  @override
  Future<void> seDeconnecter() => _auth.signOut();

  Utilisateur? _versUtilisateur(User? user) {
    if (user == null) return null;
    final email = user.email ?? '';
    return Utilisateur(
      id: user.uid,
      nom: user.displayName ?? '',
      telephone: email.split('@').first,
    );
  }

  String _message(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Ce numéro est déjà inscrit. Connectez-vous.';
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Numéro ou mot de passe incorrect.';
      case 'weak-password':
        return 'Mot de passe trop faible.';
      case 'network-request-failed':
        return 'Pas de connexion internet.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez dans quelques minutes.';
      case 'operation-not-allowed':
        return "La connexion par mot de passe n'est pas activée dans la console Firebase.";
      default:
        return 'Une erreur est survenue ($code).';
    }
  }
}
