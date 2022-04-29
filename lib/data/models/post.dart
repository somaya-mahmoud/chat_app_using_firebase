

  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:instagram_firebase/local/my_shared.dart';

  class Post {
    late String postId;
    late String userId;
    late String username;
    late String userImageUrl;
    final String postContent;
    late String postImageUrl;
    final double latitude;
    final double longitude;
    final String locationName;
    int likesCount = 0;
    bool isLiked = false;

    Post({
      required this.postContent,
      this.username = "",
      this.postImageUrl = "",
      this.postId = "",
      this.userId = "",
      this.userImageUrl = "",
      this.locationName = "Meeru island resort & spa",
      this.latitude = 0.0,
      this.longitude = 0.0,
    });

    Post.newInstance({ required this.postContent,
    this.username = "",
    this.postImageUrl = "",
    this.postId = "",
    this.userId = "",
    this.userImageUrl = "",
    this.locationName = "Meeru island resort & spa",
    this.latitude = 0.0,
    this.longitude = 0.0,
  })
  {
    postId = DateTime.now().toString() + FirebaseAuth.instance.currentUser!.uid ;
    userId = FirebaseAuth.instance.currentUser!.uid;
    username = MyShared.getString(key: "username");
    userImageUrl = MyShared.getString(key: "profileImageUrl");

    }

    Post.fromJson(Map<String, dynamic> json)
        : this(
      postId: json['postId'] ,
      userId: json['userId'] ,
      username: json['username'],
      userImageUrl: json['userImageUrl'] ,
      postContent: json['postContent'] ,
      postImageUrl: json['postImageUrl'] ,
      locationName: json['locationName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );

    Map<String, dynamic> toJson() {
      return {
        'postId': postId,
        'userId': userId,
        'username': username,
        'userImageUrl': userImageUrl,
        'postContent': postContent,
        'postImageUrl': postImageUrl,
        'locationName': locationName,
        'latitude': latitude,
        'longitude': longitude,
      };
    }

}