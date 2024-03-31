import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/common/error_page.dart';
import 'package:flutter_twitter_clone/common/loading_page.dart';
import 'package:flutter_twitter_clone/constants/appwrite_constants.dart';
import 'package:flutter_twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:flutter_twitter_clone/features/tweet/widgets/tweet_card.dart';

import '../../../models/tweet_model.dart';

class TwitterReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
        builder: (context) => TwitterReplyScreen(
          tweet: tweet,
        ),
      );
  final Tweet tweet;
  const TwitterReplyScreen({required this.tweet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('tweet'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetsProvider(tweet)).when(
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
                        if (!isTweetAlreadyPresent &&
                            latesTweet.reliedTo == tweet.id) {
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

                        return Expanded(
                          child: ListView.builder(
                            itemCount: tweets.length,
                            itemBuilder: (context, index) {
                              final tweet = tweets[index];
                              return TweetCard(tweet: tweet);
                            },
                          ),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: tweets.length,
                            itemBuilder: (context, index) {
                              final tweet = tweets[index];
                              return TweetCard(tweet: tweet);
                            },
                          ),
                        );
                      });
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          ref.read(tweetControllerProvider.notifier).shareTweet(
            images: [],
            text: value,
            context: context,
            reliedTo: tweet.id,
            reliedToUserId: tweet.uid,
          );
        },
        decoration: const InputDecoration(
          hintText: 'Tweet your reply',
        ),
      ),
    );
  }
}
