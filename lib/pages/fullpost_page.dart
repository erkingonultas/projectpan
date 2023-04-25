import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:projectpan/backend/post_handler.dart';
import 'package:projectpan/pages/comment_section.dart';
import 'package:projectpan/widgets/components.dart';

import '../backend/constants.dart';
import '../backend/models/models.dart';
import 'other_profile_page.dart';

class FullpostPage extends StatefulWidget {
  static const routeName = '/fullpost';
  const FullpostPage({
    Key? key,
    required this.currentUserId,
    required this.songName,
    required this.userName,
    required this.userPicUrl,
    required this.userUid,
    required this.postArtUrl,
    required this.postArtWidget,
    required this.postDesc,
    required this.postDate,
    required this.postId,
    required this.likes,
    this.heroId = '1',
  }) : super(key: key);

  final String currentUserId;
  final String songName;
  final String userName;
  final String userUid;
  final String userPicUrl;
  final String postArtUrl;
  final Widget postArtWidget;
  final String postDesc;
  final String postDate;
  final List likes;
  final String postId;
  final String heroId;

  @override
  State<FullpostPage> createState() => _FullpostPageState();
}

class _FullpostPageState extends State<FullpostPage> {
  bool _isCommentsExt = false;

  void _extendCommentSection() {
    setState(() {
      _isCommentsExt = !_isCommentsExt;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: botticelli,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(children: [
              PressableDough(
                onReleased: (PressableDoughReleaseDetails details) {
                  if (details.delta.dy > 10) {
                    Navigator.pop(context);
                  } else if (details.delta.dy < 10) {
                    Navigator.pop(context);
                  } else {
                    return;
                  }
                },
                child: Hero(
                  tag: widget.heroId == '0' ? widget.postArtUrl : widget.postId,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInCirc,
                    constraints: BoxConstraints(maxHeight: _isCommentsExt ? size.height * .45 : size.height * .65),
                    //height: _isCommentsExt ? size.height * .30 : size.height * .65,
                    width: size.width,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    //padding: const EdgeInsets.symmetric(vertical: 20),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.center,
                      child: widget.postArtWidget,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: woodsmoke.withOpacity(.5),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  // height: size.height * .04,
                  padding: const EdgeInsets.all(12.0).copyWith(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                        width: 20,
                        child: InkWell(
                          child: const Icon(
                            Icons.add_comment_rounded,
                            color: botticelli,
                            size: 20,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => CommentSection(
                                      postId: widget.postId,
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        height: 25,
                        width: 20,
                        child: InkWell(
                          child: const Icon(
                            Icons.send_rounded,
                            color: botticelli,
                            size: 20,
                          ),
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        height: 25,
                        width: 20,
                        child: InkWell(
                          child: const Icon(
                            Icons.bookmark_add_rounded,
                            color: botticelli,
                            size: 20,
                          ),
                          onTap: () {},
                          enableFeedback: true,
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        height: 25,
                        width: 20,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).snapshots(),
                          builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            return InkWell(
                              child: snapshot.data!['likes'].contains(widget.currentUserId)
                                  ? const Icon(
                                      Icons.thumb_up_off_alt_rounded,
                                      color: likeblue,
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.thumb_up_off_alt_outlined,
                                      color: botticelli,
                                      size: 20,
                                    ),
                              onTap: () async {
                                await PostHandler().likePost(widget.postId, widget.currentUserId, snapshot.data!['likes']);
                              },
                              enableFeedback: true,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: woodsmoke.withOpacity(.5),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  // height: size.height * .04,
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 20.0, left: 12.0),
                  child: SizedBox(
                    height: 25,
                    width: 20,
                    child: InkWell(
                      child: const Icon(Icons.arrow_back, color: botticelli),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ]),
            Row(
              children: [
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: woodsmoke.withOpacity(.85),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  // height: size.height * .04,
                  //width: size.width * .35,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      spotifyIcon,
                      const SizedBox(width: 8),
                      Text(
                        widget.songName,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w100, color: botticelli),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
            //if (!_isCommentsExt) const Spacer() else const SizedBox(height: 10),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                if (widget.userUid != widget.currentUserId) {
                  QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance.collection('users').where('userName', isEqualTo: widget.userName.toLowerCase()).get();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherProfilePage(
                        userProfile: Profile.fromSnap(snap.docs[0]),
                      ),
                    ),
                  );
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  SizedBox(height: 25, width: 25, child: RepaintBoundary(child: UserPic(picUrl: widget.userPicUrl))),
                  const SizedBox(width: 8),
                  Text(
                    widget.userName.capitalize(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: woodsmoke),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.postDesc,
                //'Quisque enim lacus, vulputate lacinia velit at, scelerisque pellentesque augue.Quisque enim lacus, vulputate lacinia velit at, scelerisque pellentesque augue.Quisque enim lacus, vulputate lacinia velit at, scelerisque pellentesque augue.Quisque enim lacus, vulputate lacinia velit at, scelerisque pellentesque augue.Quisque enim lacus, vulputate lacinia velit at, scelerisque pellentesque augue.',
                softWrap: true,
                maxLines: 8,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w100,
                  color: woodsmoke,
                  overflow: TextOverflow.visible,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //if (!_isCommentsExt) const Spacer(flex: 2) else const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 8),
              child: Text(
                widget.postDate,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w100, color: woodsmoke),
              ),
            ),

            Expanded(
                child: ListView(
              padding: const EdgeInsets.all(20).copyWith(top: 10),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(onTap: () => {_extendCommentSection()}, child: const Text('Comments', style: TextStyle(color: woodsmoke, fontSize: 14, fontWeight: FontWeight.w500))),
                const SizedBox(height: 10),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').orderBy('datePublished', descending: true).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState == ConnectionState.active) {
                      return SizedBox(
                        height: size.height * .6,
                        child: ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance.collection('users').where('userName', isEqualTo: snapshot.data!.docs[index]['name']).get();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtherProfilePage(
                                      userProfile: Profile.fromSnap(snap.docs[0]),
                                    ),
                                  ),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: snapshot.data!.docs[index]['name'].toString().capitalize(),
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: woodsmoke),
                                    ),
                                    TextSpan(
                                      text: ':   ${snapshot.data!.docs[index]['text']}\n',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w100, color: woodsmoke),
                                    ),
                                    TextSpan(
                                      text: '${snapshot.data!.docs[index]['datePublished']}',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w100, color: woodsmoke),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
