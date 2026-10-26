/// Transforme 350000 en "350 000".
String formaterMilliers(int valeur) {
  final texte = valeur.toString();
  final resultat = StringBuffer();

  for (var i = 0; i < texte.length; i++) {
    final chiffresRestants = texte.length - i;
    if (i > 0 && chiffresRestants % 3 == 0) {
      resultat.write(' ');
    }
    resultat.write(texte[i]);
  }

  return resultat.toString();
}
