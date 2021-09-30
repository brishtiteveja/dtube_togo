import 'package:dtube_go/style/dtubeLoading.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/feed/feed_bloc.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';

import 'package:dtube_go/bloc/search/search_bloc_full.dart';

import 'package:dtube_go/style/styledCustomWidgets.dart';
import 'package:dtube_go/ui/pages/Explore/SearchScreen.dart';
import 'package:dtube_go/ui/pages/Explore/StaggeredFeed.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExploreMainPage extends StatefulWidget {
  ExploreMainPage({Key? key}) : super(key: key);

  @override
  _ExploreMainPageState createState() => _ExploreMainPageState();
}

class _ExploreMainPageState extends State<ExploreMainPage>
    with SingleTickerProviderStateMixin {
  List<String> _tabNames = ["Explore Videos", "Search Users/Videos"];
  List<IconData> _tabIcons = [
    FontAwesomeIcons.compass,
    FontAwesomeIcons.search
  ];
  late TabController _tabController;
  int _selectedIndex = 0;
  late String _exploreTags = "";
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    getExploreTags();
    _tabController.addListener(() {
      if (_tabController.index != _selectedIndex) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
    super.initState();
  }

  Future<String> getExploreTags() async {
    _exploreTags = await sec.getExploreTags();

    return _exploreTags;
  }

  void searchForTag(String tag) {
    setState(() {
      _tabController.index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FutureBuilder(
        future: getExploreTags(),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none ||
              projectSnap.connectionState == ConnectionState.waiting) {
            //print('project snapshot data is: ${projectSnap.data}');
            return DTubeLogoPulse(size: 40.w);
          }

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        _exploreTags != ""
                            ? BlocProvider<FeedBloc>(
                                create: (context) => FeedBloc(
                                    repository: FeedRepositoryImpl())
                                  ..add(
                                      FetchTagSearchResults(tag: _exploreTags)),
                                child: StaggeredFeed(
                                  searchTags: _exploreTags,
                                ))
                            : BlocProvider<FeedBloc>(
                                create: (context) => FeedBloc(
                                    repository: FeedRepositoryImpl())
                                  ..add(FetchFeedEvent(feedType: "HotFeed")),
                                child: StaggeredFeed(
                                  searchTags: "",
                                )),
                        MultiBlocProvider(providers: [
                          BlocProvider<SearchBloc>(
                              create: (context) => SearchBloc(
                                  repository: SearchRepositoryImpl())),
                          BlocProvider(
                              create: (context) =>
                                  FeedBloc(repository: FeedRepositoryImpl())),
                        ], child: SearchScreen()),
                      ],
                      controller: _tabController,
                    ),
                  ),
                  // ),
                ],
              ),

              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 11.h, right: 4.w),
                  //padding: EdgeInsets.only(top: 5.h),
                  child: Container(
                    width: 17.w,
                    //color: Colors.black.withAlpha(20),
                    child: TabBar(
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.white,
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          child: ShadowedIcon(
                            icon: _tabIcons[0],
                            color: Colors.white,
                            shadowColor: Colors.black,
                            size: Device.orientation == Orientation.portrait
                                ? 5.w
                                : 5.h,
                          ),
                        ),
                        Tab(
                          child: ShadowedIcon(
                            icon: _tabIcons[1],
                            color: Colors.white,
                            shadowColor: Colors.black,
                            size: Device.orientation == Orientation.portrait
                                ? 5.w
                                : 5.h,
                          ),
                        ),
                      ],
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, left: 4.w),
                  //padding: EdgeInsets.only(top: 5.h),
                  child: OverlayText(
                    text: _tabNames[_selectedIndex],
                    sizeMultiply: 1.4,
                    bold: true,
                  ),
                ),
              )
              //),
              // ),
            ],
          );
        },
      ),
    );
  }
}
