import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunu_zone/models/annonces.dart';
import 'annonce_repository.dart';

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
        .map(_versListe);
  }

  @override
  Stream<List<Annonce>> annoncesDuProprietaire(String proprietaireId) {
    return _collection
        .where('proprietaireId', isEqualTo: proprietaireId)
        .snapshots()
        .map(_versListe);
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

  List<Annonce> _versListe(QuerySnapshot<Map<String, dynamic>> instantane) {
    final annonces = instantane.docs.map(_versAnnonce).toList();
    // Tri côté application : le plus récent en premier.
    annonces.sort((a, b) {
      final dateA = a.dateCreation ?? DateTime.now();
      final dateB = b.dateCreation ?? DateTime.now();
      return dateB.compareTo(dateA);
    });
    return annonces;
  }

  Annonce _versAnnonce(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final donnees = document.data();
    final horodatage = donnees['dateCreation'];
    return Annonce.fromMap(document.id, {
      ...donnees,
      'dateCreation': horodatage is Timestamp ? horodatage.toDate() : null,
    });
  }
}
