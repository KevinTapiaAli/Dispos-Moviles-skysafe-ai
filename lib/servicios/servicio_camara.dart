import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ServicioCamara {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> tomarFoto() async {
    final XFile? foto = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (foto == null) {
      return null;
    }

    return File(foto.path);
  }

  Future<File?> seleccionarDesdeGaleria() async {
    final XFile? imagen = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (imagen == null) {
      return null;
    }

    return File(imagen.path);
  }
}