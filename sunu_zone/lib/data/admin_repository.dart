import 'package:sunu_zone/models/annonces.dart';

abstract class AdminRepository {
  /// Vrai si cet utilisateur figure dans la liste des administrateurs.
  Stream<bool> estAdministrateur(String utilisateurId);

  /// Annonces à valider, les plus anciennes d'abord.
  Stream<List<Annonce>> annoncesEnAttente();

  /// Publie l'annonce et efface un éventuel ancien motif de refus.
  Future<void> valider(String annonceId);

  /// Refuse l'annonce avec un motif visible par le propriétaire.
  Future<void> refuser(String annonceId, String motif);
}
