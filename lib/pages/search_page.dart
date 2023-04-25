import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:projectpan/backend/post_handler.dart';
import 'package:projectpan/pages/other_profile_page.dart';

import '../backend/constants.dart';
import '../backend/models/models.dart';
import '../widgets/components.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';
  const SearchPage({
    Key? key,
    required this.userProfile,
  }) : super(key: key);
  final Profile userProfile;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showUsers = false;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  follow(uid, followId) async {
    try {
      String res = await PostHandler().followUser(uid, followId);
      if (res == 'unfollowed' || res == 'followed') {
        bildirim(res, context);
        Navigator.pop(context);
      } else {
        bildirim(res, context);
      }
    } catch (e) {
      bildirim(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            height: 75,
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Find a user, tag, concert or a festival...',
                focusColor: opium,
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _showUsers = false;
                          });
                        },
                        child: const Icon(Icons.close_rounded))
                    : null,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
              onFieldSubmitted: (String _) {
                if (_searchController.text.isNotEmpty) {
                  setState(() {
                    _showUsers = true;
                  });
                }
              },
            ),
          ),
          if (!_showUsers)
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').orderBy('datePublished', descending: true).get(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.docs.isNotEmpty) {
                  return SizedBox(
                    height: size.height * .75,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
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
                                  currentUserId: widget.userProfile.userId,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                      //childCount: songName.length,
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: size.height * .25),
                    child: const SliverToBoxAdapter(
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
          if (_showUsers)
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('users').where('userName', isGreaterThanOrEqualTo: _searchController.text.toLowerCase()).get(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return SizedBox(
                  height: size.height * .45,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!.docs[index]['userPicUrl']),
                        ),
                        title: Text(snapshot.data!.docs[index]['userName'].toString().capitalize()),
                        onTap: () async {
                          var postsnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: snapshot.data!.docs[index]['uid']).get();
                          int postLen = postsnap.docs.length;
                          showModalBottomSheet(
                            context: context,
                            elevation: 10,
                            isScrollControlled: false,
                            enableDrag: false,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return PressableDough(
                                onReleased: (PressableDoughReleaseDetails details) {
                                  if (snapshot.data!.docs[index]['uid'] != widget.userProfile.userId) {
                                    if (details.delta.dy < -2) {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OtherProfilePage(
                                            userProfile: Profile.fromSnap(snapshot.data!.docs[index]),
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      //height: size.height * .5,
                                      color: botticelli,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 20),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(width: 20),
                                              UserPic(picUrl: snapshot.data!.docs[index]['userPicUrl'], size: 100),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                child: RichText(
                                                  textAlign: TextAlign.justify,
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: "${snapshot.data!.docs[index]['userName'].toString().capitalize()}\n",
                                                        style: const TextStyle(
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.w500,
                                                          color: woodsmoke,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'Joined in ${snapshot.data!.docs[index]['joinDate']}',
                                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: woodsmoke),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              if (snapshot.data!.docs[index]['uid'] != widget.userProfile.userId)
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => OtherProfilePage(
                                                          userProfile: Profile.fromSnap(snapshot.data!.docs[index]),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(Icons.fullscreen),
                                                ),
                                            ],
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
                                          const SizedBox(height: 20),
                                          const Text(
                                            'profile desc...',
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                                            textAlign: TextAlign.left,
                                          ),
                                          const SizedBox(height: 20),
                                          if (snapshot.data!.docs[index]['uid'] != widget.userProfile.userId)
                                            // TODO: Check if the profile is private
                                            Container(
                                              decoration: BoxDecoration(
                                                color: woodsmoke,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: woodsmoke.withOpacity(.25),
                                                    offset: const Offset(0, 5),
                                                    blurRadius: 15,
                                                  )
                                                ],
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: const Text('send message', style: TextStyle(color: botticelli, fontSize: 12, fontWeight: FontWeight.w500)),
                                              ),
                                            ),
                                          //const SizedBox(height: 20),

                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
