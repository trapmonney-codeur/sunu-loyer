import 'package:flutter/material.dart';
import 'package:sunu_zone/features/home/widgets/invitation_connexion.dart';
import '../../core/utils/formatters.dart';
import '../../data/depots.dart';
import '../../models/utilisateur.dart';
import '../admin/widgets/acces_administration.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late final Stream<Utilisateur?> _session = authService.changements;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<Utilisateur?>(
      stream: _session,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final utilisateur = snapshot.data;

        return Scaffold(
          appBar: AppBar(title: const Text('Profil')),
          body: utilisateur == null
              ? const InvitationConnexion(
                  titre: 'Connectez-vous à votre compte',
                  message: 'Accédez à votre profil et à vos annonces.',
                )
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: CircleAvatar(
                          radius: 44,
                          child: Text(
                            utilisateur.initiale,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        utilisateur.nomAffiche,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formaterTelephone(utilisateur.telephone),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      AccesAdministration(
                        key: ValueKey(utilisateur.id),
                        utilisateurId: utilisateur.id,
                      ),
                      OutlinedButton.icon(
                        onPressed: authService.seDeconnecter,
                        icon: const Icon(Icons.logout),
                        label: const Text('Se déconnecter'),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
