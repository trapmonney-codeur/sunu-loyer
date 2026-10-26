import 'package:flutter/material.dart';
import 'package:sunu_zone/features/home/widgets/galerie_photos.dart';
import '../../models/annonces.dart';

class AnnonceDetailPage extends StatelessWidget {
  const AnnonceDetailPage({super.key, required this.annonce});

  final Annonce annonce;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final couleurs = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GaleriePhotos(
                  images: annonce.images,
                  heroTag: 'annonce-image-${annonce.id}',
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        annonce.prixAffiche,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: couleurs.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        annonce.descriptionCourte,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: couleurs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              annonce.quartier,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 24),

                      Text(
                        'Caractéristiques',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _Caracteristique(
                              icone: Icons.square_foot,
                              valeur: '${annonce.surfaceM2} m²',
                              libelle: 'Surface',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _Caracteristique(
                              icone: Icons.meeting_room_outlined,
                              valeur: '${annonce.nbPieces}',
                              libelle: annonce.nbPieces > 1
                                  ? 'Pièces'
                                  : 'Pièce',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _Caracteristique(
                              icone: Icons.home_work_outlined,
                              valeur: annonce.type,
                              libelle: 'Type',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Description',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        annonce.description,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Propriétaire',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          child: Text(annonce.initialeProprietaire),
                        ),
                        title: Text(annonce.proprietaire),
                        subtitle: const Text('Propriétaire'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton.filledTonal(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call_outlined),
                  label: const Text('Appeler'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('WhatsApp'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Petite tuile « icône + valeur + libellé », utilisée seulement ici.
class _Caracteristique extends StatelessWidget {
  const _Caracteristique({
    required this.icone,
    required this.valeur,
    required this.libelle,
  });

  final IconData icone;
  final String valeur;
  final String libelle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final couleurs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: couleurs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icone, color: couleurs.primary),
          const SizedBox(height: 6),
          Text(
            valeur,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            libelle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: couleurs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
