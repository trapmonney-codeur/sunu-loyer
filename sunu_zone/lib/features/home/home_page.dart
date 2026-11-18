import 'package:flutter/material.dart';
import 'package:sunu_zone/models/filtres_annonces.dart';
import 'widgets/feuille_filtres.dart';
import 'widgets/liste_annonces.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _rechercheController = TextEditingController();
  FiltresAnnonces _filtres = const FiltresAnnonces();

  @override
  void dispose() {
    _rechercheController.dispose();
    super.dispose();
  }

  void _surRecherche(String texte) {
    setState(() => _filtres = _filtres.avecTexte(texte));
  }

  Future<void> _ouvrirFiltres() async {
    final resultat = await ouvrirFeuilleFiltres(context, _filtres);
    if (resultat == null || !mounted) return;
    setState(() => _filtres = resultat);
  }

  void _reinitialiser() {
    _rechercheController.clear();
    setState(() => _filtres = const FiltresAnnonces());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final couleurs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'sunu loyer',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: couleurs.primary,
                        ),
                      ),
                      Badge(
                        isLabelVisible: _filtres.nombreActifs > 0,
                        label: Text('${_filtres.nombreActifs}'),
                        child: IconButton.filledTonal(
                          tooltip: 'Filtres',
                          onPressed: _ouvrirFiltres,
                          icon: const Icon(Icons.tune),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rechercher un logement',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _rechercheController,
                    onChanged: _surRecherche,
                    textInputAction: TextInputAction.search,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Quartier, ville, type…',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _filtres.texte.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Effacer',
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _rechercheController.clear();
                                _surRecherche('');
                              },
                            ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _filtres.aucunCritere ? 'Annonces récentes' : 'Résultats',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!_filtres.aucunCritere)
                    TextButton(
                      onPressed: _reinitialiser,
                      child: const Text('Réinitialiser'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListeAnnonces(
                filtres: _filtres,
                onReinitialiser: _reinitialiser,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
