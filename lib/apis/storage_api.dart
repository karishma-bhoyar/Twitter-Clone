import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/constants/appwrite_constants.dart';
import 'package:flutter_twitter_clone/core/providers.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(storage: ref.watch(appWriteStorageProvider));
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages(List<File> fiels) async {
    List<String> imageLinks = [];
    for (final file in fiels) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        // ignore: deprecated_member_use
        file: InputFile(path: file.path),
      );
      imageLinks.add(AppwriteConstants.imageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }
}
