import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/constants/appwrite_constants.dart';
import 'package:flutter_twitter_clone/core/failure.dart';
import 'package:flutter_twitter_clone/core/providers.dart';

import 'package:flutter_twitter_clone/core/type_defs.dart';
import 'package:flutter_twitter_clone/models/user_models.dart';
import 'package:fpdart/fpdart.dart';

final userAPIProvider = Provider((ref) {
  final db = ref.watch(appWriteDatabaseProvider);
  final realtime = ref.watch(appWriteRealtimeProvider);
  return UserAPI(db: db, realtime: realtime);
});

abstract class IUserAPI {
  FutureEitheVoid saveUserData(UserModel userModel);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> searchUserByName(String name);
  FutureEitheVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatesUserProfileData();
  FutureEitheVoid followUser(UserModel user);
  FutureEitheVoid addToFollowing(UserModel user);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;
  UserAPI({
    required Databases db,
    required Realtime realtime,
  })  : _realtime = realtime,
        _db = db;

  @override
  FutureEitheVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollections,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? "Some Unexpected error Occured", st),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<model.Document> getUserData(String uid) {
    final getDocuments = _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollections,
      documentId: uid,
      // documentId: ID.unique(),
    );
    return getDocuments;
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollections,
      queries: [
        Query.search('name', name),
      ],

      // documentId: ID.unique(),
    );
    return documents.documents;
  }

  @override
  FutureEitheVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollections,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? "Some Unexpected error Occured", st),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<RealtimeMessage> getLatesUserProfileData() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollections}.documents.',
    ]).stream;
  }

  @override
  FutureEitheVoid followUser(UserModel user) async {
    try {
      await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollections,
          documentId: user.uid,
          data: {
            'followers': user.followers,
          });
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? "Some Unexpected error Occured",
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitheVoid addToFollowing(UserModel user) async {
    try {
      await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollections,
          documentId: user.uid,
          data: {
            'following': user.following,
          });
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? "Some Unexpected error Occured",
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
