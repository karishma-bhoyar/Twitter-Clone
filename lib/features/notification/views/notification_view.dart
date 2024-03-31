import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/common/error_page.dart';
import 'package:flutter_twitter_clone/common/loading_page.dart';
import 'package:flutter_twitter_clone/constants/appwrite_constants.dart';
import 'package:flutter_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/features/notification/controller/notification_controller.dart';
import 'package:flutter_twitter_clone/features/notification/widget/notification_tile.dart';
import 'package:flutter_twitter_clone/models/notification_model.dart' as model;

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatesNotificationProvider).when(
                      data: (data) {
                        if (data.events.contains(
                          'databases.*.collections.${AppwriteConstants.notificationsCollections}.documents.*.create',
                        )) {
                          final latestNotif =
                              model.Notification.fromMap(data.payload);
                          if (latestNotif.uid == currentUser.uid) {
                            notifications.insert(0, latestNotif);
                          }
                        }

                        return ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return NotificationTile(
                              notification: notification,
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () {
                        return ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return NotificationTile(
                              notification: notification,
                            );
                          },
                        );
                      });
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
    );
  }
}
