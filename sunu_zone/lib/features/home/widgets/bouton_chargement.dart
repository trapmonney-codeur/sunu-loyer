import 'package:flutter/material.dart';

class BoutonChargement extends StatelessWidget {
  const BoutonChargement({
    super.key,
    required this.texte,
    required this.enChargement,
    required this.onPressed,
  });

  final String texte;
  final bool enChargement;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: enChargement ? null : onPressed,
        child: enChargement
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(texte),
      ),
    );
  }
}
