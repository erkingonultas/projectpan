import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectpan/backend/constants.dart';
import 'package:projectpan/backend/post_handler.dart';
import 'package:projectpan/widgets/textfield.dart';
import 'package:provider/provider.dart';

import '../backend/models/models.dart';
import '../widgets/components.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({
    Key? key,
    required this.postId,
  }) : super(key: key);
  final String postId;
  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late FocusNode _commentNode;
  late TextEditingController _commentController;
  late Profile userProfile;
  bool isLoading = false;

  @override
  void initState() {
    _commentNode = FocusNode(canRequestFocus: true);
    _commentController = TextEditingController();
    _commentNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _commentNode.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void post(String currentUserName, String currentUserId) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await PostHandler().postComment(
        widget.postId,
        _commentController.text,
        currentUserId,
        currentUserName,
      );
      if (res == 'post successful') {
        bildirim('Comment posted.', context);
      } else {
        bildirim(res, context);
      }
    } catch (e) {
      bildirim(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    userProfile = Provider.of<AccountInfoHandler>(context, listen: true).profile;
    return SafeArea(
      child: Scaffold(
        backgroundColor: botticelli,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: botticelli,
          automaticallyImplyLeading: false,
          title: const Text(
            'COMMENTS',
            style: TextStyle(color: woodsmoke),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(onPressed: (() => Navigator.pop(context)), icon: const Icon(Icons.arrow_back, color: woodsmoke)),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').orderBy('datePublished', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.active) {
                    return SizedBox(
                      height: size.height,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                            child: CommentCard(
                              userName: snapshot.data!.docs[index]['name'],
                              commentText: snapshot.data!.docs[index]['text'],
                              commentDate: snapshot.data!.docs[index]['datePublished'],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  SizedBox(height: 40, width: 40, child: RepaintBoundary(child: UserPic(picUrl: userProfile.userPicUrl))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextContainer(
                      controller: _commentController,
                      hintText: 'leave comment...',
                      textInputType: TextInputType.multiline,
                      focusNode: _commentNode,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 30,
                    child: GestureDetector(
                      onTap: () async {
                        if (_commentController.text.isNotEmpty) {
                          _commentNode.unfocus();
                          post(userProfile.userName, userProfile.userId);
                          _commentController.clear();
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              backgroundColor: balihai,
                              color: botticelli,
                              strokeWidth: 2,
                            )
                          : const Icon(Icons.send_rounded, color: woodsmoke),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
