import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_firebase/business_logic/posts/posts_cubit.dart';
import 'package:instagram_firebase/business_logic/story/add_story_cubit.dart';
import 'package:instagram_firebase/data/models/post.dart';
import 'package:instagram_firebase/data/models/story.dart';
import 'package:instagram_firebase/local/my_shared.dart';
import 'package:instagram_firebase/ui/users_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:instagram_firebase/ui/comments_screen.dart';
import 'package:instagram_firebase/ui/post_screen.dart';
import 'package:instagram_firebase/ui/story_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late PostsCubit cubit;
  late AddStoryCubit storyCubit;


  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<PostsCubit>(context);
    cubit.getPosts();
    storyCubit = BlocProvider.of<AddStoryCubit>(context);
    storyCubit.getHomeStories();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PostsCubit, PostsStates>(
          listener: (context, state) {
            print("Home state => $state");
          },

        ),
        BlocListener<AddStoryCubit, AddStoryStates>(
          listener: (context, state) {
            print("Home state => $state");
          if (state is GetStoriesDetailsSuccessState) {
              onShowStoryTapped(state.storiesDetails);
            } else if (state is AddStorySuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Story Added")));
            }
            // TODO: implement listener
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: screenAppBar(),
        body: screenBody(),
      ),
    );
  }

  AppBar screenAppBar() =>
      AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Instagram",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showPopupMenu();
              },
              icon: const Icon(Icons.add_box_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          IconButton(onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UsersScreen(),));
          }, icon: const Icon(Icons.chat_outlined)),
        ],
      );

  Widget screenBody() =>
      ListView(
        children: [
          buildStories(),
          const Divider(
            color: Colors.white,
            height: 0.1,
            thickness: 0.1,

          ),
          postsListView(),
        ],
      );

  buildStories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          SizedBox(
            height: 110,
            child: InkWell(
              onTap: () => onAddStoryTapped(),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(MyShared.getString(key: "profileImageUrl")),
                        radius: 35,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 13,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.add),
                        radius: 11,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Your story",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 110,
              child: BlocBuilder<AddStoryCubit, AddStoryStates>(
                buildWhen: (previous, current) => current is GetHomeStoriesSuccessState,
                builder: (context, state) {
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                    const SizedBox(
                      width: 10,
                    ),
                    itemBuilder: (context, index) => buildStoryItem(index),
                    itemCount: storyCubit.homeStories.length,
                    scrollDirection: Axis.horizontal,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget postsListView() {
    return BlocBuilder<PostsCubit, PostsStates>(
      buildWhen: (previous, current) {
        return current is PostsGetSuccessState ||
            current is LikePostSuccessState ||
            current is UnLikePostSuccessState;
      },
      builder: (context, state) {
        return ListView.separated(
          reverse: true,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) =>
              buildPostItem(cubit.posts[index], index),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: cubit.posts.length,
        );
      },
    );
  }

  buildStoryItem(int index) {
    Story story = storyCubit.homeStories[index];
              return InkWell(
          onTap: () => storyCubit.getStoriesDetails(story.userId!),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 36,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            Color(0xff833ab4),
                            Color(0xfffd1d1d),
                            Color(0xfffcb045),
                          ])),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        story.userImageUrl!),
                    radius: 33,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                story.username!,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        );
  }

  buildPostItem(Post post, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 26,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            Color(0xff833ab4),
                            Color(0xfffd1d1d),
                            Color(0xfffcb045),
                          ])),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.userImageUrl),
                    radius: 23,
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      post.locationName,
                      // "Meeru island resort & spa",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
        Image(
            height: 30.h,
            width: double.infinity,
            fit: BoxFit.cover,
            image: NetworkImage(
              post.postImageUrl,

            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (post.isLiked) {
                      cubit.unLikePost(postId: post.postId);
                      cubit.posts[index].isLiked = false;
                      cubit.posts[index].likesCount--;
                    } else {
                      cubit.likePost(postId: post.postId);
                      cubit.posts[index].isLiked = true;
                      cubit.posts[index].likesCount++;
                    }
                  },
                  icon: Icon(
                    post.isLiked ? Icons.favorite :
                    Icons.favorite_border,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CommentsScreen(postId: post.postId),
                        ));
                  },
                  icon: const Icon(
                    Icons.mode_comment_outlined,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                  )),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.0),
          child: Text(
            "${post.likesCount} Likes",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0),
            child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: post.username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: " "),
                  TextSpan(text: post.postContent)
                ]))),
      ],
    );
  }

  onAddStoryTapped() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    List<File> paths = images!.map((xFile) => File(xFile.path)).toList();
    storyCubit.addStories(paths);
  }

  onShowStoryTapped(List<Story> storiesDetails) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => StoryScreen(storiesDetails),
    ));
  }

  void showPopupMenu() async {
    await showMenu(
      color: Colors.black,
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 99.8, 100),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      items: [
        PopupMenuItem<String>(
          value: '1',
          child: Row(
            children: [
              Text(
                'Post',
                style: TextStyle(color: Colors.white),

              ),
              Spacer(),
              SizedBox(
                width: 8,
              ),
              Icon(MaterialIcons.post_add, color: Colors.white),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '2',
          child: Row(
            children: [
              Text(
                'Story',
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              SizedBox(
                width: 8,
              ),
              Icon(MaterialCommunityIcons.plus_circle_outline,
                  color: Colors.white),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '3',
          child: Row(
            children: [
              Text(
                'Reel',
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              SizedBox(
                width: 8,
              ),
              Icon(MaterialIcons.live_tv, color: Colors.white),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '4',
          child: Row(
            children: [
              Text(
                'Live',
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              SizedBox(
                width: 8,
              ),
              Icon(Fontisto.livestream, color: Colors.white),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then<void>((String? itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        pickImage();
      } else if (itemSelected == "2") {
        //code here
      } else {
        //code here
      }
    });
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      File file = File(value!.path);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PostScreen(
                  imageFile: file,
                ),
          )).then((value) {
        print('ADD Post');
        cubit.getPosts();
      });
    });
  }
}