// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_twitter_clone/common/error_page.dart';
import 'package:flutter_twitter_clone/common/loading_page.dart';
import 'package:flutter_twitter_clone/constants/appwrite_constants.dart';
import 'package:flutter_twitter_clone/constants/assets_constants.dart';
import 'package:flutter_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:flutter_twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:flutter_twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:flutter_twitter_clone/features/user_profile/view/edit_profile_view.dart';
import 'package:flutter_twitter_clone/features/user_profile/widget/follow_count.dart';
import 'package:flutter_twitter_clone/models/tweet_model.dart';

import 'package:flutter_twitter_clone/models/user_models.dart';
import 'package:flutter_twitter_clone/theme/theme.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: user.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(
                                user.bannerPic,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 45,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {
                            if (currentUser.uid == user.uid) {
                              //edit profile
                              Navigator.push(
                                context,
                                EditProfileView.route(),
                              );
                            } else {
                              ref
                                  .read(userprofileControllerProvider.notifier)
                                  .followUser(
                                    user: user,
                                    context: context,
                                    currentUser: currentUser,
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                    width: 1.8, color: Pallete.whiteColor)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                          ),
                          child: Text(
                            currentUser.uid == user.uid
                                ? 'Edit Profile'
                                : currentUser.following.contains(user.uid)
                                    ? 'unfollow'
                                    : 'Follow',
                            style: const TextStyle(color: Pallete.whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (user.isTwitterBlue)
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: SvgPicture.asset(
                                  AssetsConstants.verifiedIcon,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          ' @${user.name}',
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Pallete.greyColor),
                        ),
                        Text(
                          user.bio,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            FollowCount(
                              text: 'Following',
                              count: user.following.length,
                            ),
                            const SizedBox(width: 15),
                            FollowCount(
                              text: 'Followers',
                              count: user.followers.length,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        const Divider(
                          color: Pallete.whiteColor,
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: ref.watch(getUserTweetsProvider(user.uid)).when(
                  // twitter reply code copying here
                  // for real time
                  data: (tweets) {
                    return ref.watch(getLatestStreamProvider).when(
                        data: (data) {
                          final latesTweet = Tweet.fromMap(data.payload);
                          bool isTweetAlreadyPresent = false;
                          for (final tweetModel in tweets) {
                            if (tweetModel.id == latesTweet.id) {
                              isTweetAlreadyPresent = true;
                              break;
                            }
                          }
                          if (!isTweetAlreadyPresent) {
                            if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetCollections}.documents.*.create',
                            )) {
                              tweets.insert(0, Tweet.fromMap(data.payload));
                            } else if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetCollections}.documents.*.update',
                            )) {
                              final startingPoint =
                                  data.events[0].lastIndexOf('documents.');
                              final endPoint =
                                  data.events[0].lastIndexOf('.update');
                              final tweetId = data.events[0]
                                  .substring(startingPoint + 10, endPoint);
                              // get Id of tweet
                              // var tweet = Tweet.fromMap(data.payload);
                              // final tweetId = tweet.id;
                              var tweet = tweets
                                  .where((element) => element.id == tweetId)
                                  .first;

                              // get index
                              final tweetIndex = tweets.indexOf(tweet);
                              tweets.removeWhere(
                                  (element) => element.id == tweetId);

                              // update tweet
                              tweet = Tweet.fromMap(data.payload);
                              tweets.insert(tweetIndex, tweet);
                            }
                          }

                          return ListView.builder(
                            itemCount: tweets.length,
                            itemBuilder: (context, index) {
                              final tweet = tweets[index];
                              return TweetCard(tweet: tweet);
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () {
                          return ListView.builder(
                            itemCount: tweets.length,
                            itemBuilder: (context, index) {
                              final tweet = tweets[index];
                              return TweetCard(tweet: tweet);
                            },
                          );
                        });
                  },
                  error: (e, st) => ErrorText(
                    error: e.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          );
  }
}
