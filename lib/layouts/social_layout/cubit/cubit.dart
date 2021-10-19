import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_app/layouts/social_layout/cubit/state.dart';
import 'package:flutter_app/models/social_app/message_model.dart';
import 'package:flutter_app/models/social_app/post_model.dart';
import 'package:flutter_app/models/social_app/social_user_model.dart';
import 'package:flutter_app/modules/social_app/chats/chats_screen.dart';
import 'package:flutter_app/modules/social_app/feeds/feeds_screen.dart';
import 'package:flutter_app/modules/social_app/new_post/new_post_screen.dart';
import 'package:flutter_app/modules/social_app/settings/settings_screen.dart';
import 'package:flutter_app/modules/social_app/users/users_screen.dart';
import 'package:flutter_app/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print(value.data());
      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 1) getChats();
    if (index == 3) getUsers();
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  String profileImageUrl;

  void uploadProfileImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileImageSuccessState());
        print(value);
        profileImageUrl = value;
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  String coverImageUrl;

  void uploadCoverImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadCoverImageSuccessState());
        print(value);
        coverImageUrl = value;

        updateUser(
          name: name,
          phone: phone,
          bio: bio,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUserImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());
    if (coverImage != null) {
      uploadCoverImage(
        name: name,
        phone: phone,
        bio: bio,
      );
    }
    if (profileImage != null) {
      uploadProfileImage(
        name: name,
        phone: phone,
        bio: bio,
      );
    } else {
      updateUser(
        name: name,
        phone: phone,
        bio: bio,
      );
    }
  }

  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      image: profileImageUrl ?? userModel.image,
      cover: coverImageUrl ?? userModel.cover,
      email: userModel.email,
      uId: userModel.uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    @required String dateTime,
    @required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    @required String dateTime,
    @required String text,
    String postImage,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel.name,
      image: userModel.image,
      uId: userModel.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comments = [];

  void getPosts() {
    emit(SocialGetPostsLoadingState());

    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          emit(SocialGetPostsSuccessState());
        }).catchError((error) {});
        element.reference.collection('comments').get().then((value) {
          comments.add(value.docs.length);
          emit(SocialGetPostsSuccessState());
        }).catchError((error) {});
      });
    }).catchError((error) {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(int postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postsId[postId])
        .collection('likes')
        .doc(userModel.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState());
    });
  }

  void commentPost(int postId, String text) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postsId[postId])
        .collection('comments')
        .doc(userModel.uId)
        .set({
      'comment': text,
    }).then((value) {
      emit(SocialCommentPostSuccessState());
    }).catchError((error) {
      emit(SocialCommentPostErrorState());
    });
  }

  bool isWriting = false;
  String postId;

  void onWriting(String id) {
    isWriting = !isWriting;
    if (isWriting)
      postId = id;
    else
      postId = '';
    emit(SocialChangeWritingState());
  }

  List<SocialUserModel> chats = [];

  void getChats() {
    emit(SocialGetChatsLoadingState());

    if (chats.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel.uId)
            chats.add(SocialUserModel.fromJson(element.data()));
        });

        emit(SocialGetChatsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetChatsErrorState(error.toString()));
      });
  }

  List<SocialUserModel> users = [];

  void getUsers() {
    emit(SocialGetAllUsersLoadingState());

    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          users.add(SocialUserModel.fromJson(element.data()));
        });

        emit(SocialGetAllUsersLoadingState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
  }

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String text,
    String image,
  })
  {
    MessageModel message = MessageModel(
      senderId: userModel.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
      image: image??'',
    );

    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(message.toMap())
    .then((value)
    {
      emit(SocialSendMessageSuccessState());
    })
    .catchError((error)
    {
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('messages')
        .add(message.toMap())
        .then((value)
    {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error)
    {
      emit(SocialSendMessageErrorState());
    });

  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
  })
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages = [];
      event.docs.forEach((element)
      {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(SocialGetMessagesSuccessState());
    });
  }

  File messageImage;

  Future<void> getMessageImage() async
  {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      emit(SocialMessageImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialMessageImagePickedErrorState());
    }
  }

  void removeMessageImage() {
    messageImage = null;
    emit(SocialRemoveMessageImageState());
  }

  void uploadMessageImage({
    @required String receiverId,
    @required String dateTime,
  })
  {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chats/images/${Uri.file(messageImage.path).pathSegments.last}')
        .putFile(messageImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        sendMessage(
          receiverId: receiverId,
          dateTime: dateTime,
          text: '',
          image: value,
        );

        messageImage = null;
      }).catchError((error) {
        emit(SocialSendMessageErrorState());
      });
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }
}
