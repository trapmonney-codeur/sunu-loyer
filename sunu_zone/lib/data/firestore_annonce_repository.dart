import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunu_zone/models/annonces.dart';
import 'annonce_repository.dart';
import 'firestore_mapping.dart';

class FirestoreAnnonceRepository implements AnnonceRepository {
  FirestoreAnnonceRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('annonces');

  @override
  Stream<List<Annonce>> annoncesPubliees() {
    return _collection
        .where('statut', isEqualTo: StatutAnnonce.publiee.name)
        .snapshots()
        .map(annoncesDepuisInstantane);
  }

  @override
  Stream<List<Annonce>> annoncesDuProprietaire(String proprietaireId) {
    return _collection
        .where('proprietaireId', isEqualTo: proprietaireId)
        .snapshots()
        .map(annoncesDepuisInstantane);
  }

  @override
  Future<String> publier(Annonce annonce) async {
    final document = await _collection.add({
      ...annonce.toMap(),
      'dateCreation': FieldValue.serverTimestamp(),
    });
    return document.id;
  }

  @override
  Future<void> modifier(Annonce annonce) {
    return _collection.doc(annonce.id).update({
      ...annonce.toMapContenu(),
      'statut': StatutAnnonce.enAttente.name,
    });
  }

  @override
  Future<void> changerStatut(String id, StatutAnnonce statut) {
    return _collection.doc(id).update({'statut': statut.name});
  }

  @override
  Future<void> supprimer(String id) => _collection.doc(id).delete();
}
