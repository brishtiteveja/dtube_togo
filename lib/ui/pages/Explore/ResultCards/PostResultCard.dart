import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/friendlyTimestamp.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
import 'package:dtube_go/utils/shortBalanceStrings.dart';
import 'package:flutter/material.dart';

class PostResultCard extends StatelessWidget {
  const PostResultCard({
    Key? key,
    required this.id,
    required this.author,
    required this.link,
    required this.tags,
    required this.dist,
    required this.title,
    required this.ts,
  }) : super(key: key);

  final String id;
  final String author;
  final String link;
  final double dist;
  final String tags;
  final String title;

  final int ts;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToPostDetailPage(context, author, link, "none", false, () {});
      },
      child: Card(
        // height: 35,
        margin: EdgeInsets.all(8.0),
        color: globalBlue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountAvatarBase(
                      username: author,
                      avatarSize: 20.w,
                      showVerified: true,
                      showName: true,
                      width: 30.w,
                      height: 10.h),
                  Text(
                    TimeAgo.timeInAgoTS(ts),
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    shortDTC(dist.round()) + 'DTC',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
