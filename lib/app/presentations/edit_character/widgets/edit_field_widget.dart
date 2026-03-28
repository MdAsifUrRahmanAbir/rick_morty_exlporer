import 'package:flutter/material.dart';
import '../../../widgets/primary_input_field.dart';

class EditFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool isRequired;

  const EditFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: PrimaryInputField(
        label: label,
        controller: controller,
        hint: 'Enter $label',
        prefixIcon: Icon(icon, size: 20),
        validator: isRequired 
          ? (v) => v == null || v.isEmpty ? '$label is required' : null
          : null,
      ),
    );
  }
}
