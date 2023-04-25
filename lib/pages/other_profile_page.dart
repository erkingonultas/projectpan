import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:projectpan/backend/post_handler.dart';
import 'package:provider/provider.dart';

import '../backend/constants.dart';
import '../backend/models/models.dart';
import '../widgets/components.dart';

class OtherProfilePage extends StatefulWidget {
  static const routeName = 'otherprofile';
  const OtherProfilePage({Key? key, required this.userProfile}) : super(key: key);
  final Profile userProfile;
  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  bool isFollowing = false;
  int postLen = 0;
  late Profile currentProfile;
  List followers = [];
  follow(uid, followId) async {
    try {
      String res = await PostHandler().followUser(uid, followId);
      if (res == 'unfollowed' || res == 'followed') {
        bildirim(res, context);
        setState(() {
          isFollowing = res == 'followed';
        });
      } else {
        bildirim(res, context);
      }
    } catch (e) {
      bildirim(e.toString(), context);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    var postsnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.userProfile.userId).get();
    currentProfile = Provider.of<AccountInfoHandler>(context, listen: false).profile;
    setState(() {
      followers = widget.userProfile.followers;
      postLen = postsnap.docs.length;
      isFollowing = followers.contains(currentProfile.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: botticelli,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: const BackButton(color: woodsmoke),
        ),
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
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
                        case 'report':
                          bildirim('report', context);
                          break;

                        default:
                      }
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem<String>(
                          value: 'report',
                          child: Text('Report', style: TextStyle(fontSize: 14, color: woodsmoke)),
                        ),
                      ];
                    },
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
              Divider(color: opium.withOpacity(.1), thickness: 1, endIndent: 20, indent: 20, height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
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
                        onTap: () async {
                          follow(currentProfile.userId, widget.userProfile.userId);
                        },
                        child: Center(
                          child: !isFollowing
                              ? const Text(
                                  'follow',
                                  style: TextStyle(color: botticelli, fontSize: 12, fontWeight: FontWeight.w500),
                                )
                              : const Text(
                                  'unfollow',
                                  style: TextStyle(color: botticelli, fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
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
                  const SizedBox(width: 20),
                ],
              ),
              const Spacer(),
              Expanded(
                flex: 15,
                child: FutureBuilder(
                  future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.userProfile.userId).get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.data!.docs.isNotEmpty) {
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
                      child: Text('NO POSTS HERE'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
