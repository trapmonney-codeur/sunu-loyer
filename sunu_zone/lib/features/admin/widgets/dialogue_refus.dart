import 'package:flutter/material.dart';

/// Ouvre la boîte de dialogue et renvoie le motif saisi (null si annulé).
Future<String?> demanderMotifRefus(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const _DialogueRefus(),
  );
}

class _DialogueRefus extends StatefulWidget {
  const _DialogueRefus();

  @override
  State<_DialogueRefus> createState() => _DialogueRefusState();
}

class _DialogueRefusState extends State<_DialogueRefus> {
  static const _suggestions = [
    'Photos non conformes',
    'Informations incomplètes',
    'Prix incohérent',
    'Annonce en double',
    'Contenu inapproprié',
  ];

  final _controller = TextEditingController();
  String? _erreur;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmer() {
    final motif = _controller.text.trim();
    if (motif.length < 5) {
      setState(() => _erreur = 'Indiquez un motif (5 caractères minimum)');
      return;
    }
    Navigator.of(context).pop(motif);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Refuser l'annonce"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Le propriétaire verra ce motif et pourra corriger son annonce.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _suggestions
                  .map(
                    (suggestion) => ActionChip(
                      label: Text(suggestion),
                      onPressed: () => setState(() {
                        _controller.text = suggestion;
                        _erreur = null;
                      }),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              minLines: 2,
              maxLines: 4,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Motif du refus',
                errorText: _erreur,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(onPressed: _confirmer, child: const Text('Refuser')),
      ],
    );
  }
}
