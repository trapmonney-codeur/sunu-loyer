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

/// "77 123 45 67" -> "221771234567" (format enregistré et utilisé par WhatsApp)
String normaliserTelephone(String saisie) {
  return '221${saisie.replaceAll(' ', '')}';
}

/// "221771234567" -> "+221 77 123 45 67"
String formaterTelephone(String chiffres) {
  if (chiffres.length != 12 || !chiffres.startsWith('221')) {
    return '+$chiffres';
  }
  final numero = chiffres.substring(3);
  return '+221 ${numero.substring(0, 2)} ${numero.substring(2, 5)} '
      '${numero.substring(5, 7)} ${numero.substring(7)}';
}

/// 15/11/2026 à 14h05
String formaterDate(DateTime date) {
  String deux(int nombre) => nombre.toString().padLeft(2, '0');
  return '${deux(date.day)}/${deux(date.month)}/${date.year} '
      'à ${deux(date.hour)}h${deux(date.minute)}';
}

/// Minuscules et sans accents : "Médina" devient "medina". Sert aux recherches.
String normaliserTexte(String texte) {
  const accents = {
    'à': 'a',
    'â': 'a',
    'ä': 'a',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'î': 'i',
    'ï': 'i',
    'ô': 'o',
    'ö': 'o',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'ç': 'c',
    'œ': 'oe',
  };

  final resultat = StringBuffer();
  for (final lettre in texte.toLowerCase().split('')) {
    resultat.write(accents[lettre] ?? lettre);
  }
  return resultat.toString();
}
