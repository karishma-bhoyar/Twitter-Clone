import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_twitter_clone/constants/assets_constants.dart';
import 'package:flutter_twitter_clone/constants/ui_constant.dart';
import 'package:flutter_twitter_clone/features/home/view/widgets/side_drawer.dart';
import 'package:flutter_twitter_clone/features/tweet/views/create_tweet_view.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    Navigator.push(context, CreateTweetView.route());
  }

  final appabar = UIContants.appBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appabar : null,
      body: IndexedStack(
        index: _page,
        children: UIContants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweet,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28.0,
        ),
      ),
      drawer: const SideDrawer(),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: _page,
          onTap: onPageChange,
          backgroundColor: Pallete.backgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _page == 0
                    ? AssetsConstants.homeFilledIcon
                    : AssetsConstants.homeOutlinedIcon,
                color: Pallete.whiteColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AssetsConstants.searchIcon,
                color: Pallete.whiteColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _page == 2
                    ? AssetsConstants.notifFilledIcon
                    : AssetsConstants.notifOutlinedIcon,
                color: Pallete.whiteColor,
              ),
            ),
          ]),
    );
  }
}
