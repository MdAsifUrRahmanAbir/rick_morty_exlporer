import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_button.dart';
import '../../character_screen/model/character_model.dart';
import 'edit_field_widget.dart';
import 'edit_choice_chip_group.dart';
import 'edit_section_header.dart';

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
              const EditSectionHeader(title: 'IDENTITY'),
              EditFieldWidget(
                label: 'Name', 
                controller: _nameCtrl, 
                icon: Icons.person_outline
              ),
              EditFieldWidget(
                label: 'Species', 
                controller: _speciesCtrl, 
                icon: Icons.category_outlined
              ),
              EditFieldWidget(
                label: 'Type', 
                controller: _typeCtrl, 
                icon: Icons.info_outline,
                isRequired: false,
              ),
              
              const SizedBox(height: 24),
              const EditSectionHeader(title: 'CHARACTERISTICS'),
              EditChoiceChipGroup(
                label: 'Status', 
                options: _statusOptions, 
                currentSelection: _selectedStatus, 
                onSelected: (val) {
                  setState(() => _selectedStatus = val);
                }
              ),
              const SizedBox(height: 20),
              EditChoiceChipGroup(
                label: 'Gender', 
                options: _genderOptions, 
                currentSelection: _selectedGender, 
                onSelected: (val) {
                  setState(() => _selectedGender = val);
                }
              ),
              
              const SizedBox(height: 24),
              const EditSectionHeader(title: 'LOCATIONS'),
              EditFieldWidget(
                label: 'Origin Name', 
                controller: _originCtrl, 
                icon: Icons.public_outlined
              ),
              EditFieldWidget(
                label: 'Current Location', 
                controller: _locationCtrl, 
                icon: Icons.location_on_outlined
              ),
              
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
