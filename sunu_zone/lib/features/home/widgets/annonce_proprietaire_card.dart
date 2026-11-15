import 'package:flutter/material.dart';
import 'package:sunu_zone/models/annonces.dart';

enum ActionAnnonce { modifier, marquerLouee, remettreEnLigne, supprimer }

class AnnonceProprietaireCard extends StatelessWidget {
  const AnnonceProprietaireCard({
    super.key,
    required this.annonce,
    required this.onOuvrir,
    required this.onAction,
  });

  final Annonce annonce;
  final VoidCallback onOuvrir;
  final ValueChanged<ActionAnnonce> onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final couleurs = theme.colorScheme;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: couleurs.outlineVariant),
      ),
      child: InkWell(
        onTap: onOuvrir,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  annonce.imageCouverture,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 88,
                    height: 88,
                    color: couleurs.surfaceContainerHighest,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      annonce.prixAffiche,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: couleurs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      annonce.descriptionCourte,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      annonce.quartier,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: couleurs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _PastilleStatut(statut: annonce.statut),
                  ],
                ),
              ),
              PopupMenuButton<ActionAnnonce>(
                tooltip: 'Actions',
                onSelected: onAction,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: ActionAnnonce.modifier,
                    child: _ItemMenu(
                      icone: Icons.edit_outlined,
                      texte: 'Modifier',
                    ),
                  ),
                  if (annonce.statut == StatutAnnonce.publiee)
                    const PopupMenuItem(
                      value: ActionAnnonce.marquerLouee,
                      child: _ItemMenu(
                        icone: Icons.key_outlined,
                        texte: 'Marquer comme louée',
                      ),
                    ),
                  if (annonce.statut == StatutAnnonce.louee)
                    const PopupMenuItem(
                      value: ActionAnnonce.remettreEnLigne,
                      child: _ItemMenu(
                        icone: Icons.replay_outlined,
                        texte: 'Remettre en ligne',
                      ),
                    ),
                  const PopupMenuItem(
                    value: ActionAnnonce.supprimer,
                    child: _ItemMenu(
                      icone: Icons.delete_outline,
                      texte: 'Supprimer',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  const _ItemMenu({required this.icone, required this.texte});

  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icone, size: 20), const SizedBox(width: 12), Text(texte)],
    );
  }
}

class _PastilleStatut extends StatelessWidget {
  const _PastilleStatut({required this.statut});

  final StatutAnnonce statut;

  Color get _couleur => switch (statut) {
    StatutAnnonce.enAttente => Colors.orange.shade800,
    StatutAnnonce.publiee => Colors.green.shade700,
    StatutAnnonce.refusee => Colors.red.shade700,
    StatutAnnonce.louee => Colors.blueGrey,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _couleur.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: _couleur),
          const SizedBox(width: 6),
          Text(
            statut.libelle,
            style: TextStyle(
              color: _couleur,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
