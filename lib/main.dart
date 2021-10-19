import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/layouts/social_layout/cubit/cubit.dart';
import 'package:flutter_app/layouts/social_layout/cubit/state.dart';
import 'package:flutter_app/layouts/social_layout/social_layout.dart';
import 'package:flutter_app/modules/social_app/login/social_login_screen.dart';

import 'package:flutter_app/shared/bloc_observe.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_app/shared/components/constants.dart';
import 'package:flutter_app/shared/network/local/cache_helper.dart';
import 'package:flutter_app/shared/network/remote/dio_helper.dart';
import 'package:flutter_app/shared/style/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async
{
  print(message.data.toString());
  showToast(message: 'onBackground', state: ToastStates.SUCCESS,);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onMessage.listen((event)
  {
    print(event.data.toString());
    showToast(message: 'on message', state: ToastStates.SUCCESS,);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print(event.data.toString());
    showToast(message: 'open message', state: ToastStates.SUCCESS,);
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  uId = CacheHelper.getData(key: 'uId');

  if(uId != null)
    widget = SocialLayout();
  else
    widget = SocialLoginScreen();

  runApp(MyApp(isDark, widget));
}

class MyApp extends StatelessWidget
{
  final bool isDark;
  final Widget startWidget;

  MyApp(this.isDark, this.startWidget);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          create: (context) => SocialCubit()..getUserData()..getPosts(),
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            home: startWidget,
            themeMode: ThemeMode.light,
            // themeMode: NewsCubit
            //     .get(context)
            //     .isDark
            //     ? ThemeMode.dark
            //     : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
