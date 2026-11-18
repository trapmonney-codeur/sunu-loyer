import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunu_zone/models/annonces.dart';
import 'admin_repository.dart';
import 'firestore_mapping.dart';

class FirestoreAdminRepository implements AdminRepository {
  FirestoreAdminRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _annonces =>
      _firestore.collection('annonces');

  @override
  Stream<bool> estAdministrateur(String utilisateurId) {
    return _firestore
        .collection('admins')
        .doc(utilisateurId)
        .snapshots()
        .map((document) => document.exists);
  }

  @override
  Stream<List<Annonce>> annoncesEnAttente() {
    return _annonces
        .where('statut', isEqualTo: StatutAnnonce.enAttente.name)
        .snapshots()
        .map((instantane) {
          // La conversion trie les plus récentes d'abord : on inverse.
          return annoncesDepuisInstantane(instantane).reversed.toList();
        });
  }

  @override
  Future<void> valider(String annonceId) {
    return _annonces.doc(annonceId).update({
      'statut': StatutAnnonce.publiee.name,
      'motifRefus': FieldValue.delete(),
    });
  }

  @override
  Future<void> refuser(String annonceId, String motif) {
    return _annonces.doc(annonceId).update({
      'statut': StatutAnnonce.refusee.name,
      'motifRefus': motif.trim(),
    });
  }
}
