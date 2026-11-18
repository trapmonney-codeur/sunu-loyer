import 'package:flutter/material.dart';
import 'package:sunu_zone/core/utils/formatters.dart';
import 'package:sunu_zone/models/annonces.dart';

class CarteModeration extends StatelessWidget {
  const CarteModeration({
    super.key,
    required this.annonce,
    required this.onVoir,
    required this.onValider,
    required this.onRefuser,
  });

  final Annonce annonce;
  final VoidCallback onVoir;
  final VoidCallback onValider;
  final VoidCallback onRefuser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final couleurs = theme.colorScheme;
    final date = annonce.dateCreation;
    final nbPhotos = annonce.images.length;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: couleurs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onVoir,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                annonce.imageCouverture,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: couleurs.surfaceContainerHighest,
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        annonce.prixAffiche,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: couleurs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (date != null)
                      Text(
                        formaterDate(date),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: couleurs.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${annonce.descriptionCourte} · ${annonce.surfaceM2} m²',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: couleurs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(child: Text(annonce.quartier)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  annonce.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: couleurs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: Text(annonce.proprietaire)),
                    Text(formaterTelephone(annonce.telephone)),
                  ],
                ),
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: onVoir,
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: Text(
                    'Voir le détail ($nbPhotos photo${nbPhotos > 1 ? 's' : ''})',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onRefuser,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: couleurs.error,
                          side: BorderSide(color: couleurs.error),
                        ),
                        child: const Text('Refuser'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: onValider,
                        child: const Text('Valider'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
