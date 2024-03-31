import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/constants/appwrite_constants.dart';
import 'package:flutter_twitter_clone/core/core.dart';
import 'package:flutter_twitter_clone/core/providers.dart';
import 'package:flutter_twitter_clone/models/notification_model.dart';
import 'package:fpdart/fpdart.dart';

final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
    realtime: ref.watch(appWriteRealtimeProvider),
    db: ref.watch(appWriteDatabaseProvider),
  );
});

abstract class INotificationAPI {
  FutureEitheVoid createNotification(Notification notification);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  final Realtime _realtime;
  NotificationAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEitheVoid createNotification(Notification notification) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationsCollections,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? "Some Unexpected error Occured",
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(e.toString(), st),
      );
    }
  }

  @override
  Future<List<Document>> getNotifications(String uid) async {
    final documentes = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.notificationsCollections,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documentes.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notificationsCollections}.documents',
    ]).stream;
  }
}
