import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectpan/backend/constants.dart';
import 'package:projectpan/backend/post_handler.dart';
import 'package:projectpan/backend/song_handler.dart';
import 'package:projectpan/backend/storage_handler.dart';
import 'package:projectpan/pages/concert_page.dart';
import 'package:projectpan/pages/explore_page.dart';
import 'package:projectpan/pages/profile_page.dart';
import 'package:projectpan/pages/search_page.dart';
import 'package:projectpan/pages/share_page.dart';
import 'package:projectpan/pages/top_artists_page.dart';
import 'package:provider/provider.dart';
import '../backend/models/models.dart';
import '../widgets/components.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Profile userProfile;
  late StorageHandler storageHandler;
  late PageController _pageController;
  @override
  void initState() {
    storageHandler = StorageHandler();
    _pageController = PageController(
      keepPage: true,
      initialPage: 0,
    );
    Provider.of<AccountInfoHandler>(context, listen: false).setUpAccount();

    super.initState();
  }

  // final List _destinations = [
  //   HomePage.routeName,
  //   ExplorePage.routeName,
  //   //ProfilePage.routeName,
  // ];

  int _selectedDestination = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    userProfile = Provider.of<AccountInfoHandler>(context, listen: true).profile;
    return SafeArea(
      child: Scaffold(
        backgroundColor: botticelli,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          enableFeedback: true,
          backgroundColor: ebonyclay,
          child: const Icon(
            Icons.add,
            color: botticelli,
          ),
          elevation: 25,
          onPressed: () {
            Navigator.push(
              context,
              defaultPageAnim(
                page: const SharePage(),
                alignment: Alignment.bottomCenter,
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: woodsmoke.withAlpha(245),
            indicatorColor: botticelli,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          ),
          child: NavigationBar(
            height: 60,
            animationDuration: const Duration(milliseconds: 250),
            selectedIndex: _selectedDestination,
            onDestinationSelected: (int i) {
              setState(() {
                _selectedDestination = i;
              });
              _pageController.jumpToPage(i);
            },
            destinations: [
              const NavigationDestination(
                selectedIcon: Icon(Icons.home_filled, color: woodsmoke, size: 26),
                icon: Icon(Icons.home_outlined, color: botticelli, size: 26),
                label: 'home',
              ),
              const NavigationDestination(
                selectedIcon: Icon(Icons.search_outlined, color: woodsmoke, size: 26),
                icon: Icon(Icons.search_outlined, color: botticelli, size: 26),
                label: 'share',
              ),
              const NavigationDestination(
                selectedIcon: Icon(Icons.share, color: woodsmoke, size: 26),
                icon: Icon(Icons.share_outlined, color: botticelli, size: 26),
                label: 'search',
              ),
              NavigationDestination(
                selectedIcon: RepaintBoundary(child: UserPic(picUrl: userProfile.userPicUrl, size: 30)),
                icon: RepaintBoundary(child: UserPic(picUrl: userProfile.userPicUrl, size: 30)),
                label: 'profile',
              ),
            ],
          ),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            HomeWidget(size: size, userProfile: userProfile),
            SearchPage(userProfile: userProfile),
            const ExplorePage(),
            // ignore: prefer_const_constructors
            //TopArtistsPage(),
            ProfilePage(userProfile: userProfile),
          ],
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    Key? key,
    required this.size,
    required this.userProfile,
  }) : super(key: key);

  final Size size;
  final Profile userProfile;

  static const List<String> _cityList = [
    'London',
    'Madrid',
    'Los Angeles',
  ];
  static const List<String> _concertImgList = [
    'assets/img/animals.jpg',
    'assets/img/huge_avatar.jpeg',
    'assets/img/user2.png',
  ];

  @override
  Widget build(BuildContext context) {
    final LastFmHandler lastfm = LastFmHandler();
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: botticelli,
              //toolbarHeight: 75,
              automaticallyImplyLeading: false,
              leading: const Icon(Icons.flutter_dash_rounded, size: 34, color: woodsmoke),
              title: const Text(
                'TIMPLE',
                style: TextStyle(fontFamily: 'Rubik Mono One', fontSize: 25, color: woodsmoke),
              ),
              titleSpacing: 10,
              elevation: 0,
              floating: false,
              pinned: false,
              snap: false,
              forceElevated: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 12.0, bottom: 12.0),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        defaultPageAnim(page: const SharePage(), alignment: Alignment.topRight),
                      ),
                    },
                    child: const Icon(
                      Icons.add_box_rounded,
                      color: woodsmoke,
                      size: 28,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 12.0, bottom: 12.0),
                  child: InkWell(
                    onTap: () => {bildirim('chat', context)},
                    child: chatIcon,
                  ),
                ),
              ],
            ),
            // FutureBuilder(
            //   future: FirebaseFirestore.instance.collection('users').get(),
            //   builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const SliverToBoxAdapter(child: Center(child: Text('stories are loading')));
            //     } else if (snapshot.data!.docs.isEmpty) {
            //       return const SliverToBoxAdapter(child: Text('no stories here'));
            //     } else {
            //       return SliverToBoxAdapter(
            //         child: SizedBox(
            //           height: 75,
            //           child: ListView.builder(
            //             itemBuilder: (context, index) {
            //               return Padding(
            //                 padding: const EdgeInsets.only(right: 5.0),
            //                 child: UserPic(
            //                   picUrl: snapshot.data!.docs[index]['userPicUrl'],
            //                   size: 100,
            //                 ),
            //               );
            //             },
            //             prototypeItem: UserPic(
            //               picUrl: snapshot.data!.docs[0]['userPicUrl'],
            //               size: 100,
            //             ),
            //             scrollDirection: Axis.horizontal,
            //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
            //             itemCount: snapshot.data!.docs.length,
            //           ),
            //         ),
            //       );
            //     }
            //   },
            // ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: size.height * .15,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          defaultPageAnim(
                            page: const ConcertFullPage(),
                            //alignment: Alignment.bottomCenter,
                          ),
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Container(
                            width: size.width * .35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(_concertImgList[index]),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black.withOpacity(.42), BlendMode.srcATop),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _cityList[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: botticelli),
                            ),
                          )),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                  itemCount: 3,
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Container(
            //     width: size.width,
            //     height: 45,
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20).copyWith(bottom: 0),
            //     child: TagList(tagList: tagList),
            //   ),
            // ),
            SliverToBoxAdapter(
              child: Container(
                width: size.width,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20).copyWith(bottom: 0),
                child: FutureBuilder(
                  future: lastfm.getChartTopTags(),
                  builder: (context, AsyncSnapshot<List<String>> _tagList) {
                    if (_tagList.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text('tags loading...'),
                      );
                    }
                    if (_tagList.hasData) {
                      return ListView.builder(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              horizontalOffset: 25,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      defaultPageAnim(
                                        page: TopArtistsPage(
                                          artistList: await lastfm.getTagTopArtists(_tagList.data![index]),
                                          genre: _tagList.data![index],
                                        ),
                                        //alignment: Alignment.bottomCenter,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Tag(text: _tagList.data![index].toUpperCase()),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        shrinkWrap: false,
                        itemCount: _tagList.data!.length,
                        scrollDirection: Axis.horizontal,
                        // physics: const BouncingScrollPhysics(),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'NO TAGS FOUND',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: woodsmoke, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.data!.docs.isNotEmpty) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(20.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: index != 0 ? const EdgeInsets.only(top: 20.0) : const EdgeInsets.only(top: 0.0),
                                  child: HomePost(
                                    size: size,
                                    postArtUrl: snapshot.data!.docs[index]['postArt'],
                                    postDesc: snapshot.data!.docs[index]['postDesc'],
                                    postDate: snapshot.data!.docs[index]['datePublished'],
                                    likes: snapshot.data!.docs[index]['likes'],
                                    songName: snapshot.data!.docs[index]['songName'],
                                    userUid: snapshot.data!.docs[index]['uid'],
                                    userName: snapshot.data!.docs[index]['userName'],
                                    userPicUrl: snapshot.data!.docs[index]['userPicUrl'],
                                    postId: snapshot.data!.docs[index]['postId'],
                                    currentUserId: userProfile.userId,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: snapshot.data!.docs.length,
                        //childCount: songName.length,
                      ),
                    ),
                  );
                } else {
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: size.height * .25),
                    sliver: const SliverToBoxAdapter(
                      child: Text(
                        'THERE ARE NO POSTS HERE',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: woodsmoke, fontWeight: FontWeight.bold, fontSize: 26),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
