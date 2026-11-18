import 'package:flutter/material.dart';
import 'package:sunu_zone/core/constants/types_logement.dart';
import 'package:sunu_zone/core/utils/formatters.dart';
import 'package:sunu_zone/models/filtres_annonces.dart';

/// Ouvre la feuille de filtres. Renvoie les nouveaux filtres, ou null si fermée.
Future<FiltresAnnonces?> ouvrirFeuilleFiltres(
  BuildContext context,
  FiltresAnnonces actuels,
) {
  return showModalBottomSheet<FiltresAnnonces>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _FeuilleFiltres(actuels: actuels),
  );
}

class _FeuilleFiltres extends StatefulWidget {
  const _FeuilleFiltres({required this.actuels});

  final FiltresAnnonces actuels;

  @override
  State<_FeuilleFiltres> createState() => _FeuilleFiltresState();
}

class _FeuilleFiltresState extends State<_FeuilleFiltres> {
  static const _budgets = [50000, 100000, 200000, 300000, 500000];
  static const _pieces = [1, 2, 3, 4];

  late String? _type = widget.actuels.type;
  late int? _prixMax = widget.actuels.prixMax;
  late int? _piecesMin = widget.actuels.piecesMin;
  late TriAnnonces _tri = widget.actuels.tri;

  void _reinitialiser() {
    setState(() {
      _type = null;
      _prixMax = null;
      _piecesMin = null;
      _tri = TriAnnonces.recentes;
    });
  }

  void _appliquer() {
    Navigator.of(context).pop(
      FiltresAnnonces(
        texte: widget.actuels.texte,
        type: _type,
        prixMax: _prixMax,
        piecesMin: _piecesMin,
        tri: _tri,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Filtres',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _reinitialiser,
                  child: const Text('Réinitialiser'),
                ),
              ],
            ),
            const _Titre('Type de logement'),
            _Puces<String>(
              valeurs: [null, ...typesLogement],
              selection: _type,
              libelle: (valeur) => valeur ?? 'Tous',
              onChange: (valeur) => setState(() => _type = valeur),
            ),
            const _Titre('Loyer maximum (FCFA / mois)'),
            _Puces<int>(
              valeurs: [null, ..._budgets],
              selection: _prixMax,
              libelle: (valeur) =>
                  valeur == null ? 'Tous' : '≤ ${formaterMilliers(valeur)}',
              onChange: (valeur) => setState(() => _prixMax = valeur),
            ),
            const _Titre('Nombre de pièces (minimum)'),
            _Puces<int>(
              valeurs: [null, ..._pieces],
              selection: _piecesMin,
              libelle: (valeur) => valeur == null ? 'Toutes' : '$valeur+',
              onChange: (valeur) => setState(() => _piecesMin = valeur),
            ),
            const _Titre('Trier par'),
            _Puces<TriAnnonces>(
              valeurs: TriAnnonces.values,
              selection: _tri,
              libelle: (valeur) => valeur?.libelle ?? '',
              onChange: (valeur) {
                setState(() => _tri = valeur ?? TriAnnonces.recentes);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _appliquer,
                child: const Text('Afficher les résultats'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Titre extends StatelessWidget {
  const _Titre(this.texte);

  final String texte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        texte,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Une rangée de puces à choix unique. La valeur `null` représente « Tous ».
class _Puces<T> extends StatelessWidget {
  const _Puces({
    required this.valeurs,
    required this.selection,
    required this.libelle,
    required this.onChange,
  });

  final List<T?> valeurs;
  final T? selection;
  final String Function(T?) libelle;
  final ValueChanged<T?> onChange;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: valeurs
          .map(
            (valeur) => ChoiceChip(
              label: Text(libelle(valeur)),
              selected: valeur == selection,
              onSelected: (_) => onChange(valeur),
            ),
          )
          .toList(),
    );
  }
}
