String? validerNom(String? valeur) {
  if (valeur == null || valeur.trim().length < 2) {
    return 'Entrez votre nom complet';
  }
  return null;
}

/// Mobile sénégalais : 9 chiffres commençant par 70, 75, 76, 77 ou 78.
/// Les espaces saisis sont tolérés.
String? validerTelephone(String? valeur) {
  final numero = (valeur ?? '').replaceAll(' ', '');
  final estValide = RegExp(r'^(70|75|76|77|78)\d{7}$').hasMatch(numero);
  if (!estValide) {
    return 'Entrez un numéro valide (ex. 77 123 45 67)';
  }
  return null;
}

/// Règle de CRÉATION d'un mot de passe.
String? validerMotDePasse(String? valeur) {
  if (valeur == null || valeur.length < 8) {
    return '8 caractères minimum';
  }
  return null;
}

/// À la CONNEXION, on vérifie seulement que le champ n'est pas vide :
/// la règle des 8 caractères ne concerne que la création.
String? validerMotDePasseSaisi(String? valeur) {
  if (valeur == null || valeur.isEmpty) {
    return 'Entrez votre mot de passe';
  }
  return null;
}

String? validerConfirmation(String? valeur, String motDePasse) {
  if (valeur != motDePasse) {
    return 'Les mots de passe ne correspondent pas';
  }
  return null;
}

String? validerEntierPositif(String? valeur, String message) {
  final nombre = int.tryParse((valeur ?? '').trim());
  if (nombre == null || nombre <= 0) return message;
  return null;
}

String? validerTexteMin(String? valeur, int minimum, String message) {
  if (valeur == null || valeur.trim().length < minimum) return message;
  return null;
}
