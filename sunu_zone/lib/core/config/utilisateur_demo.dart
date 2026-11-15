class UtilisateurDemo {
  const UtilisateurDemo({
    required this.id,
    required this.nom,
    required this.telephone,
  });

  final String id;
  final String nom;
  final String telephone;
}

/// Remplacé à l'étape 6 par le vrai utilisateur connecté.
const utilisateurDemo = UtilisateurDemo(
  id: 'utilisateur-demo',
  nom: 'Awa Diallo',
  telephone: '221770000001',
);
