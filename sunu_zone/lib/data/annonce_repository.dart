import 'package:sunu_zone/models/annonces.dart';

abstract class AnnonceRepository {
  /// Annonces visibles par tous (statut « publiée »), les plus récentes d'abord.
  Stream<List<Annonce>> annoncesPubliees();

  /// Toutes les annonces d'un propriétaire, tous statuts confondus.
  Stream<List<Annonce>> annoncesDuProprietaire(String proprietaireId);

  /// Enregistre une nouvelle annonce et renvoie son identifiant.
  Future<String> publier(Annonce annonce);

  /// Met à jour le contenu d'une annonce ; elle repasse « en attente ».
  Future<void> modifier(Annonce annonce);

  /// Change le statut (marquer comme louée, remettre en ligne).
  Future<void> changerStatut(String id, StatutAnnonce statut);

  /// Supprime définitivement une annonce.
  Future<void> supprimer(String id);
}
