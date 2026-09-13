import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDatasource {
  final FirebaseStorage _storage;

  FirebaseStorageDatasource(this._storage);

  Future<String> uploadFile({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final ref = _storage.ref(path);
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    return await ref.getDownloadURL();
  }

  Future<void> deleteFile(String path) async {
    await _storage.ref(path).delete();
  }

  Future<void> deleteFileByUrl(String url) async {
    if (!url.startsWith('https://') || !url.contains('firebasestorage.googleapis.com')) {
      return;
    }
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // Ignora si el archivo ya no existe o hubo error de referencia
    }
  }
}
