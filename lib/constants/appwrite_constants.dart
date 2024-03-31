// class AppwriteConstants {
//   static const String databaseId = '65088bd062989628147d';
//   static const String projectId = '6508873a303bd42ed7e1';
//   static const String endPoint = 'http://192.168.1.11/v1';

//   static const String userCollection = '65522f5d7df53414dc0f';
//   static const String tweetCollection = '65a7f705cb55382b6907';

//   static const String imageBucket = '65a94ccb309336680975';

//   static String imageUrl(String imageId) =>
//       '$endPoint/v1/storage/buckets/$imageBucket/files/$imageId/view?project=$projectId&mode=admin';
//   // static const String endPoint =
//   //     'http://192.168.1.2/console/organization-65088733c7c4c44c0d2d';
// }

class AppwriteConstants {
  static const String databaseId = '65e43d01b23939524ec3';
  static const String projectId = '65e43c9aac7891f8fce3';
  static const String endpoint = 'https://cloud.appwrite.io/v1';
  static const String usersCollections = '65e594a18fb187697804';
  static const String tweetCollections = '65ead078bc3867e3ebfd';
  static const String notificationsCollections = '65fcf94246ccb14e3cff';
  static const String imagesBucket = '65e9b6b83cae26df133d';
  static String imageUrl(String imageId) =>
      '$endpoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';

  // static const String databaseId = '65e41ec6d9103788c465';
  // static const String projectId = '65e41d8dcc7468b967ed';
  // static const String endpoint =
  //     'https://8080-appwrite-integrationfor-zmeg8zrqf0v.ws-us108.gitpod.io/v1';
  // static const String usersCollections = '65e5ae04a4214959b9cf';
}

// import 'package:appwrite/appwrite.dart';

// Client client = Client();
// client
//     .setEndpoint('https://cloud.appwrite.io/v1')
//     .setProject('65e41b622c357e746edd')
//     .setSelfSigned(status: true); // For self signed certificates, only use for development