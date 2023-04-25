// ignore_for_file: unnecessary_this

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectpan/backend/post_handler.dart';
import 'package:projectpan/backend/song_handler.dart';
import 'package:projectpan/pages/fullpost_page.dart';
import 'package:shimmer/shimmer.dart';
import '../backend/constants.dart';
import '../backend/models/models.dart';
import '../pages/other_profile_page.dart';

class Tag extends StatelessWidget {
  const Tag({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: woodsmoke,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: botticelli),
      ),
    );
  }
}

class TagList extends StatelessWidget {
  const TagList({Key? key, required this.tagList}) : super(key: key);
  final List<String> tagList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
              onTap: () {
                LastFmHandler().getChartTopTags();
                // Navigator.push(
                //   context,
                //   defaultPageAnim(
                //     page: const TopArtistsPage(),
                //     //alignment: Alignment.bottomCenter,
                //   ),
                // );
              },
              child: Tag(text: tagList[index])),
        );
      }),
      shrinkWrap: false,
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      // physics: const BouncingScrollPhysics(),
    );
  }
}

class UserPic extends StatelessWidget {
  const UserPic({Key? key, required this.picUrl, this.size = 25})
      : super(key: key);
  final String picUrl;
  final double size;
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          border: Border.all(color: botticelli, width: 1),
          borderRadius: BorderRadius.circular(50)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: picUrl.isEmpty
            ? const Placeholder()
            : FittedBox(
                fit: BoxFit.cover,
                child: Image.network(
                  picUrl,
                ),
              ),
      ),
    );
  }
}

class HomePost extends StatelessWidget {
  const HomePost({
    Key? key,
    required this.size,
    required this.songName,
    required this.userName,
    required this.userPicUrl,
    required this.postArtUrl,
    required this.userUid,
    required this.postDesc,
    required this.postDate,
    required this.postId,
    required this.likes,
    required this.currentUserId,
  }) : super(key: key);

  final Size size;
  final String songName;
  final String userName;
  final String userPicUrl;
  final String postArtUrl;
  final String userUid;
  final String postDesc;
  final String postDate;
  final String postId;
  final List likes;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullpostPage(
            currentUserId: currentUserId,
            postArtUrl: postArtUrl,
            postDesc: postDesc,
            postDate: postDate,
            postId: postId,
            likes: likes,
            songName: songName,
            userName: userName,
            userUid: userUid,
            userPicUrl: userPicUrl,
            postArtWidget: Image.network(
              postArtUrl,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return child;
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: Shimmer.fromColors(
                      baseColor: balihai,
                      highlightColor: botticelli,
                      child: Container(
                        color: opium,
                        width: 200,
                        height: 100,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      child: Container(
        height: size.width * .53437,
        width: size.width * .95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: woodsmoke.withOpacity(.4),
              offset: const Offset(0, 4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Hero(
              tag: postId,
              child: Container(
                height: 500,
                width: 500,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                  child: Image.network(
                    postArtUrl,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return SizedBox(
                          height: 50,
                          width: 50,
                          child: Shimmer.fromColors(
                            baseColor: botticelli,
                            highlightColor: ebonyclay,
                            child: Container(
                              color: opium,
                              width: 200,
                              height: 100,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: woodsmoke.withOpacity(.85),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
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
                          songName,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w100,
                              color: botticelli),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: woodsmoke.withOpacity(.65),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                // height: size.height * .04,
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, right: 20.0, left: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: RepaintBoundary(
                            child: UserPic(picUrl: userPicUrl))),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        userName.capitalize(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: botticelli,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Text(
                        postDesc,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w100,
                            color: botticelli),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      width: 20,
                      child: InkWell(
                        child: const Icon(Icons.bookmark_add_rounded,
                            color: botticelli),
                        onTap: () {},
                        enableFeedback: true,
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 25,
                      width: 20,
                      child: InkWell(
                        child: likes.contains(currentUserId)
                            ? const Icon(
                                Icons.thumb_up_off_alt_rounded,
                                color: likeblue,
                              )
                            : const Icon(
                                Icons.thumb_up_off_alt_outlined,
                                color: botticelli,
                              ),
                        onTap: () async {
                          await PostHandler()
                              .likePost(postId, currentUserId, likes);
                        },
                        enableFeedback: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostPreview extends StatelessWidget {
  const PostPreview({
    Key? key,
    required this.size,
    required this.songName,
    required this.userName,
    required this.userPicUrl,
    this.postArtUrl,
    required this.postDesc,
  }) : super(key: key);

  final Size size;
  final String songName;
  final String userName;
  final String userPicUrl;
  final Uint8List? postArtUrl;

  final String postDesc;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: postArt.width != null ? postArt.width! * .53437 : size.width * .85,
      // width: postArt.width != null ? postArt.width! * .95 : size.width * .95,
      height: size.width * .53437,
      width: size.width * .95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: woodsmoke.withOpacity(.4),
            offset: const Offset(0, 4),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          postArtUrl != null
              ? Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: MemoryImage(postArtUrl!),
                      fit: BoxFit.cover,
                      alignment: FractionalOffset.center,
                    ),
                  ),
                )
              : SizedBox(
                  height: size.height,
                  width: size.width,
                ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: woodsmoke.withOpacity(.75),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.play_arrow,
                        size: 20,
                        color: botticelli,
                      ),
                      Text(
                        songName,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w100,
                            color: botticelli),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: woodsmoke.withOpacity(.55),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              // height: size.height * .04,
              padding: const EdgeInsets.only(
                  top: 12.0, bottom: 12.0, right: 20.0, left: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                        border: Border.all(color: botticelli, width: 1),
                        borderRadius: BorderRadius.circular(50)),
                    child: UserPic(picUrl: userPicUrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      userName.capitalize(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: botticelli),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: Text(
                      postDesc,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w100,
                          color: botticelli),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard(
      {Key? key,
      required this.userName,
      required this.commentText,
      required this.commentDate})
      : super(key: key);
  final String userName;
  final String commentText;
  final String commentDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: woodsmoke.withOpacity(.5), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(maxHeight: 55, minHeight: 25),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
                  .instance
                  .collection('users')
                  .where('userName', isEqualTo: userName)
                  .get();
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
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: userName.capitalize(),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: woodsmoke),
                  ),
                  TextSpan(
                    text: ':   $commentText',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: woodsmoke),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            commentDate,
            style: const TextStyle(
                color: woodsmoke, fontSize: 10, fontWeight: FontWeight.w100),
          ),
        ],
      ),
    );
  }
}

class ProfilePostContainer extends StatelessWidget {
  const ProfilePostContainer({
    Key? key,
    required this.songName,
    required this.userName,
    required this.userPicUrl,
    required this.postArtUrl,
    required this.userUid,
    required this.postDesc,
    required this.postDate,
    required this.postId,
    required this.likes,
    required this.currentUserId,
  }) : super(key: key);

  final String songName;
  final String userName;
  final String userPicUrl;
  final String postArtUrl;
  final String userUid;
  final String postDesc;
  final String postDate;
  final String postId;
  final List likes;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullpostPage(
            currentUserId: currentUserId,
            postArtUrl: postArtUrl,
            postDesc: postDesc,
            postDate: postDate,
            postId: postId,
            likes: likes,
            songName: songName,
            userName: userName.capitalize(),
            userUid: userUid,
            heroId: '0',
            userPicUrl: userPicUrl,
            postArtWidget: Image.network(
              postArtUrl,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return child;
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: Shimmer.fromColors(
                      baseColor: balihai,
                      highlightColor: botticelli,
                      child: Container(
                        color: opium,
                        width: 200,
                        height: 100,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Hero(
              tag: postArtUrl,
              child: Container(
                height: 500,
                width: 500,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                  child: Image.network(
                    postArtUrl,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return SizedBox(
                          height: 50,
                          width: 50,
                          child: Shimmer.fromColors(
                            baseColor: balihai,
                            highlightColor: botticelli,
                            child: Container(
                              color: opium,
                              width: 200,
                              height: 100,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      //color: woodsmoke.withOpacity(.20),
                      boxShadow: [
                        BoxShadow(
                          color: woodsmoke.withOpacity(.35),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    // height: size.height * .04,
                    //width: size.width * .35,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        spotifyIcon,
                        const SizedBox(width: 8),
                        Text(
                          songName,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                              color: botticelli),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryPage extends StatelessWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

bildirim(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text, textAlign: TextAlign.center),
      backgroundColor: woodsmoke,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(15).copyWith(bottom: 50),
      duration: const Duration(seconds: 6),
      elevation: 15,
    ),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
