import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/pages/post/widgets/ReplyButton.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteButtons.dart';

import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Create the Widget for the row
class CommentDisplay extends StatelessWidget {
  const CommentDisplay(
      this.entry,
      this.defaultVoteWeight,
      this._currentVT,
      this.parentAuthor,
      this.parentLink,
      this.defaultVoteTip,
      this.parentContext);
  final Comment entry;
  final double defaultVoteWeight;
  final double defaultVoteTip;
  final String parentAuthor;
  final String parentLink;
  final int _currentVT;
  final BuildContext parentContext;

  // This function recursively creates the multi-level list rows.
  Widget _buildTiles(Comment root) {
    if (root.childComments == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AccountAvatarBase(
                username: root.author,
                avatarSize: 12.w,
                showVerified: true,
                showName: true,
                width: 35.w,
                height: 8.h,
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                width: 60.w,
                child: Text(
                  root.commentjson.description,
                  style: Theme.of(parentContext).textTheme.bodyText1,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              BlocProvider<UserBloc>(
                create: (BuildContext context) =>
                    UserBloc(repository: UserRepositoryImpl()),
                child: VotingButtons(
                    author: root.author,
                    link: root.link,
                    alreadyVoted: root.alreadyVoted,
                    alreadyVotedDirection: root.alreadyVotedDirection,
                    upvotes: root.upvotes,
                    downvotes: root.downvotes,
                    defaultVotingWeight: defaultVoteWeight,
                    defaultVotingTip: defaultVoteTip,
                    scale: 0.5,
                    isPost: false,
                    focusVote: "",
                    iconColor: Colors.white,
                    fadeInFromLeft: true),
              ),
              Align(
                alignment: Alignment.topRight,
                child: BlocProvider(
                  create: (context) =>
                      TransactionBloc(repository: TransactionRepositoryImpl()),
                  child: ReplyButton(
                    icon: FaIcon(FontAwesomeIcons.comments),
                    author: root.author,
                    link: root.link,
                    parentAuthor: parentAuthor,
                    parentLink: parentLink,
                    votingWeight: defaultVoteWeight,
                    scale: 0.8,
                    focusOnNewComment: false,
                    isMainPost: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                AccountAvatarBase(
                  username: root.author,
                  avatarSize: 12.w,
                  showVerified: true,
                  showName: true,
                  width: 35.w,
                  height: 8.h,
                ),
                Container(
                  width: 60.w,
                  child: Text(
                    root.commentjson.description,
                    style: Theme.of(parentContext).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                VotingButtons(
                    author: root.author,
                    link: root.link,
                    alreadyVoted: root.alreadyVoted,
                    alreadyVotedDirection: root.alreadyVotedDirection,
                    upvotes: root.upvotes,
                    downvotes: root.downvotes,
                    defaultVotingWeight: defaultVoteWeight,
                    defaultVotingTip: defaultVoteTip,
                    scale: 0.5,
                    isPost: false,
                    iconColor: Colors.white,
                    focusVote: "",
                    fadeInFromLeft: true),
                Align(
                  alignment: Alignment.topRight,
                  child: BlocProvider(
                    create: (context) => TransactionBloc(
                        repository: TransactionRepositoryImpl()),
                    child: ReplyButton(
                      icon: FaIcon(FontAwesomeIcons.comments),
                      author: root.author,
                      link: root.link,
                      parentAuthor: parentAuthor,
                      parentLink: parentLink,
                      votingWeight: defaultVoteWeight,
                      scale: 0.8,
                      focusOnNewComment: false,
                      isMainPost: false,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                children: root.childComments!.map<Widget>(_buildTiles).toList(),
              ),
            ),
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("comment display");
    return _buildTiles(entry);
  }
}
