import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunu_zone/features/home/widgets/bouton_chargement.dart';
import 'package:sunu_zone/models/annonces.dart';
import '../../core/utils/validators.dart';
import '../../data/depots.dart';
import '../../data/images_demo.dart';

class PublierAnnoncePage extends StatefulWidget {
  const PublierAnnoncePage({super.key, this.annonceAModifier});

  /// Si elle est fournie, la page fonctionne en mode « modification ».
  final Annonce? annonceAModifier;

  @override
  State<PublierAnnoncePage> createState() => _PublierAnnoncePageState();
}

class _PublierAnnoncePageState extends State<PublierAnnoncePage> {
  static const _types = ['Appartement', 'Villa', 'Studio', 'Chambre', 'Maison'];

  final _formKey = GlobalKey<FormState>();
  final _nbPiecesController = TextEditingController();
  final _surfaceController = TextEditingController();
  final _prixController = TextEditingController();
  final _quartierController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _type = _types.first;
  AutovalidateMode _modeValidation = AutovalidateMode.disabled;
  bool _enChargement = false;

  bool get _enEdition => widget.annonceAModifier != null;

  @override
  void initState() {
    super.initState();
    final annonce = widget.annonceAModifier;
    if (annonce != null) {
      _type = _types.contains(annonce.type) ? annonce.type : _types.first;
      _nbPiecesController.text = '${annonce.nbPieces}';
      _surfaceController.text = '${annonce.surfaceM2}';
      _prixController.text = '${annonce.prix}';
      _quartierController.text = annonce.quartier;
      _descriptionController.text = annonce.description;
    }
  }

  @override
  void dispose() {
    _nbPiecesController.dispose();
    _surfaceController.dispose();
    _prixController.dispose();
    _quartierController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _envoyer() async {
    final utilisateur = authService.utilisateurCourant;
    if (utilisateur == null) {
      _afficherMessage('Connectez-vous pour publier une annonce.');
      return;
    }

    final existante = widget.annonceAModifier;
    if (existante != null && existante.proprietaireId != utilisateur.id) {
      _afficherMessage('Vous ne pouvez modifier que vos propres annonces.');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      setState(() => _modeValidation = AutovalidateMode.onUserInteraction);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _enChargement = true);

    // On récupère ces objets AVANT l'attente.
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    var message = _enEdition
        ? 'Annonce modifiée. Elle sera de nouveau vérifiée avant publication.'
        : 'Annonce envoyée. Elle sera visible après validation.';

    try {
      if (existante != null) {
        final modifiee = existante.copyWith(
          type: _type,
          nbPieces: int.parse(_nbPiecesController.text.trim()),
          surfaceM2: int.parse(_surfaceController.text.trim()),
          prix: int.parse(_prixController.text.trim()),
          quartier: _quartierController.text.trim(),
          description: _descriptionController.text.trim(),
        );
        await annonceRepository
            .modifier(modifiee)
            .timeout(const Duration(seconds: 15));
      } else {
        final annonce = Annonce(
          id: '', // attribué par Firestore
          type: _type,
          nbPieces: int.parse(_nbPiecesController.text.trim()),
          surfaceM2: int.parse(_surfaceController.text.trim()),
          prix: int.parse(_prixController.text.trim()),
          quartier: _quartierController.text.trim(),
          images: imagesDemo(DateTime.now().millisecondsSinceEpoch.toString()),
          description: _descriptionController.text.trim(),
          proprietaire: utilisateur.nomAffiche,
          proprietaireId: utilisateur.id,
          telephone: utilisateur.telephone,
          statut: StatutAnnonce.enAttente,
        );
        await annonceRepository
            .publier(annonce)
            .timeout(const Duration(seconds: 15));
      }
    } on TimeoutException {
      message =
          'Connexion lente : votre annonce sera enregistrée dès que '
          'le réseau reviendra.';
    } catch (erreur) {
      debugPrint('Erreur d\'envoi : $erreur');
      if (!mounted) return;
      setState(() => _enChargement = false);
      messenger.showSnackBar(
        const SnackBar(content: Text("Échec de l'envoi. Réessayez.")),
      );
      return;
    }

    if (!mounted) return;
    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  void _afficherMessage(String texte) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texte)));
  }

  Widget _champNombre({
    required TextEditingController controller,
    required String label,
    required String messageErreur,
    String? suffixe,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9),
      ],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffixe,
        border: const OutlineInputBorder(),
      ),
      validator: (valeur) => validerEntierPositif(valeur, messageErreur),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_enEdition ? "Modifier l'annonce" : 'Publier une annonce'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: _modeValidation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: const InputDecoration(
                    labelText: 'Type de logement',
                    border: OutlineInputBorder(),
                  ),
                  items: _types
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (valeur) => _type = valeur ?? _type,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _champNombre(
                        controller: _nbPiecesController,
                        label: 'Pièces',
                        messageErreur: 'Indiquez le nombre',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _champNombre(
                        controller: _surfaceController,
                        label: 'Surface',
                        suffixe: 'm²',
                        messageErreur: 'Indiquez la surface',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _champNombre(
                  controller: _prixController,
                  label: 'Loyer mensuel',
                  suffixe: 'FCFA / mois',
                  messageErreur: 'Indiquez le loyer mensuel',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quartierController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Quartier, ville',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valeur) => validerTexteMin(
                    valeur,
                    2,
                    'Indiquez le quartier ou la ville',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 4,
                  maxLines: 8,
                  maxLength: 600,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (valeur) => validerTexteMin(
                    valeur,
                    20,
                    'Décrivez le logement (20 caractères minimum)',
                  ),
                ),
                const SizedBox(height: 8),
                _BlocInfo(
                  icone: Icons.photo_library_outlined,
                  texte: _enEdition
                      ? "Les photos de l'annonce ne sont pas modifiables "
                            "pour l'instant."
                      : "Photos : pour l'instant, des images de "
                            'démonstration sont ajoutées automatiquement.',
                ),
                const SizedBox(height: 8),
                _BlocInfo(
                  icone: Icons.verified_user_outlined,
                  texte: _enEdition
                      ? "Après modification, l'annonce repasse « en attente » "
                            'et sera vérifiée de nouveau par un administrateur.'
                      : 'Publié par '
                            '${authService.utilisateurCourant?.nomAffiche ?? ''}. '
                            "L'annonce sera visible après validation par un "
                            'administrateur.',
                ),
                const SizedBox(height: 24),
                BoutonChargement(
                  texte: _enEdition
                      ? 'Enregistrer les modifications'
                      : "Publier l'annonce",
                  enChargement: _enChargement,
                  onPressed: _envoyer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BlocInfo extends StatelessWidget {
  const _BlocInfo({required this.icone, required this.texte});

  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: couleurs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 20, color: couleurs.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(child: Text(texte)),
        ],
      ),
    );
  }
}
