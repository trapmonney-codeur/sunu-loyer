import 'package:flutter/material.dart';
import 'package:sunu_zone/features/home/widgets/bouton_chargement.dart';
import 'package:sunu_zone/features/home/widgets/champ_password.dart'
    show ChampMotDePasse;
import 'package:sunu_zone/features/home/widgets/champ_telephone.dart';
import '../../core/utils/validators.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _confirmationController = TextEditingController();

  AutovalidateMode _modeValidation = AutovalidateMode.disabled;
  bool _enChargement = false;

  @override
  void dispose() {
    _nomController.dispose();
    _telephoneController.dispose();
    _motDePasseController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _creerCompte() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _modeValidation = AutovalidateMode.onUserInteraction);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _enChargement = true);

    // Simulation du temps de réponse d'un serveur.
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _enChargement = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Compte créé (simulation)')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            autovalidateMode: _modeValidation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Créer un compte',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Publiez et gérez vos annonces de location',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nomController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nom complet',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: validerNom,
                ),
                const SizedBox(height: 16),
                ChampTelephone(controller: _telephoneController),
                const SizedBox(height: 16),
                ChampMotDePasse(
                  controller: _motDePasseController,
                  validator: validerMotDePasse,
                ),
                const SizedBox(height: 16),
                ChampMotDePasse(
                  controller: _confirmationController,
                  label: 'Confirmer le mot de passe',
                  validator: (valeur) =>
                      validerConfirmation(valeur, _motDePasseController.text),
                  textInputAction: TextInputAction.done,
                  onSubmitted: _creerCompte,
                ),
                const SizedBox(height: 24),
                BoutonChargement(
                  texte: 'Créer mon compte',
                  enChargement: _enChargement,
                  onPressed: _creerCompte,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Déjà un compte ?'),
                    TextButton(
                      onPressed: _enChargement
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Se connecter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
