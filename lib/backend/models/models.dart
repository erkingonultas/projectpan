import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  const Post({
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userPicUrl,
    required this.datePublished,
    required this.songId,
    required this.postDesc,
    required this.postArt,
    required this.likes,
  });
  final String postId;
  final String userId;
  final String userName;
  final String datePublished;
  final String userPicUrl;
  final String songId;
  final String postDesc;
  final String postArt;
  final List likes;

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'uid': userId,
        'userName': userName,
        'userPicUrl': userPicUrl,
        'datePublished': datePublished,
        'songName': songId,
        'postDesc': postDesc,
        'postArt': postArt,
        'likes': likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      postId: snapshot['postId'],
      userId: snapshot['userId'],
      userName: snapshot['userName'],
      userPicUrl: snapshot['userPicUrl'],
      datePublished: snapshot['datePublished'],
      songId: snapshot['songId'],
      postDesc: snapshot['postDesc'],
      postArt: snapshot['postArt'],
      likes: snapshot['likes'],
    );
  }
}

class Profile {
  const Profile({
    required this.userId,
    required this.userName,
    required this.userMail,
    required this.userPicUrl,
    required this.joinDate,
    required this.followers,
    required this.following,
  });
  final String userId;
  final String userName;
  final String userMail;
  final String userPicUrl;
  final String joinDate;
  final List followers;
  final List following;

  Map<String, dynamic> toJson() => {
        'uid': userId,
        'userName': userName,
        'userMail': userMail,
        'userPicUrl': userPicUrl,
        'joinDate': joinDate,
        'followers': followers,
        'following': following,
      };

  static Profile fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Profile(
      followers: snapshot['followers'],
      following: snapshot['following'],
      userId: snapshot['uid'],
      userMail: snapshot['userMail'],
      userName: snapshot['userName'],
      userPicUrl: snapshot['userPicUrl'],
      joinDate: snapshot['joinDate'],
    );
  }
}
