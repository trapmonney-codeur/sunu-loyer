import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunu_zone/models/annonces.dart';

/// Convertit un document Firestore en [Annonce].
Annonce annonceDepuisDocument(
  QueryDocumentSnapshot<Map<String, dynamic>> document,
) {
  final donnees = document.data();
  final horodatage = donnees['dateCreation'];
  return Annonce.fromMap(document.id, {
    ...donnees,
    'dateCreation': horodatage is Timestamp ? horodatage.toDate() : null,
  });
}

/// Convertit un résultat de requête en liste, les plus récentes d'abord.
List<Annonce> annoncesDepuisInstantane(
  QuerySnapshot<Map<String, dynamic>> instantane,
) {
  final annonces = instantane.docs.map(annonceDepuisDocument).toList();
  annonces.sort((a, b) {
    final dateA = a.dateCreation ?? DateTime.now();
    final dateB = b.dateCreation ?? DateTime.now();
    return dateB.compareTo(dateA);
  });
  return annonces;
}
