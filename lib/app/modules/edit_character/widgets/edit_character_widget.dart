import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_input_field.dart';
import '../../../data/models/character_model.dart';

class EditCharacterWidget extends StatefulWidget {
  final CharacterModel character;
  final Function(Map<String, dynamic>) onSave;

  const EditCharacterWidget({
    super.key,
    required this.character,
    required this.onSave,
  });

  @override
  State<EditCharacterWidget> createState() => _EditCharacterWidgetState();
}

class _EditCharacterWidgetState extends State<EditCharacterWidget> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameCtrl;
  late TextEditingController _speciesCtrl;
  late TextEditingController _typeCtrl;
  late TextEditingController _originCtrl;
  late TextEditingController _locationCtrl;

  late String _selectedStatus;
  late String _selectedGender;

  final List<String> _statusOptions = ['Alive', 'Dead', 'unknown'];
  final List<String> _genderOptions = ['Female', 'Male', 'Genderless', 'unknown'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.character.name);
    _speciesCtrl = TextEditingController(text: widget.character.species);
    _typeCtrl = TextEditingController(text: widget.character.type);
    _originCtrl = TextEditingController(text: widget.character.origin.name);
    _locationCtrl = TextEditingController(text: widget.character.location.name);
    
    _selectedStatus = widget.character.status;
    _selectedGender = widget.character.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _speciesCtrl.dispose();
    _typeCtrl.dispose();
    _originCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('IDENTITY'),
              _buildField('Name', _nameCtrl, Icons.person_outline),
              _buildField('Species', _speciesCtrl, Icons.category_outlined),
              _buildField('Type', _typeCtrl, Icons.info_outline),
              
              const SizedBox(height: 24),
              _buildSectionHeader('CHARACTERISTICS'),
              _buildChoiceChipGroup('Status', _statusOptions, _selectedStatus, (val) {
                setState(() => _selectedStatus = val);
              }),
              const SizedBox(height: 20),
              _buildChoiceChipGroup('Gender', _genderOptions, _selectedGender, (val) {
                setState(() => _selectedGender = val);
              }),
              
              const SizedBox(height: 24),
              _buildSectionHeader('LOCATIONS'),
              _buildField('Origin Name', _originCtrl, Icons.public_outlined),
              _buildField('Current Location', _locationCtrl, Icons.location_on_outlined),
              
              const SizedBox(height: 48),
              PrimaryButton(
                text: AppStrings.save,
                onPressed: _onSave,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: PrimaryInputField(
        label: label,
        controller: ctrl,
        hint: 'Enter $label',
        prefixIcon: Icon(icon, size: 20),
        validator: (v) => v!.isEmpty ? '$label is required' : null,
      ),
    );
  }

  Widget _buildChoiceChipGroup(String label, List<String> options, String currentSelection, Function(String) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = currentSelection == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) onSelected(option);
              },
              selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              checkmarkColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        'name': _nameCtrl.text.trim(),
        'status': _selectedStatus,
        'species': _speciesCtrl.text.trim(),
        'type': _typeCtrl.text.trim(),
        'gender': _selectedGender,
        'origin_name': _originCtrl.text.trim(),
        'location_name': _locationCtrl.text.trim(),
      };
      widget.onSave(data);
    }
  }
}
