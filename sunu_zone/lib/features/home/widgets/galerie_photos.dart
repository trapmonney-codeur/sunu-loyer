import 'package:flutter/material.dart';

class GaleriePhotos extends StatefulWidget {
  const GaleriePhotos({super.key, required this.images, required this.heroTag});

  final List<String> images;
  final String heroTag;

  @override
  State<GaleriePhotos> createState() => _GaleriePhotosState();
}

class _GaleriePhotosState extends State<GaleriePhotos> {
  final PageController _controller = PageController();
  int _pageActuelle = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _aller(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _photo(String url) {
    final couleurs = Theme.of(context).colorScheme;

    return Image.network(
      url,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progression) {
        if (progression == null) return child;
        return Container(
          color: couleurs.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: couleurs.surfaceContainerHighest,
        child: const Icon(Icons.image_not_supported_outlined, size: 48),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.images.length;

    if (total == 0) {
      return AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.image_not_supported_outlined, size: 48),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: total,
            onPageChanged: (index) {
              setState(() => _pageActuelle = index);
            },
            itemBuilder: (context, index) {
              final photo = _photo(widget.images[index]);
              // Le Hero n'est actif que sur la première photo, tant qu'on la regarde.
              if (index == 0 && _pageActuelle == 0) {
                return Hero(tag: widget.heroTag, child: photo);
              }
              return photo;
            },
          ),
          if (total > 1) ...[
            if (_pageActuelle > 0)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _BoutonPhoto(
                      icone: Icons.chevron_left,
                      onPressed: () => _aller(_pageActuelle - 1),
                    ),
                  ),
                ),
              ),
            if (_pageActuelle < total - 1)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _BoutonPhoto(
                      icone: Icons.chevron_right,
                      onPressed: () => _aller(_pageActuelle + 1),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.photo_library_outlined,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_pageActuelle + 1} / $total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bouton rond semi-transparent, lisible sur n'importe quelle photo.
class _BoutonPhoto extends StatelessWidget {
  const _BoutonPhoto({required this.icone, required this.onPressed});

  final IconData icone;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icone),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black45,
        foregroundColor: Colors.white,
      ),
    );
  }
}
