// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/theme/theme.dart';

class FollowCount extends StatelessWidget {
  final String text;
  final int count;
  const FollowCount({
    Key? key,
    required this.text,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;
    return Row(
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: Pallete.whiteColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          text,
          style: TextStyle(
            color: Pallete.greyColor,
            fontSize: fontSize,
          ),
        )
      ],
    );
  }
}
