import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/validators.dart';

class ChampTelephone extends StatelessWidget {
  const ChampTelephone({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
        LengthLimitingTextInputFormatter(12),
      ],
      decoration: const InputDecoration(
        labelText: 'Téléphone',
        hintText: '77 123 45 67',
        prefixIcon: Icon(Icons.phone_outlined),
        prefixText: '+221 ',
        border: OutlineInputBorder(),
      ),
      validator: validerTelephone,
    );
  }
}
