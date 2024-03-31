import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_twitter_clone/features/explore/view/explore_view.dart';
import 'package:flutter_twitter_clone/features/notification/views/notification_view.dart';

import '../features/tweet/widgets/tweet_list.dart';
import 'assets_constants.dart';

class UIContants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Colors.blue,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static List<Widget> bottomTabBarPages = [
    const TweetList(),
    const ExploreView(),
    const NotificationView(),
  ];
}
