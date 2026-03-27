import 'package:flutter/material.dart';
import '../../../core/services/local_storage_service.dart';

class EditCharacterProvider extends ChangeNotifier {
  
  Future<void> updateCharacterLocal(int id, Map<String, dynamic> data) async {
    await LocalStorage.saveOverride(id, data);
    notifyListeners();
  }
}
