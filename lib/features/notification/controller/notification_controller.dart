import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/apis/notifcation_api.dart';
import 'package:flutter_twitter_clone/core/enums/notification_type_enums.dart';
import 'package:flutter_twitter_clone/models/notification_model.dart' as model;

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
    notificationAPI: ref.watch(notificationAPIProvider),
  );
});
final getLatesNotificationProvider = StreamProvider((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return notificationAPI.getLatestNotification();
});
final getNotificationProvider = FutureProvider.family((ref, String uid) async {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotifications(uid);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;
  NotificationController({required NotificationAPI notificationAPI})
      : _notificationAPI = notificationAPI,
        super(false);
  void createNotification({
    required String text,
    required String postId,
    required String uid,
    required NotificationType notificationType,
  }) async {
    final notification = model.Notification(
      text: text,
      postId: postId,
      id: '',
      uid: uid,
      notificationType: notificationType,
    );
    final res = await _notificationAPI.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

  Future<List<model.Notification>> getNotifications(String uid) async {
    final notification = await _notificationAPI.getNotifications(uid);
    return notification.map((e) => model.Notification.fromMap(e.data)).toList();
  }
}
