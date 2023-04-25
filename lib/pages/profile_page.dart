import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:projectpan/backend/auth_handler.dart';
import 'package:projectpan/pages/login_page.dart';
import 'package:projectpan/widgets/components.dart';
import 'package:shimmer/shimmer.dart';

import '../backend/constants.dart';
import '../backend/models/models.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  const ProfilePage({Key? key, required this.userProfile}) : super(key: key);
  final Profile userProfile;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<ProfilePage> {
  late TabController _tabController;
  int postLen = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getPostLen();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  getPostLen() async {
    var postsnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.userProfile.userId).get();

    setState(() {
      postLen = postsnap.docs.length;
    });
  }

  void _signOut() async {
    String res = await AuthHandler().signOut();
    if (res == 'successful') {
      bildirim('Sign out successful', context);
      Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
    } else {
      bildirim(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserPic(picUrl: widget.userProfile.userPicUrl, size: 100),
              const SizedBox(width: 40),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "${widget.userProfile.userName.capitalize()}\n",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: woodsmoke),
                    ),
                    TextSpan(
                      text: 'Joined in ${widget.userProfile.joinDate}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: woodsmoke),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PopupMenuButton(
                color: botticelli,
                elevation: 25,
                enableFeedback: true,
                onSelected: (String tip) {
                  switch (tip) {
                    case 'sign-out':
                      _signOut();
                      break;

                    case 'set-up-tags':
                      bildirim('set-up-tags', context);
                      break;
                    default:
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem<String>(
                      value: 'sign-out',
                      child: Text('Sign Out', style: TextStyle(fontSize: 14, color: woodsmoke)),
                    ),
                    PopupMenuItem<String>(
                      value: 'set-up-tags',
                      child: Text('Set Your Interests', style: TextStyle(fontSize: 14, color: woodsmoke)),
                    ),
                  ];
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'profile desc...',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: "Songs Shared\n",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: woodsmoke),
                    ),
                    TextSpan(
                      text: '$postLen',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: woodsmoke),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Likes Artists\n",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: woodsmoke),
                    ),
                    TextSpan(
                      text: '37',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: woodsmoke),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(color: opium.withOpacity(.1), thickness: 1, endIndent: 20, indent: 20),
          SizedBox(
            height: 40,
            child: TabBar(
              controller: _tabController,
              enableFeedback: true,
              indicatorColor: woodsmoke,
              labelColor: woodsmoke,
              isScrollable: false,
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w300),
              tabs: const [
                Text('Shared'),
                Text('Saved'),
              ],
            ),
          ),
          Expanded(
            flex: 15,
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.userProfile.userId).get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: SizedBox(height: 50, width: 50));
                    }
                    if (snapshot.data!.docs.isNotEmpty) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 110,
                          crossAxisCount: 1,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: ProfilePostContainer(
                                  songName: 'songName',
                                  userName: snapshot.data!.docs[index]['userName'],
                                  postArtUrl: snapshot.data!.docs[index]['postArt'],
                                  userUid: snapshot.data!.docs[index]['uid'],
                                  postDesc: snapshot.data!.docs[index]['postDesc'],
                                  postDate: snapshot.data!.docs[index]['datePublished'],
                                  postId: snapshot.data!.docs[index]['postId'],
                                  likes: snapshot.data!.docs[index]['likes'],
                                  currentUserId: widget.userProfile.userId,
                                  userPicUrl: snapshot.data!.docs[index]['userPicUrl'],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: Text('CREATE YOUR FIRST POST NOW!'),
                    );
                  },
                ),
                const Center(
                  child: Text('Saved'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 110,
        crossAxisCount: 1,
        mainAxisSpacing: 8,
      ),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 200.0,
            height: 100.0,
            child: Shimmer.fromColors(
              baseColor: balihai,
              highlightColor: botticelli,
              child: Container(
                color: opium,
                width: 200,
                height: 100,
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 200.0,
            height: 100.0,
            child: Shimmer.fromColors(
              baseColor: balihai,
              highlightColor: botticelli,
              child: Container(
                color: opium,
                width: 200,
                height: 100,
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 200.0,
            height: 100.0,
            child: Shimmer.fromColors(
              baseColor: balihai,
              highlightColor: botticelli,
              child: Container(
                color: opium,
                width: 200,
                height: 100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
