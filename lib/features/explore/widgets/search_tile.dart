import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';

import '../../../models/user_models.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;
  const SearchTile({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          UserProfileView.route(userModel),
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userModel.profilePic),
        radius: 30,
      ),
      title: Text(
        userModel.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.name}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            userModel.bio,
            style: const TextStyle(
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
