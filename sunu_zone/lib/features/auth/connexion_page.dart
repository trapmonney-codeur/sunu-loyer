import 'package:flutter/material.dart';
import 'package:sunu_zone/features/home/widgets/bouton_chargement.dart';
import 'package:sunu_zone/features/home/widgets/champ_password.dart';
import 'package:sunu_zone/features/home/widgets/champ_telephone.dart';
import '../../core/utils/validators.dart';
import 'inscription_page.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final _formKey = GlobalKey<FormState>();
  final _telephoneController = TextEditingController();
  final _motDePasseController = TextEditingController();

  AutovalidateMode _modeValidation = AutovalidateMode.disabled;
  bool _enChargement = false;

  @override
  void dispose() {
    _telephoneController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    if (!_formKey.currentState!.validate()) {
      // Après un premier échec, les erreurs se mettent à jour en direct.
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
    ).showSnackBar(const SnackBar(content: Text('Connexion simulée')));
    Navigator.of(context).pop();
  }

  void _ouvrirInscription() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const InscriptionPage()));
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
                Center(child: Image.asset('assets/images/logo.png', width: 96)),
                const SizedBox(height: 24),
                Text(
                  'Connexion',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous pour gérer vos annonces',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                ChampTelephone(controller: _telephoneController),
                const SizedBox(height: 16),
                ChampMotDePasse(
                  controller: _motDePasseController,
                  validator: validerMotDePasseSaisi,
                  textInputAction: TextInputAction.done,
                  onSubmitted: _seConnecter,
                ),
                const SizedBox(height: 24),
                BoutonChargement(
                  texte: 'Se connecter',
                  enChargement: _enChargement,
                  onPressed: _seConnecter,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Pas encore de compte ?'),
                    TextButton(
                      onPressed: _enChargement ? null : _ouvrirInscription,
                      child: const Text('Créer un compte'),
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
